/-
  Headline cycle-branch results: ruling out classical Collatz cycle
  counterexamples of bounded accelerated period.

  Combines `CycleBridge.acceleratedCycleOfCollatzCycle_proved` with the
  symbolic length-≤3 exclusions and the bounded `NoSmallCyclesUpTo`
  ranges from `SmallCycles.lean`. The unbounded-in-`q` length-≤3
  exclusions yield an unconditional statement: no classical Collatz
  cycle counterexample has accelerated period 1, 2, or 3.

  For longer accelerated periods, only bounded-`q` enumeration is
  available (`NoSmallCyclesUpTo N L`). This file packages a conditional
  range-style theorem that lets future strengthenings of either bound
  feed straight through.

  Lean core only.
-/

import CollatzConjecture.CycleBridge
import CollatzConjecture.SmallReachability

/-! ## The bridge in `IsAcceleratedOddCycle` form

Re-export of `acceleratedCycleOfCollatzCycle_proved` packaged for direct
composition with `NoSmallCyclesUpTo`. -/

/-- Classical Collatz cycle counterexample at positive `n` produces an
accelerated odd cycle at some `q > 1`. The witness is exactly the
`(q, k)` from `acceleratedCycleOfCollatzCycle_proved`, repackaged as
`IsAcceleratedOddCycle k q`. -/
theorem isAcceleratedOddCycle_of_collatz_cycle_counterexample
    (n : Nat) (hPosN : 0 < n) (hCE : CollatzEventualCycleCounterexample n) :
    ∃ q k : Nat, 1 < q ∧ IsAcceleratedOddCycle k q := by
  rcases acceleratedCycleOfCollatzCycle_proved n hPosN hCE
    with ⟨q, k, hPosQ, hOddQ, hQgt1, hkPos, hkCycle⟩
  exact ⟨q, k, hQgt1, hkPos, hPosQ, hOddQ, hkCycle⟩

/-! ## Conditional range exclusion via `NoSmallCyclesUpTo`

`NoSmallCyclesUpTo N L` rules out accelerated cycles in the rectangle
`[2, N] × [1, L]`. Composed with the bridge, any classical cycle
counterexample's extracted `(q, k)` therefore escapes that rectangle. -/

/-- If `NoSmallCyclesUpTo N L` and a classical Collatz cycle counterexample
exists at positive `n`, then the extracted `(q, k)` satisfies either
`q > N` or `k > L`. -/
theorem extracted_cycle_escapes_range
    (N L n : Nat)
    (hSmall : NoSmallCyclesUpTo N L)
    (hPosN : 0 < n) (hCE : CollatzEventualCycleCounterexample n) :
    ∃ q k : Nat, IsAcceleratedOddCycle k q ∧ (N < q ∨ L < k) := by
  rcases isAcceleratedOddCycle_of_collatz_cycle_counterexample n hPosN hCE
    with ⟨q, k, hQgt1, hCycle⟩
  refine ⟨q, k, hCycle, ?_⟩
  rcases Nat.lt_or_ge N q with hNq | hNq
  · exact Or.inl hNq
  · rcases Nat.lt_or_ge L k with hLk | hLk
    · exact Or.inr hLk
    · have hq2 : 2 ≤ q := hQgt1
      exact False.elim (hSmall q hNq hq2 k hLk hCycle.1 hCycle)

/-! ## Unconditional: classical cycle counterexamples have accelerated
period ≥ 4

The symbolic length-≤3 exclusions in `SmallCycles.lean` are unbounded in
`q`, so they survive the bridge: there is no classical Collatz cycle
counterexample whose extracted accelerated period is `1`, `2`, or `3`.

Equivalently, every classical cycle counterexample's extracted `q` lives
on an accelerated cycle of length at least `4`. -/

/-- A `(q, k)` accelerated cycle with `q > 1` and `k ∈ {1, 2, 3}` does
not exist. Combines the three symbolic exclusions. -/
private theorem not_isAcceleratedOddCycle_le_three_of_gt_one
    (q k : Nat) (hq : 1 < q) (hk : 1 ≤ k) (hkle : k ≤ 3) :
    ¬ IsAcceleratedOddCycle k q := by
  match k, hk, hkle with
  | 1, _, _ => exact not_isAcceleratedOddCycle_one_of_gt_one q hq
  | 2, _, _ => exact not_isAcceleratedOddCycle_two_of_gt_one q hq
  | 3, _, _ => exact not_isAcceleratedOddCycle_three_of_gt_one q hq

/-- **Headline cycle result**: no classical Collatz cycle counterexample
has accelerated period `≤ 3`. Equivalently, the bridge from any cycle
counterexample produces a `(q, k)` with `k ≥ 4`. -/
theorem extracted_accelerated_period_ge_four
    (n : Nat) (hPosN : 0 < n) (hCE : CollatzEventualCycleCounterexample n) :
    ∃ q k : Nat, IsAcceleratedOddCycle k q ∧ 4 ≤ k := by
  rcases isAcceleratedOddCycle_of_collatz_cycle_counterexample n hPosN hCE
    with ⟨q, k, hQgt1, hCycle⟩
  refine ⟨q, k, hCycle, ?_⟩
  rcases Nat.lt_or_ge 3 k with h | h
  · omega
  · exact False.elim
      (not_isAcceleratedOddCycle_le_three_of_gt_one q k hQgt1 hCycle.1 h hCycle)

/-! ## Concrete instances using kernel-checked / native-decided ranges -/

/-- Concrete instance: combining `no_small_cycles_10000_5` with the bridge,
any classical Collatz cycle counterexample's extracted `(q, k)` has
either `q > 10000` or `k > 5`. -/
theorem extracted_cycle_escapes_10000_5
    (n : Nat) (hPosN : 0 < n) (hCE : CollatzEventualCycleCounterexample n) :
    ∃ q k : Nat, IsAcceleratedOddCycle k q ∧ (10000 < q ∨ 5 < k) :=
  extracted_cycle_escapes_range 10000 5 n no_small_cycles_10000_5 hPosN hCE
