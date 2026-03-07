"""Tests for transfer matrix construction, Fredholm coefficients, and cycle detection.

Verifies the core spectral machinery used in conjectures 1-3 and 5:
- Transfer matrix has exactly one nonzero entry per column (deterministic map)
- Matrix entries match hand computations for small k
- Spectral radius matches known values
- Fredholm coefficients satisfy algebraic identities
- Cycle detection finds known fixed points and modular cycles
"""

import math
import os
import sys

import numpy as np
import pytest
from numpy.testing import assert_allclose
from scipy.linalg import eig

# analysis/ is not a package; add it to sys.path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "analysis"))
from zeta_continuation import (
    _find_cycles,
    _functional_graph,
    build_transfer_matrix,
    build_transfer_matrix_rational,
    fredholm_coefficients,
    syracuse_general,
    v_sequence_general,
)


# ---------------------------------------------------------------------------
# syracuse_general
# ---------------------------------------------------------------------------
class TestSyracuseGeneral:
    def test_standard_collatz_1(self):
        """3*1+1=4 -> 1, v=2."""
        result, v = syracuse_general(1, 3, 1)
        assert result == 1
        assert v == 2

    def test_standard_collatz_3(self):
        """3*3+1=10 -> 5, v=1."""
        result, v = syracuse_general(3, 3, 1)
        assert result == 5
        assert v == 1

    def test_standard_collatz_7(self):
        """3*7+1=22 -> 11, v=1."""
        result, v = syracuse_general(7, 3, 1)
        assert result == 11
        assert v == 1

    def test_x1_identity(self):
        """1*n+1 = n+1 for odd n, so result = (n+1)/2^v."""
        result, v = syracuse_general(3, 1, 1)
        # 1*3+1=4=2^2 -> 1, v=2
        assert result == 1
        assert v == 2

    def test_x5(self):
        """5*1+1=6=2*3, v=1, result=3."""
        result, v = syracuse_general(1, 5, 1)
        assert result == 3
        assert v == 1

    def test_negative_y(self):
        """3*1+(-1)=2=2^1*1, v=1, result=1."""
        result, v = syracuse_general(1, 3, -1)
        assert result == 1
        assert v == 1

    def test_nonpositive_returns_none(self):
        """When xn+y <= 0, return (None, 0)."""
        result, v = syracuse_general(1, 1, -3)
        assert result is None
        assert v == 0


# ---------------------------------------------------------------------------
# v_sequence_general
# ---------------------------------------------------------------------------
class TestVSequenceGeneral:
    def test_standard_collatz_7(self):
        """Standard Collatz: 7 -> 11 -> 17 -> 13 -> 5 -> 1 -> 1 (cycle).
        v-values: 1, 1, 2, 3, 4."""
        vs = v_sequence_general(7, 3, 1)
        assert vs[:5] == [1, 1, 2, 3, 4]

    def test_x1_fixed_point(self):
        """x=1, y=1: 3 -> (3+1)/4=1 -> (1+1)/2=1 (cycle). v=[2, 1]."""
        vs = v_sequence_general(3, 1, 1)
        assert vs == [2, 1]

    def test_bailout_large_n(self):
        """Starting from a large n with x=7, should bail out due to 10^15 limit."""
        vs = v_sequence_general(10**14 + 1, 7, 1, max_steps=100)
        # 7 * 10^14 ≈ 7e14, grows fast — should bail out well before 100 steps
        assert len(vs) < 100


