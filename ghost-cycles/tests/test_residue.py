from collatz.residue import compress_steps, compressed_map, shrink_fraction


class TestCompressSteps:
    def test_single_even(self):
        result_0 = compress_steps(0, k=1)
        assert result_0["multiplier"] == 1
        assert result_0["offset"] == 0
        assert result_0["divisions"] == 1

    def test_single_odd(self):
        result_1 = compress_steps(1, k=1)
        assert result_1["multiplier"] == 3
        assert result_1["offset"] == 1
        assert result_1["divisions"] == 0

    def test_affine_formula_k3(self):
        """Verify affine formula matches actual Collatz for all residues mod 8."""
        k = 3
        mod = 2**k
        for r in range(mod):
            result = compress_steps(r, k)
            m, o, d = result["multiplier"], result["offset"], result["divisions"]
            for j in range(1, 10):
                n = r + mod * j
                val = n
                for _ in range(k):
                    val = val // 2 if val % 2 == 0 else 3 * val + 1
                expected = val
                computed = (m * n + o) // (2**d)
                assert computed == expected, (
                    f"r={r}, k={k}, n={n}: expected {expected}, got {computed}"
                )

    def test_affine_formula_k5(self):
        """Verify affine formula matches actual Collatz for all residues mod 32."""
        k = 5
        mod = 2**k
        for r in range(mod):
            result = compress_steps(r, k)
            m, o, d = result["multiplier"], result["offset"], result["divisions"]
            for j in range(1, 5):
                n = r + mod * j
                val = n
                for _ in range(k):
                    val = val // 2 if val % 2 == 0 else 3 * val + 1
                expected = val
                computed = (m * n + o) // (2**d)
                assert computed == expected, (
                    f"r={r}, k={k}, n={n}: expected {expected}, got {computed}"
                )


class TestCompressedMap:
    def test_k2(self):
        cmap = compressed_map(k=2)
        assert len(cmap) == 4

    def test_k8(self):
        cmap = compressed_map(k=8)
        assert len(cmap) == 256


class TestShrinkFraction:
    def test_k8_positive(self):
        frac = shrink_fraction(k=8)
        assert 0.0 < frac <= 1.0

    def test_monotone_trend(self):
        fracs = [shrink_fraction(k) for k in [4, 8, 12]]
        assert fracs[2] >= fracs[0] - 0.1
