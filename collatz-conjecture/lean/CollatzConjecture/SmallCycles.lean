/-
  Decidable enumeration of small accelerated cycles.

  The cycle equation in `CycleExclusion.lean` reduces "is there a nontrivial
  accelerated cycle of length k at n" to checking `acceleratedOddIter k n = n`
  with k > 0 and n a positive odd. For bounded ranges of (n, k) this is a
  finite, decidable computation.

  This file:
  - defines the decidable predicate `IsAcceleratedOddCycle k n`,
  - provides a bounded-enumeration statement `NoSmallCyclesUpTo N L`,
  - rules out small cycles in concrete ranges via `decide` and `native_decide`,
  - bridges to the parity-word cycle equation from `CycleExclusion.lean`.

  `decide` keeps proofs kernel-checked; `native_decide` is faster for larger
  ranges but adds `Lean.ofReduceBool` to the trusted base.

  Lean core only.
-/

import CollatzConjecture.CycleExclusion

/-! ## Decidable accelerated cycle predicate -/

/-- A nontrivial accelerated odd cycle: positive odd `n`, length `k > 0`,
and `acceleratedOddIter k n = n`. -/
def IsAcceleratedOddCycle (k n : Nat) : Prop :=
  0 < k ∧ 0 < n ∧ n % 2 = 1 ∧ acceleratedOddIter k n = n

instance (k n : Nat) : Decidable (IsAcceleratedOddCycle k n) :=
  inferInstanceAs
    (Decidable (0 < k ∧ 0 < n ∧ n % 2 = 1 ∧ acceleratedOddIter k n = n))

/-- The trivial cycle `1 → 1` (since `oddPart (3 · 1 + 1) = oddPart 4 = 1`). -/
theorem isAcceleratedOddCycle_one_one : IsAcceleratedOddCycle 1 1 := by decide

/-! ## Bounded enumeration

`NoSmallCyclesUpTo N L` says that no nontrivial accelerated cycle of length
`≤ L` starts from any `n ∈ [2, N]`. The lower bound `n ≥ 2` excludes the
trivial fixed point at `1`. -/

/-- No nontrivial accelerated cycle of length `≤ L` from any `n ∈ [2, N]`. -/
def NoSmallCyclesUpTo (N L : Nat) : Prop :=
  ∀ n, n ≤ N → 2 ≤ n → ∀ k, k ≤ L → 1 ≤ k → ¬ IsAcceleratedOddCycle k n

instance (N L : Nat) : Decidable (NoSmallCyclesUpTo N L) :=
  inferInstanceAs
    (Decidable (∀ n, n ≤ N → 2 ≤ n →
      ∀ k, k ≤ L → 1 ≤ k → ¬ IsAcceleratedOddCycle k n))

/-! ## Concrete kernel-checked ranges (`decide`) -/

/-- Sanity check: no length-1 cycle starting from `n = 3`. -/
theorem no_cycle_3_1 : ¬ IsAcceleratedOddCycle 1 3 := by decide

/-- No nontrivial accelerated cycle of length ≤ 2 from any `n ∈ [2, 10]`. -/
theorem no_small_cycles_10_2 : NoSmallCyclesUpTo 10 2 := by decide

/-! ## Wider ranges via `native_decide`

These add `Lean.ofReduceBool` to the trusted axioms but verify in seconds
rather than kernel-minutes. -/

/-- No nontrivial accelerated cycle of length ≤ 5 from any `n ∈ [2, 1000]`. -/
theorem no_small_cycles_1000_5 : NoSmallCyclesUpTo 1000 5 := by native_decide

/-- No nontrivial accelerated cycle of length ≤ 10 from any `n ∈ [2, 1000]`. -/
theorem no_small_cycles_1000_10 : NoSmallCyclesUpTo 1000 10 := by native_decide

/-- No nontrivial accelerated cycle of length ≤ 5 from any `n ∈ [2, 10000]`. -/
theorem no_small_cycles_10000_5 : NoSmallCyclesUpTo 10000 5 := by native_decide