# ---------------------------------------------------------------------------
# Transfer matrix: hand computation at k=3
# ---------------------------------------------------------------------------
class TestTransferMatrixK3:
    """Hand-verified transfer matrix for x=3, y=1, k=3.

    mod=8, odd residues={1,3,5,7}, indices={0,1,2,3}.

    j=1: 3*1+1=4=2^2*1, v=2, target=1 mod 8=1, P[0,0]=0.25
    j=3: 3*3+1=10=2*5,  v=1, target=5 mod 8=5, P[2,1]=0.5
    j=5: 3*5+1=16=2^4*1,v=4, target=1 mod 8=1, P[0,2]=0.0625
    j=7: 3*7+1=22=2*11, v=1, target=3 mod 8=3, P[1,3]=0.5
    """

    @pytest.fixture()
    def k3_matrix(self):
        return build_transfer_matrix(3, 1, 3)

    def test_shape(self, k3_matrix):
        mat, odd_res, idx_map = k3_matrix
        assert mat.shape == (4, 4)
        assert odd_res == [1, 3, 5, 7]
        assert idx_map == {1: 0, 3: 1, 5: 2, 7: 3}

    def test_hand_computed_entries(self, k3_matrix):
        mat, _, _ = k3_matrix
        expected = np.array(
            [
                [0.25, 0.0, 0.0625, 0.0],
                [0.0, 0.0, 0.0, 0.5],
                [0.0, 0.5, 0.0, 0.0],
                [0.0, 0.0, 0.0, 0.0],
            ]
        )
        assert_allclose(mat, expected)

    def test_one_nonzero_per_column(self, k3_matrix):
        """Each column has exactly one nonzero entry (deterministic map)."""
        mat, _, _ = k3_matrix
        for col in range(mat.shape[1]):
            assert np.count_nonzero(mat[:, col]) == 1

    def test_spectral_radius(self, k3_matrix):
        """Only cycle is {1} with v=2, so rho = 2^{-2} = 0.25."""
        mat, _, _ = k3_matrix
        eigenvalues = eig(mat, right=False)
        rho = max(abs(eigenvalues))
        assert_allclose(rho, 0.25, atol=1e-12)


# ---------------------------------------------------------------------------
# Transfer matrix: structural properties for larger k
# ---------------------------------------------------------------------------
class TestTransferMatrixStructure:
    @pytest.mark.parametrize("k", [3, 4, 5, 6, 7, 8])
    def test_one_nonzero_per_column(self, k):
        """Deterministic map: each column has exactly one nonzero entry."""
        mat, _, _ = build_transfer_matrix(3, 1, k)
        for col in range(mat.shape[1]):
            assert np.count_nonzero(mat[:, col]) == 1

    @pytest.mark.parametrize("k", [3, 4, 5, 6, 7, 8])
    def test_correct_dimensions(self, k):
        """Matrix should be 2^{k-1} x 2^{k-1}."""
        mat, odd_res, _ = build_transfer_matrix(3, 1, k)
        n = 2 ** (k - 1)
        assert mat.shape == (n, n)
        assert len(odd_res) == n

    @pytest.mark.parametrize("k", [3, 4, 5, 6, 7])
    def test_column_weights_are_negative_powers_of_two(self, k):
        """Each nonzero entry is 2^{-v} for some positive integer v."""
        mat, _, _ = build_transfer_matrix(3, 1, k)
        for col in range(mat.shape[1]):
            nz = mat[:, col]
            nz = nz[nz != 0]
            assert len(nz) == 1
            w = nz[0]
            assert w > 0
            v = -math.log2(w)
            assert_allclose(v, round(v), atol=1e-12)
            assert round(v) >= 1  # v >= 1 since xn+y is even for odd x, odd n, odd y

    @pytest.mark.parametrize("x", [1, 3, 5, 7, 9])
    def test_various_x_one_nonzero_per_column(self, x):
        """Deterministic map property holds for all odd x."""
        mat, _, _ = build_transfer_matrix(x, 1, 5)
        for col in range(mat.shape[1]):
            assert np.count_nonzero(mat[:, col]) == 1


