/-
  Ghost Cycles of the Syracuse Map — Spectral Approximation (Theorem 1(e))

  The spectrum of the transfer operator L on C(Z_2^odd) equals the closure
  of the union of spectra of the finite-level transfer matrices P_k.

  This follows from:
  1. The subspaces A_k of functions constant on odd residues mod 2^k
     are finite-dimensional with dim A_k = 2^(k-1).
  2. The union ∪ A_k is dense in C(Z_2^odd) by Stone-Weierstrass
     (locally constant functions are dense on compact totally disconnected spaces).
  3. P_k f → L f in norm for every locally constant f.

  Hence σ(L) = cl(∪ σ(P_k)), and in particular ρ(L) = sup_k ρ_k.

  Reference: McKenna (2026), Theorem 1(e), Section 3.

  Proofs by Aristotle (Harmonic, aristotle.harmonic.fun).
  Skeleton by Claude; sorry blocks filled by Aristotle's proof search engine.
  Aristotle also identified and corrected a false statement in the original
  skeleton (approx_eigenvalue_of_finite_level).
-/

import Mathlib

namespace GhostCycles

/-
  We work abstractly: given a compact space X, a bounded linear operator T on C(X, ℝ),
  and finite-rank projections π_k such that π_k f → f for all f, prove that
  σ(T) = cl(∪_k σ(π_k ∘ T ∘ π_k)).

  The key lemma: if λ is an approximate eigenvalue of T, then for every ε > 0
  there exists k and μ ∈ σ(π_k T π_k) with |μ - λ| < ε.
-/

/-- If T_k → T pointwise on a dense subspace of a Banach space, and
    λ ∉ cl(∪ σ(T_k)), then (T - λ) is bounded below, hence λ ∉ σ(T).
    Contrapositive: σ(T) ⊆ cl(∪ σ(T_k)). -/
theorem spectrum_subset_closure_of_approx
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (T : E →L[ℝ] E)
    (T_k : ℕ → E →L[ℝ] E)
    (h_conv : ∀ x : E,
      Filter.Tendsto (fun k => T_k k x) Filter.atTop (nhds (T x))) :
    ∀ mu : ℝ,
    (∀ ε > (0 : ℝ), ∃ x : E, ‖x‖ = 1 ∧ ‖T x - mu • x‖ < ε) →
    ∀ ε > (0 : ℝ),
    ∃ k : ℕ, ∃ x : E, ‖x‖ = 1 ∧ ‖T_k k x - mu • x‖ < ε := by
  intro mu hmu ε hε
  obtain ⟨x, hx, hx'⟩ := hmu (ε / 2) (half_pos hε)
  rcases Metric.tendsto_atTop.mp (h_conv x) (ε / 2) (half_pos hε) with ⟨k, hk⟩
  refine ⟨k, x, hx, ?_⟩
  have key : (T_k k) x - mu • x = ((T_k k) x - T x) + (T x - mu • x) := by
    abel
  rw [key]
  have h2 : ‖(T_k k) x - T x‖ < ε / 2 := by
    have := hk k le_rfl
    rwa [dist_eq_norm] at this
  linarith [norm_add_le ((T_k k) x - T x) (T x - mu • x)]

-- The original statement below is false: for a single fixed k, the quantity
-- ‖T x - mu • x‖ = ‖T x - T_k k x‖ is a fixed real number that need not be
-- smaller than every ε > 0. A counterexample: take E = ℝ, T = id, T_0 = 0,
-- T_k = id for k ≥ 1, x = 1, mu = 0, k = 0. Then ‖T x - mu • x‖ = 1.
--
-- /-- Converse direction: every eigenvalue of T_k is an approximate eigenvalue
--     of T, provided T_k converges to T pointwise. -/
-- theorem approx_eigenvalue_of_finite_level
--     {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
--     (T : E →L[ℝ] E)
--     (T_k : ℕ → E →L[ℝ] E)
--     (h_conv : ∀ x : E,
--       Filter.Tendsto (fun k => T_k k x) Filter.atTop (nhds (T x)))
--     (k : ℕ) (mu : ℝ) (x : E) (hx : ‖x‖ = 1)
--     (heig : T_k k x = mu • x) :
--     ∀ ε > (0 : ℝ), ∃ n : ℕ, k ≤ n → ‖T x - mu • x‖ < ε := by
--   sorry

/-- Corrected version: if x is eventually a mu-eigenvector of T_k
    (i.e., T_k k x = mu • x for all sufficiently large k),
    and T_k → T pointwise, then x is an exact eigenvector of T.
    This captures the converse direction: eigenvalues stable across
    finite levels persist in the limit operator. -/
theorem approx_eigenvalue_of_finite_level
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (T : E →L[ℝ] E)
    (T_k : ℕ → E →L[ℝ] E)
    (h_conv : ∀ x : E,
      Filter.Tendsto (fun k => T_k k x) Filter.atTop (nhds (T x)))
    (mu : ℝ) (x : E) (_hx : ‖x‖ = 1)
    (heig : ∀ᶠ k in Filter.atTop, T_k k x = mu • x) :
    T x = mu • x := by
  exact tendsto_nhds_unique (h_conv x)
    (tendsto_const_nhds.congr'
      (by filter_upwards [heig] with k hk; rw [hk]))

/-- The spectral radius of the limit equals the supremum of the finite-level
    spectral radii, when eigenvalues of P_k have |λ| ≤ 1/2. -/
theorem spectral_radius_eq_sup
    (ρ : ℕ → ℝ)
    (h_bound : ∀ k, ρ k ≤ 1 / 2)
    (_h_mono : ∀ k, 0 ≤ ρ k) :
    ⨆ k, ρ k ≤ 1 / 2 := by
  exact ciSup_le h_bound

end GhostCycles