/-! ## Bridge to the parity-word cycle equation

Each accelerated cycle of length `k` at `n` is realised by the canonical
admissible parity word `acceleratedTrace k n`, of length exactly `k`. The
cycle equation in `CycleExclusion.lean` then forces

    2 ^ totalV (acceleratedTrace k n) · n =
        3 ^ k · n + offset (acceleratedTrace k n).

Hence `NoSmallCyclesUpTo N L` rules out, in this range, the canonical
parity-word cycles arising from the accelerated dynamics. (Non-canonical
admissible words with the same closing-up property would need a separate
argument via the Diophantine equation `(2^V − 3^L) · n = offset v`.) -/

/-- An accelerated cycle satisfies the parity-word cycle equation. -/
theorem cycle_equation_of_isAcceleratedOddCycle (k n : Nat)
    (h : IsAcceleratedOddCycle k n) :
    2 ^ ParityWords.acceleratedTotalV k n * n =
      3 ^ k * n + ParityWords.offset (ParityWords.acceleratedTrace k n) :=
  ParityWords.accelerated_cycle_equation k n h.2.2.2

/-! ## Symbolic length-1 exclusion

The Diophantine cycle equation already rules out all length-1 accelerated
cycles except the trivial fixed point at `n = 1`. This is a *symbolic*
exclusion (valid for arbitrary `n`), not just a bounded-range computation. -/

/-- A length-1 accelerated odd cycle exists only at `q = 1`. -/
theorem isAcceleratedOddCycle_one_q_eq_one (q : Nat)
    (h : IsAcceleratedOddCycle 1 q) : q = 1 := by
  rcases h with ⟨_, hpos, _hodd, hCycle⟩
  have hAdm : ParityWords.Admissible (ParityWords.acceleratedTrace 1 q) q :=
    ParityWords.admissible_acceleratedTrace 1 q
  have hApp : ParityWords.applyWord (ParityWords.acceleratedTrace 1 q) q = q := by
    rw [ParityWords.applyWord_acceleratedTrace]; exact hCycle
  have hTrace :
      ParityWords.acceleratedTrace 1 q = [oddPartSteps (3 * q + 1)] := rfl
  rw [hTrace] at hAdm hApp
  exact ParityWords.cycle_singleton_n_eq_one
    (oddPartSteps (3 * q + 1)) q hpos hAdm hApp

/-- No nontrivial length-1 accelerated odd cycle exists. -/
theorem not_isAcceleratedOddCycle_one_of_gt_one (q : Nat) (hq : 1 < q) :
    ¬ IsAcceleratedOddCycle 1 q := by
  intro h
  have hq1 : q = 1 := isAcceleratedOddCycle_one_q_eq_one q h
  omega

/-! ## Symbolic length-2 exclusion

The Diophantine cycle equation at the parity word `[a, b]` admits only
`q = 1` for positive `q` (with the trivial cycle `1 → 1 → 1`). -/

/-- A length-2 accelerated odd cycle exists only at `q = 1`. -/
theorem isAcceleratedOddCycle_two_q_eq_one (q : Nat)
    (h : IsAcceleratedOddCycle 2 q) : q = 1 := by
  rcases h with ⟨_, hpos, _hodd, hCycle⟩
  have hAdm : ParityWords.Admissible (ParityWords.acceleratedTrace 2 q) q :=
    ParityWords.admissible_acceleratedTrace 2 q
  have hApp : ParityWords.applyWord (ParityWords.acceleratedTrace 2 q) q = q := by
    rw [ParityWords.applyWord_acceleratedTrace]; exact hCycle
  have hTrace :
      ParityWords.acceleratedTrace 2 q =
        [oddPartSteps (3 * q + 1),
          oddPartSteps (3 * acceleratedOddStep q + 1)] := rfl
  rw [hTrace] at hAdm hApp
  exact ParityWords.cycle_pair_n_eq_one
    (oddPartSteps (3 * q + 1))
    (oddPartSteps (3 * acceleratedOddStep q + 1))
    q hpos hAdm hApp