# ---------------------------------------------------------------------------
# Spectral radius: known values
# ---------------------------------------------------------------------------
class TestSpectralRadius:
    @pytest.mark.parametrize("k", [3, 4, 5, 6, 7, 8, 9])
    def test_rho_collatz_one_quarter(self, k):
        """For k=3..9 (not in exceptional set E), rho(3,1) = 0.25 exactly.

        These k have only the fixed point {1} as a cycle.
        """
        mat, _, _ = build_transfer_matrix(3, 1, k)
        eigenvalues = eig(mat, right=False)
        rho = max(abs(eigenvalues))
        assert_allclose(rho, 0.25, atol=1e-10)

    def test_rho_less_than_one_k10(self):
        """k=10 is in exceptional set E but rho < 1."""
        mat, _, _ = build_transfer_matrix(3, 1, 10)
        eigenvalues = eig(mat, right=False)
        rho = max(abs(eigenvalues))
        assert rho < 1.0
        assert rho > 0.25  # Not at the default 1/4

    def test_rho_x1_is_half(self):
        """x=1, y=1: T(n)=(n+1)/2^v. For odd n, n+1 is even with v>=1.
        At k=4 the only cycle is {1}: 1+1=2, v=1, target=1. rho=2^{-1}=0.5."""
        mat, _, _ = build_transfer_matrix(1, 1, 4)
        eigenvalues = eig(mat, right=False)
        rho = max(abs(eigenvalues))
        assert_allclose(rho, 0.5, atol=1e-10)

    def test_rho_bounded_by_half(self):
        """For any odd x with odd y, v >= 1 always, so rho <= 0.5.

        The modular spectral radius measures contraction per mod-2^k step,
        not the full growth factor x/2^v. The phase transition at x=4
        is about the Lyapunov exponent, not the modular rho.
        """
        for x in [5, 7, 9, 11]:
            mat, _, _ = build_transfer_matrix(x, 1, 6)
            eigenvalues = eig(mat, right=False)
            rho = max(abs(eigenvalues))
            assert rho <= 0.5 + 1e-10, f"x={x}: rho={rho}"


# ---------------------------------------------------------------------------
# Fredholm coefficients
# ---------------------------------------------------------------------------
class TestFredholmCoefficients:
    def test_constant_term_is_one(self):
        """c[0] = 1.0 always (constant term of det(I - zP))."""
        mat, _, _ = build_transfer_matrix(3, 1, 5)
        coeffs = fredholm_coefficients(mat)
        assert_allclose(coeffs[0], 1.0, atol=1e-12)

    def test_length_equals_n_plus_one(self):
        """Polynomial of degree N has N+1 coefficients."""
        for k in [3, 4, 5, 6]:
            mat, _, _ = build_transfer_matrix(3, 1, k)
            coeffs = fredholm_coefficients(mat)
            assert len(coeffs) == 2 ** (k - 1) + 1

    def test_linear_coefficient_is_neg_trace(self):
        """c[1] = -trace(P).  det(I-zP) = 1 - z*tr(P) + ..."""
        mat, _, _ = build_transfer_matrix(3, 1, 5)
        coeffs = fredholm_coefficients(mat)
        assert_allclose(coeffs[1], -np.trace(mat), atol=1e-12)

    def test_last_coeff_is_signed_det(self):
        """c[N] = (-1)^N * det(P)."""
        for k in [3, 4, 5]:
            mat, _, _ = build_transfer_matrix(3, 1, k)
            coeffs = fredholm_coefficients(mat)
            n = mat.shape[0]
            expected = (-1) ** n * np.linalg.det(mat)
            assert_allclose(coeffs[-1], expected, atol=1e-10)

    def test_zeros_outside_unit_disk(self):
        """Conjecture 5: all zeros of det(I-zP) have |z|>1 (equiv to rho<1)."""
        for k in [3, 4, 5, 6, 7]:
            mat, _, _ = build_transfer_matrix(3, 1, k)
            coeffs = fredholm_coefficients(mat)
            zeros = np.roots(coeffs[::-1])
            # Filter out near-zero "artifact" roots from nilpotent part
            nonzero_zeros = zeros[np.abs(zeros) > 1e-6]
            if len(nonzero_zeros) > 0:
                assert min(abs(nonzero_zeros)) > 1.0


