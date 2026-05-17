/-
  Finite computational certificates.

  This file keeps small finite Collatz certificates inside Lean. For finite
  intervals, a bounded native computation is much smaller than carrying a SAT
  LRAT certificate into Lean.
-/

import CollatzConjecture.Descent

namespace ParityWords

/-- Every odd `n ∈ [lo, hi]` has an accelerated affine descent by step `K`. -/
def FiniteOddRangeAcceleratedAffineDescent (lo hi K : Nat) : Prop :=
  ∀ n : Nat, n % 2 = 1 → lo ≤ n → n ≤ hi →
    ∃ k : Nat, k ≤ K ∧ AcceleratedAffineDescent k n

/-- Boolean form of the accelerated affine descent inequality. -/
def acceleratedAffineDescentBool (k n : Nat) : Bool :=
  decide (acceleratedNumerator k n < acceleratedDenominator k n * n)

/-- Soundness of the Boolean affine descent check. -/
theorem acceleratedAffineDescent_of_bool {k n : Nat}
    (h : acceleratedAffineDescentBool k n = true) :
    AcceleratedAffineDescent k n := by
  simpa [acceleratedAffineDescentBool, AcceleratedAffineDescent] using h

/--
`acceleratedAffineDescentWithin K n = true` means some `k ≤ K` satisfies the
canonical affine descent inequality at `n`.
-/
def acceleratedAffineDescentWithin : Nat → Nat → Bool
  | 0, n => acceleratedAffineDescentBool 0 n
  | K + 1, n =>
      acceleratedAffineDescentBool (K + 1) n ||
        acceleratedAffineDescentWithin K n

/-- Soundness of the bounded Boolean descent search. -/
theorem acceleratedAffineDescent_of_within :
    ∀ (K n : Nat), acceleratedAffineDescentWithin K n = true →
      ∃ k : Nat, k ≤ K ∧ AcceleratedAffineDescent k n
  | 0, n => by
      intro h
      refine ⟨0, Nat.le_refl 0, ?_⟩
      exact acceleratedAffineDescent_of_bool h
  | K + 1, n => by
      intro h
      simp [acceleratedAffineDescentWithin] at h
      rcases h with hTop | hRec
      · exact ⟨K + 1, Nat.le_refl (K + 1), acceleratedAffineDescent_of_bool hTop⟩
      · rcases acceleratedAffineDescent_of_within K n hRec with ⟨k, hkLe, hkDesc⟩
        exact ⟨k, Nat.le_trans hkLe (Nat.le_succ K), hkDesc⟩

/--
First finite theorem candidate produced by the `piqd` sweep, but proved here
by direct bounded computation.

Source artifact:
`analysis/data/collatz-affine-sweep-n3-4095-k50-51.json`

SAT meaning:
`CollatzAffine FindBadStart`, `n_domain = [3,4095]`, `prefixes = [1,51]`,
`criterion = AffineNonDescent` returned `UNSAT`, so there is no odd start in
the finite domain whose canonical accelerated prefixes all fail affine descent.

Lean proof method:
`native_decide` checks every odd `n ∈ [3,4095]` and the soundness lemma above
turns the Boolean result into the existential descent witness.
-/
theorem finite_descent_odd_3_to_4095_by_k51 :
    FiniteOddRangeAcceleratedAffineDescent 3 4095 51 := by
  intro n hOdd hLo hHi
  have hCheck :
      ∀ m : Nat, m < 4096 → m % 2 = 1 → 3 ≤ m →
        acceleratedAffineDescentWithin 51 m = true := by
    native_decide
  have hLt : n < 4096 := by omega
  exact acceleratedAffineDescent_of_within 51 n (hCheck n hLt hOdd hLo)

/-- Expanded form of `finite_descent_odd_3_to_4095_by_k51`. -/
theorem finite_descent_odd_le_4095_by_k51
    (n : Nat) (hOdd : n % 2 = 1) (hLo : 3 ≤ n) (hHi : n ≤ 4095) :
    ∃ k : Nat, k ≤ 51 ∧ AcceleratedAffineDescent k n :=
  finite_descent_odd_3_to_4095_by_k51 n hOdd hLo hHi

/--
A finite accelerated-affine descent certificate rules out minimal Collatz
counterexamples in its interval.
-/
theorem not_minimalCounterexample_in_finiteOddRange
    {lo hi K : Nat}
    (hCert : FiniteOddRangeAcceleratedAffineDescent lo hi K)
    (n : Nat) (hLo : lo ≤ n) (hHi : n ≤ hi) :
    ¬ MinimalCollatzCounterexample n := by
  intro hMin
  have hOdd : n % 2 = 1 := minimal_counterexample_odd n hMin
  rcases hCert n hOdd hLo hHi with ⟨k, _hkLe, hkDesc⟩
  exact no_acceleratedAffine_descent_of_minimal_counterexample n k hMin hkDesc

/-- No minimal Collatz counterexample lies in `[3,4095]`, by the K=51 certificate. -/
theorem no_minimalCounterexample_3_to_4095_by_k51
    (n : Nat) (hLo : 3 ≤ n) (hHi : n ≤ 4095) :
    ¬ MinimalCollatzCounterexample n :=
  not_minimalCounterexample_in_finiteOddRange
    finite_descent_odd_3_to_4095_by_k51 n hLo hHi

/--
Version with the oddness hypothesis exposed for callers that are already
working in odd-normalized form. The hypothesis is redundant for minimal
counterexamples, but useful as an API reminder of what the finite certificate
checked.
-/
theorem no_minimalCounterexample_odd_3_to_4095_by_k51
    (n : Nat) (_hOdd : n % 2 = 1) (hLo : 3 ≤ n) (hHi : n ≤ 4095) :
    ¬ MinimalCollatzCounterexample n :=
  no_minimalCounterexample_3_to_4095_by_k51 n hLo hHi

/-- Any minimal Collatz counterexample exceeds `4095`, using the K=51 certificate. -/
theorem minimalCounterexample_gt_4095_from_k51
    (n : Nat) (hMin : MinimalCollatzCounterexample n) : 4095 < n := by
  by_cases hHi : n ≤ 4095
  · have hOdd : n % 2 = 1 := minimal_counterexample_odd n hMin
    have hNeOne : n ≠ 1 := by
      intro hOne
      exact hMin.1.2 0 (by simp [collatzIter, hOne])
    have hNeTwo : n ≠ 2 := by
      intro hTwo
      simp [hTwo] at hOdd
    have hLo : 3 ≤ n := by
      have hPos : 0 < n := hMin.1.1
      omega
    exact absurd hMin (no_minimalCounterexample_3_to_4095_by_k51 n hLo hHi)
  · exact Nat.lt_of_not_ge hHi

end ParityWords
