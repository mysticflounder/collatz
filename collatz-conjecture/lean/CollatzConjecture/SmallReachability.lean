/-
  Bounded-stopping-time reachability for small `n`.

  `CollatzReachesOne` is `∃ k, collatzIter k n = 1`, an existential over ℕ
  and therefore not directly decidable. This file:

  - defines a decidable `Bool`-valued bounded check `reachesOneWithin`,
  - proves the soundness implication
        `reachesOneWithin b n = true → CollatzReachesOne n`,
  - uses `native_decide` to verify `reachesOneWithin 200 n = true` for all
    `n ∈ [1, 100]`, yielding `CollatzReachesOne` for those `n`.

  Companion to `SmallCycles.lean`: that file rules out short cycles by
  computation; this file confirms reachability of `1` for small starting
  values by computation. Together they cover the bottom of both branches
  of the cycle/divergence dichotomy.

  Lean core only.
-/

import CollatzConjecture.Descent

/-! ## Bounded reachability check -/

/-- `reachesOneWithin b n = true` iff some `k ≤ b` has `collatzIter k n = 1`.

This is a `Bool` (not a `Prop`), so it is automatically decidable. The
recursion peels off one Collatz step per fuel unit. -/
def reachesOneWithin : Nat → Nat → Bool
  | 0,     n => n == 1
  | b + 1, n => n == 1 || reachesOneWithin b (collatzStep n)

@[simp] theorem reachesOneWithin_zero (n : Nat) :
    reachesOneWithin 0 n = (n == 1) := rfl

@[simp] theorem reachesOneWithin_succ (b n : Nat) :
    reachesOneWithin (b + 1) n =
      (n == 1 || reachesOneWithin b (collatzStep n)) := rfl

/-! ## Soundness: bounded check implies reachability -/

/-- One step from the front of an iteration. -/
private theorem collatzIter_succ_left (k n : Nat) :
    collatzIter (k + 1) n = collatzIter k (collatzStep n) := by
  have hcomm : (k + 1 : Nat) = 1 + k := by omega
  calc collatzIter (k + 1) n
      = collatzIter (1 + k) n := by rw [hcomm]
    _ = collatzIter k (collatzIter 1 n) := collatzIter_add 1 k n
    _ = collatzIter k (collatzStep n) := by simp [collatzIter]

/-- If the bounded check succeeds, the classical Collatz orbit really does
reach `1`. The proof exhibits an explicit witness extracted from the
recursion. -/
theorem collatzReachesOne_of_reachesOneWithin :
    ∀ (b n : Nat), reachesOneWithin b n = true → CollatzReachesOne n
  | 0, n => by
      intro h
      simp [reachesOneWithin] at h
      exact ⟨0, by simp [collatzIter, h]⟩
  | b + 1, n => by
      intro h
      simp [reachesOneWithin] at h
      rcases h with h1 | hRec
      · exact ⟨0, by simp [collatzIter, h1]⟩
      · rcases collatzReachesOne_of_reachesOneWithin b (collatzStep n) hRec with ⟨k, hk⟩
        refine ⟨k + 1, ?_⟩
        rw [collatzIter_succ_left]
        exact hk

/-! ## Concrete reachability up to 100

Bound 200 is comfortably above the maximum total stopping time below 100
(which is 118, attained at `n = 27`). `native_decide` checks all 100 cases
in milliseconds. -/

/-- Every positive `n ≤ 100` reaches `1` under the classical Collatz map,
proved by direct bounded simulation up to fuel 200. Adds
`Lean.ofReduceBool` to the trusted base via `native_decide`.

The `n + 1` shift in the bounded check avoids the degenerate case `n = 0`
(where `collatzStep` is the identity), so the universal statement is over
all positive `n ≤ 100`. -/
theorem collatzReachesOne_below_100 :
    ∀ n, 0 < n → n ≤ 100 → CollatzReachesOne n := by
  intro n hpos hLe
  have hCheck : ∀ m, m < 100 → reachesOneWithin 200 (m + 1) = true := by
    native_decide
  have hShift : reachesOneWithin 200 n = true := by
    have hm : n - 1 < 100 := by omega
    have heq : (n - 1) + 1 = n := by omega
    have := hCheck (n - 1) hm
    rwa [heq] at this
  exact collatzReachesOne_of_reachesOneWithin 200 n hShift

/-- Every positive `n ≤ 100` is *not* a Collatz counterexample: any
counterexample lives strictly above 100. -/
theorem not_counterexample_below_100 (n : Nat) (hpos : 0 < n) (hLe : n ≤ 100) :
    ¬ CollatzCounterexample n := by
  intro hCE
  have hReach : CollatzReachesOne n := collatzReachesOne_below_100 n hpos hLe
  exact (reaches_one_iff_not_avoids_one n).mp hReach hCE.right