# ---------------------------------------------------------------------------
# Rational x: consistency with integer x
# ---------------------------------------------------------------------------
class TestRationalTransferMatrix:
    @pytest.mark.parametrize("k", [3, 4, 5, 6])
    def test_integer_x_matches(self, k):
        """build_transfer_matrix_rational(x, 1, y, k) == build_transfer_matrix(x, y, k)."""
        mat_int, _, _ = build_transfer_matrix(3, 1, k)
        mat_rat, _, _ = build_transfer_matrix_rational(3, 1, 1, k)
        assert_allclose(mat_rat, mat_int, atol=1e-14)

    def test_rational_one_nonzero_per_column(self):
        """Deterministic map property holds for rational x too."""
        for p, q in [(3, 1), (5, 3), (7, 5), (1, 3)]:
            mat, _, _ = build_transfer_matrix_rational(p, q, 1, 5)
            for col in range(mat.shape[1]):
                assert np.count_nonzero(mat[:, col]) == 1


# ---------------------------------------------------------------------------
# Functional graph and cycle detection
# ---------------------------------------------------------------------------
class TestFunctionalGraph:
    def test_k3_successor(self):
        """Hand-verified successors at k=3: 1->1, 3->5, 5->1, 7->3."""
        mat, odd_res, _ = build_transfer_matrix(3, 1, 3)
        successor, weight, v_val = _functional_graph(mat, odd_res)
        assert successor[1] == 1
        assert successor[3] == 5
        assert successor[5] == 1
        assert successor[7] == 3

    def test_k3_v_values(self):
        """Hand-verified v-values at k=3."""
        mat, odd_res, _ = build_transfer_matrix(3, 1, 3)
        _, _, v_val = _functional_graph(mat, odd_res)
        assert v_val[1] == 2
        assert v_val[3] == 1
        assert v_val[5] == 4
        assert v_val[7] == 1


class TestFindCycles:
    def test_k3_single_fixed_point(self):
        """At k=3, the only cycle is the fixed point {1}."""
        mat, odd_res, _ = build_transfer_matrix(3, 1, 3)
        successor, _, _ = _functional_graph(mat, odd_res)
        cycles = _find_cycles(successor, odd_res)
        assert len(cycles) == 1
        assert cycles[0] == [1]

    @pytest.mark.parametrize("k", [3, 4, 5, 6, 7, 8, 9])
    def test_non_exceptional_k_single_cycle(self, k):
        """For k not in exceptional set E, there's exactly one cycle: {1}."""
        mat, odd_res, _ = build_transfer_matrix(3, 1, k)
        successor, _, _ = _functional_graph(mat, odd_res)
        cycles = _find_cycles(successor, odd_res)
        assert len(cycles) == 1
        assert 1 in cycles[0]

    def test_exceptional_k10_multiple_cycles(self):
        """k=10 is in exceptional set E: has additional modular cycles."""
        mat, odd_res, _ = build_transfer_matrix(3, 1, 10)
        successor, _, _ = _functional_graph(mat, odd_res)
        cycles = _find_cycles(successor, odd_res)
        assert len(cycles) > 1