/-- No nontrivial length-2 accelerated odd cycle exists. -/
theorem not_isAcceleratedOddCycle_two_of_gt_one (q : Nat) (hq : 1 < q) :
    ¬ IsAcceleratedOddCycle 2 q := by
  intro h
  have hq1 : q = 1 := isAcceleratedOddCycle_two_q_eq_one q h
  omega

/-! ## Symbolic length-3 exclusion

Each canonical accelerated-trace entry is `oddPartSteps (3 m + 1)` for
`m` a positive odd, and `3 m + 1` is then even, so every such entry is
`≥ 1`. The strict-positivity-of-entries hypothesis of
`cycle_triple_n_eq_one` is therefore satisfied automatically. -/

private theorem oddPartSteps_three_succ_pos (m : Nat) (hodd : m % 2 = 1) :
    1 ≤ oddPartSteps (3 * m + 1) := by
  have hEven : (3 * m + 1) % 2 = 0 := by omega
  have hPos : 0 < 3 * m + 1 := by omega
  rw [oddPartSteps_even_succ (3 * m + 1) hPos hEven]
  omega

/-- A length-3 accelerated odd cycle exists only at `q = 1`. -/
theorem isAcceleratedOddCycle_three_q_eq_one (q : Nat)
    (h : IsAcceleratedOddCycle 3 q) : q = 1 := by
  rcases h with ⟨_, hpos, hodd, hCycle⟩
  have hAdm : ParityWords.Admissible (ParityWords.acceleratedTrace 3 q) q :=
    ParityWords.admissible_acceleratedTrace 3 q
  have hApp : ParityWords.applyWord (ParityWords.acceleratedTrace 3 q) q = q := by
    rw [ParityWords.applyWord_acceleratedTrace]; exact hCycle
  -- Each iterate of the accelerated map remains positive odd, so each
  -- canonical valuation in the trace is `≥ 1`.
  have hodd1 : (acceleratedOddStep q) % 2 = 1 := acceleratedOddStep_odd q
  have hodd2 : (acceleratedOddStep (acceleratedOddStep q)) % 2 = 1 :=
    acceleratedOddStep_odd _
  have ha : 1 ≤ oddPartSteps (3 * q + 1) :=
    oddPartSteps_three_succ_pos q hodd
  have hb : 1 ≤ oddPartSteps (3 * acceleratedOddStep q + 1) :=
    oddPartSteps_three_succ_pos (acceleratedOddStep q) hodd1
  have hc :
      1 ≤ oddPartSteps (3 * acceleratedOddStep (acceleratedOddStep q) + 1) :=
    oddPartSteps_three_succ_pos (acceleratedOddStep (acceleratedOddStep q)) hodd2
  have hTrace :
      ParityWords.acceleratedTrace 3 q =
        [oddPartSteps (3 * q + 1),
          oddPartSteps (3 * acceleratedOddStep q + 1),
          oddPartSteps (3 * acceleratedOddStep (acceleratedOddStep q) + 1)] :=
    rfl
  rw [hTrace] at hAdm hApp
  exact ParityWords.cycle_triple_n_eq_one
    (oddPartSteps (3 * q + 1))
    (oddPartSteps (3 * acceleratedOddStep q + 1))
    (oddPartSteps (3 * acceleratedOddStep (acceleratedOddStep q) + 1))
    q ha hb hc hpos hAdm hApp

/-- No nontrivial length-3 accelerated odd cycle exists. -/
theorem not_isAcceleratedOddCycle_three_of_gt_one (q : Nat) (hq : 1 < q) :
    ¬ IsAcceleratedOddCycle 3 q := by
  intro h
  have hq1 : q = 1 := isAcceleratedOddCycle_three_q_eq_one q h
  omega