/-! ## Wider range: `n ≤ 1000` -/

/-- Every positive `n ≤ 1000` reaches `1`. Same proof shape as
`collatzReachesOne_below_100`, with fuel 500 covering the maximum total
stopping time for `n ≤ 1000` (which is 178, attained at `n = 871`). -/
theorem collatzReachesOne_below_1000 :
    ∀ n, 0 < n → n ≤ 1000 → CollatzReachesOne n := by
  intro n hpos hLe
  have hCheck : ∀ m, m < 1000 → reachesOneWithin 500 (m + 1) = true := by
    native_decide
  have hShift : reachesOneWithin 500 n = true := by
    have hm : n - 1 < 1000 := by omega
    have heq : (n - 1) + 1 = n := by omega
    have := hCheck (n - 1) hm
    rwa [heq] at this
  exact collatzReachesOne_of_reachesOneWithin 500 n hShift

theorem not_counterexample_below_1000 (n : Nat)
    (hpos : 0 < n) (hLe : n ≤ 1000) : ¬ CollatzCounterexample n := by
  intro hCE
  exact (reaches_one_iff_not_avoids_one n).mp
    (collatzReachesOne_below_1000 n hpos hLe) hCE.right

/-! ## Bound on a minimal counterexample

If a Collatz counterexample exists, the minimal one has value > 1000. This
combines `not_counterexample_below_1000` with the minimality machinery from
`Descent.lean`. -/

/-- Any minimal Collatz counterexample exceeds `1000`. -/
theorem minimal_counterexample_gt_1000 (n : Nat)
    (hMin : MinimalCollatzCounterexample n) : 1000 < n := by
  by_cases hLe : n ≤ 1000
  · exact absurd hMin.1 (not_counterexample_below_1000 n hMin.1.1 hLe)
  · exact Nat.lt_of_not_ge hLe

/-- Any minimal counterexample's orbit stays strictly above `1000`. Combines
the orbit lower bound of a minimal counterexample with the small-`n`
reachability check. -/
theorem minimal_counterexample_orbit_gt_1000 (n : Nat)
    (hMin : MinimalCollatzCounterexample n) :
    ∀ k, 1000 < collatzIter k n := by
  intro k
  have h1 := minimal_counterexample_gt_1000 n hMin
  have h2 := minimal_counterexample_orbit_lower_bound n hMin k
  exact Nat.lt_of_lt_of_le h1 h2

/-! ## Wider range: `n ≤ 10000`

Fuel `1000` comfortably covers the maximum total stopping time below
10000 (which is 261, attained at `n = 6171`). -/

/-- Every positive `n ≤ 10000` reaches `1`. -/
theorem collatzReachesOne_below_10000 :
    ∀ n, 0 < n → n ≤ 10000 → CollatzReachesOne n := by
  intro n hpos hLe
  have hCheck : ∀ m, m < 10000 → reachesOneWithin 1000 (m + 1) = true := by
    native_decide
  have hShift : reachesOneWithin 1000 n = true := by
    have hm : n - 1 < 10000 := by omega
    have heq : (n - 1) + 1 = n := by omega
    have := hCheck (n - 1) hm
    rwa [heq] at this
  exact collatzReachesOne_of_reachesOneWithin 1000 n hShift

theorem not_counterexample_below_10000 (n : Nat)
    (hpos : 0 < n) (hLe : n ≤ 10000) : ¬ CollatzCounterexample n := by
  intro hCE
  exact (reaches_one_iff_not_avoids_one n).mp
    (collatzReachesOne_below_10000 n hpos hLe) hCE.right

/-- Any minimal Collatz counterexample exceeds `10000`. -/
theorem minimal_counterexample_gt_10000 (n : Nat)
    (hMin : MinimalCollatzCounterexample n) : 10000 < n := by
  by_cases hLe : n ≤ 10000
  · exact absurd hMin.1 (not_counterexample_below_10000 n hMin.1.1 hLe)
  · exact Nat.lt_of_not_ge hLe

/-- Any minimal counterexample's orbit stays strictly above `10000`. -/
theorem minimal_counterexample_orbit_gt_10000 (n : Nat)
    (hMin : MinimalCollatzCounterexample n) :
    ∀ k, 10000 < collatzIter k n := by
  intro k
  have h1 := minimal_counterexample_gt_10000 n hMin
  have h2 := minimal_counterexample_orbit_lower_bound n hMin k
  exact Nat.lt_of_lt_of_le h1 h2
