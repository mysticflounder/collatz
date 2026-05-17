/-
  Cycle exclusion at L ≥ 7, D < 0 (2^V < 3^L) regime.

  This regime is vacuous over ℕ: the cycle equation and positivity of
  the offset (`pow_three_lt_pow_two_of_cycle` in
  `CycleExclusion.lean`) force 3^L < 2^V for any non-empty admissible
  cycle of natural numbers. So no cycle can satisfy 2^V < 3^L, and the
  q = 1 conclusion follows by exfalso.

  Generated from data/blueprint.db.
-/

import CollatzConjecture.SmallCycles

/-- Length-(k ≥ 7) D-negative regime: any accelerated odd cycle in this regime has q = 1, vacuously. The hypothesis `2^V < 3^k` (Dneg) is contradicted by `ParityWords.pow_three_lt_pow_two_of_cycle` applied to the cycle's natural admissible parity-word trace, which forces `3^k < 2^V` from positivity of `offset` plus the cycle equation. So Dneg cycles on ℕ do not exist, and the conclusion follows by exfalso. Closes obligation cycle.L7_plus.Dneg. -/
theorem isAcceleratedOddCycle_Dneg_q_eq_one (k q : Nat) (hk : 7 ≤ k) (h : IsAcceleratedOddCycle k q) (hDneg : 2 ^ ParityWords.acceleratedTotalV k q < 3 ^ k) : q = 1 := by
  exfalso
  rcases h with ⟨_, _hpos, _hodd, hCycle⟩
  have hAdm : ParityWords.Admissible (ParityWords.acceleratedTrace k q) q :=
    ParityWords.admissible_acceleratedTrace k q
  have hApp : ParityWords.applyWord (ParityWords.acceleratedTrace k q) q = q := by
    rw [ParityWords.applyWord_acceleratedTrace]; exact hCycle
  have hLen : (ParityWords.acceleratedTrace k q).length = k :=
    ParityWords.length_acceleratedTrace k q
  have hNonempty : ParityWords.acceleratedTrace k q ≠ [] := by
    intro he
    rw [he] at hLen
    simp at hLen
    omega
  have hpw := ParityWords.pow_three_lt_pow_two_of_cycle
    (ParityWords.acceleratedTrace k q) q hNonempty hAdm hApp
  rw [hLen] at hpw
  change 2 ^ ParityWords.totalV (ParityWords.acceleratedTrace k q) < 3 ^ k at hDneg
  omega