# ---------------------------------------------------------------------------
# v-distribution universality (Conjecture 4 / Proposition)
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
# Theorem 3: 2-adic local constancy
# ---------------------------------------------------------------------------
class TestLocalConstancy:
    """Verify that P_k(x, y) is locally constant in x (2-adic topology).

    M(k, x_0, y) = k + max{ v_2(x_0 * j + y) : j odd, 1 <= j < 2^k }.
    """

    @staticmethod
    def _compute_m(k, x0, y):
        """Compute M(k, x_0, y) = k + max v_2(x_0 * j + y) over odd j."""
        mod = 2**k
        max_v = 0
        for j in range(1, mod, 2):
            val = x0 * j + y
            v = 0
            tmp = val
            while tmp % 2 == 0:
                tmp //= 2
                v += 1
            if v > max_v:
                max_v = v
        return k + max_v

    @pytest.mark.parametrize("k", [3, 4, 5, 6])
    def test_matrix_stable_at_m(self, k):
        """P_k(x_0 + 2^M, y) == P_k(x_0, y) for M = M(k, x_0, y)."""
        x0, y = 3, 1
        big_m = self._compute_m(k, x0, y)
        mat0, _, _ = build_transfer_matrix(x0, y, k)
        x_pert = x0 + 2**big_m
        mat1, _, _ = build_transfer_matrix(x_pert, y, k)
        assert_allclose(mat1, mat0, atol=1e-15, err_msg=f"k={k}, M={big_m}")

    @pytest.mark.parametrize("k", [3, 4, 5, 6])
    def test_matrix_changes_below_m(self, k):
        """P_k(x_0 + 2^{M-1}, y) != P_k(x_0, y) — minimality of M."""
        x0, y = 3, 1
        big_m = self._compute_m(k, x0, y)
        mat0, _, _ = build_transfer_matrix(x0, y, k)
        x_pert = x0 + 2 ** (big_m - 1)
        mat1, _, _ = build_transfer_matrix(x_pert, y, k)
        assert not np.allclose(mat1, mat0, atol=1e-15), (
            f"k={k}: matrix should change at M-1={big_m - 1}"
        )

    @pytest.mark.parametrize("x0", [1, 5, 7, 9])
    def test_stability_various_x(self, x0):
        """Local constancy holds for various odd x_0, not just x_0=3."""
        k, y = 4, 1
        big_m = self._compute_m(k, x0, y)
        mat0, _, _ = build_transfer_matrix(x0, y, k)
        x_pert = x0 + 2**big_m
        mat1, _, _ = build_transfer_matrix(x_pert, y, k)
        assert_allclose(mat1, mat0, atol=1e-15, err_msg=f"x0={x0}, M={big_m}")

    def test_known_m_values(self):
        """Verify M(k, 3, 1) matches the table in the proof document."""
        expected = {3: 7, 4: 8, 5: 11, 6: 12, 7: 15, 8: 16}
        for k, m_expected in expected.items():
            m_actual = self._compute_m(k, 3, 1)
            assert m_actual == m_expected, f"k={k}: M={m_actual}, expected {m_expected}"

    def test_fredholm_coeffs_stable(self):
        """Corollary: Fredholm coefficients are locally constant in x."""
        k, x0, y = 5, 3, 1
        big_m = self._compute_m(k, x0, y)
        mat0, _, _ = build_transfer_matrix(x0, y, k)
        mat1, _, _ = build_transfer_matrix(x0 + 2**big_m, y, k)
        coeffs0 = fredholm_coefficients(mat0)
        coeffs1 = fredholm_coefficients(mat1)
        assert_allclose(coeffs1, coeffs0, atol=1e-14)


class TestVDistribution:
    @pytest.mark.parametrize("x", [1, 3, 5, 7, 9, 11])
    def test_geometric_distribution(self, x):
        """Over odd residues mod 2^k, P(v_2(xn+y) = j) = 1/2^j exactly.

        This is folklore (Tao, Matthews, Lagarias) and should be a theorem.
        """
        k = 7
        mod = 2**k
        y = 1
        v_counts = {}
        odd_residues = list(range(1, mod, 2))
        n_total = len(odd_residues)
        for n in odd_residues:
            val = x * n + y
            v = 0
            while val % 2 == 0:
                val //= 2
                v += 1
            v_counts[v] = v_counts.get(v, 0) + 1

        for j in range(1, k):
            expected_frac = 1.0 / 2**j
            actual_frac = v_counts.get(j, 0) / n_total
            assert_allclose(actual_frac, expected_frac, atol=1e-14, err_msg=f"x={x}, j={j}")
