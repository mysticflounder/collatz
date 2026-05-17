/-
  Prefix-barrier inequality for accelerated-cycle minima (Method 1).

  For any `n` bounded above by its accelerated iterate `acceleratedOddIter j n` (e.g. a cycle minimum at `j ≤ k`), the affine identity
  `acceleratedDenominator j n · acceleratedOddIter j n = 3^j · n + offset (acceleratedTrace j n)`
  yields the prefix-barrier inequality
  `(acceleratedDenominator j n − 3^j) · n ≤ offset (acceleratedTrace j n)`.

  Load-bearing lemma for the lead `cycle.minimum-rotation-prefix-barrier`. Pure Nat arithmetic — no Baker, no transcendence theory. See `docs/plans/2026-05-14-cycle-analytical-methods-brainstorm.md` for the broader Method 1 strategy.

  Generated from data/blueprint.db.
-/

import Mathlib
import CollatzConjecture.AffineOrbits

open ParityWords

/--
**Prefix-barrier inequality (Method 1).**

If `n` is bounded above by the accelerated iterate `acceleratedOddIter j n` — in particular, when `n` is a cycle minimum and `j ≤ k` — then for every prefix length `j`,
`(acceleratedDenominator j n - 3 ^ j) * n ≤ offset (acceleratedTrace j n)`.

Equivalently, writing `S_j = totalV (acceleratedTrace j n)` and `B_j = offset (acceleratedTrace j n)`, this is `(2 ^ S_j - 3 ^ j) * n ≤ B_j`.

Load-bearing lemma for the lead `cycle.minimum-rotation-prefix-barrier` (see `docs/plans/2026-05-14-cycle-analytical-methods-brainstorm.md`).
-/
theorem cycle_minimum_prefix_barrier (n j : Nat) (hMin : n ≤ acceleratedOddIter j n) : (acceleratedDenominator j n - 3 ^ j) * n ≤ offset (acceleratedTrace j n) := by
  have hAffine :
      acceleratedDenominator j n * acceleratedOddIter j n
        = acceleratedNumerator j n :=
    acceleratedOddIter_affine_formula j n
  have hLen : (acceleratedTrace j n).length = j := length_acceleratedTrace j n
  have hNum :
      acceleratedNumerator j n
        = 3 ^ j * n + offset (acceleratedTrace j n) := by
    unfold acceleratedNumerator affineNumerator
    rw [hLen]
  have hMul :
      acceleratedDenominator j n * n
        ≤ acceleratedDenominator j n * acceleratedOddIter j n :=
    Nat.mul_le_mul_left _ hMin
  rw [hAffine, hNum] at hMul
  rw [Nat.sub_mul]
  omega


/--
**Generalized slow-growth offset bound.**

If `M * 2^{S_k(w)} ≤ 3^{b+k}` for every prefix length `k ≤ w.length` (where `S_k(w) = totalV (w.take k)`), then `M * offset w ≤ w.length * 3^{b + w.length - 1}`.

Specialised at `M = 1, b = 0` this is `offset w ≤ L · 3^{L-1}` under the slow-growth condition `2^{S_k} ≤ 3^k`. Used in the formalization path for `cycle.L7_plus.Dpos_large_k` (Method 1 + Eliahou closure); see `docs/reports/2026-05-14-method1-survivor-bound.md`.
-/
theorem offset_le_slow_growth_general : ∀ (w : ParityWord) (M b : Nat), (∀ k, k ≤ w.length → M * 2 ^ totalV (w.take k) ≤ 3 ^ (b + k)) → M * offset w ≤ w.length * 3 ^ (b + w.length - 1) := by
  intro w
  induction w with
  | nil =>
    intro M b _
    simp [offset]
  | cons v rest ih =>
    intro M b hSlow
    -- Step 1: M ≤ 3^b from the k=0 instance.
    have hM : M ≤ 3 ^ b := by
      have h0 := hSlow 0 (Nat.zero_le _)
      simpa using h0
    -- Step 2: derive the slow-growth hypothesis for `rest` with shifted parameters.
    have hSlowRest : ∀ l, l ≤ rest.length →
        (M * 2 ^ v) * 2 ^ totalV (rest.take l) ≤ 3 ^ ((b + 1) + l) := by
      intro l hl
      have hk := hSlow (l + 1) (Nat.succ_le_succ hl)
      have htake : (v :: rest).take (l + 1) = v :: rest.take l := rfl
      have htotal : totalV (v :: rest.take l) = v + totalV (rest.take l) := rfl
      rw [htake, htotal, pow_add, ← mul_assoc] at hk
      have hidx : b + (l + 1) = (b + 1) + l := by ring
      rw [hidx] at hk
      exact hk
    -- Step 3: apply IH to rest.
    have hIH := ih (M * 2 ^ v) (b + 1) hSlowRest
    have hShift : (b + 1) + rest.length - 1 = b + rest.length := by omega
    rw [hShift] at hIH
    -- Compute the goal.
    have hLen : (v :: rest).length = rest.length + 1 := rfl
    rw [hLen]
    have hRhsExp : b + (rest.length + 1) - 1 = b + rest.length := by omega
    rw [hRhsExp]
    rw [offset_cons, mul_add]
    -- Bound first summand using hM.
    have h1 : M * 3 ^ rest.length ≤ 3 ^ (b + rest.length) := by
      rw [pow_add]
      exact Nat.mul_le_mul_right _ hM
    -- Combine.
    calc M * 3 ^ rest.length + M * (2 ^ v * offset rest)
        = M * 3 ^ rest.length + (M * 2 ^ v) * offset rest := by ring
      _ ≤ 3 ^ (b + rest.length) + rest.length * 3 ^ (b + rest.length) :=
          Nat.add_le_add h1 hIH
      _ = (rest.length + 1) * 3 ^ (b + rest.length) := by ring


/--
**Slow-growth offset bound.** If `2^{S_k(w)} ≤ 3^k` for all prefix lengths `k ≤ w.length`, then `offset w ≤ w.length * 3^(w.length - 1)`.

This is the analytical bound on the cycle-minimum offset for slow-growth survivor words (those whose prefix sums satisfy `S_k ≤ k · log₂ 3`). It is Step 1 of the formalization path for closing `cycle.L7_plus.Dpos_large_k` via Method 1 + Eliahou; see `docs/reports/2026-05-14-method1-survivor-bound.md`.
-/
theorem offset_le_slow_growth (w : ParityWord) (hSlow : ∀ k, k ≤ w.length → 2 ^ totalV (w.take k) ≤ 3 ^ k) : offset w ≤ w.length * 3 ^ (w.length - 1) := by
  have h := offset_le_slow_growth_general w 1 0 (by
    intro k hk
    simpa using hSlow k hk)
  simpa using h


/--
**Slow-growth offset is dominated by the gap (conditional cycle minimum bound).**

Pure Nat arithmetic chain: assume `w` is slow-growth (`2^{S_k} ≤ 3^k` for every prefix), the gap-strength inequality `w.length · 3^{w.length-1} < B · (2^V − 3^{w.length})` holds, and `n · gap ≤ offset w` (e.g. from the cycle equation). Then `n < B`.

Combined with `B = 17,087,915` (Eliahou) and `V = ⌈L · log₂ 3⌉`, this is the slow-growth-survivor branch of the Method 1 + Eliahou closure of `cycle.L7_plus.Dpos_large_k`. The gap-strength input itself is the load-bearing analytical hypothesis (see `GapStrengthHypothesis`).
-/
theorem nat_lt_of_slow_growth_gap_strong (w : ParityWord) (V B : Nat) (hSlow : ∀ k, k ≤ w.length → 2 ^ totalV (w.take k) ≤ 3 ^ k) (hGap : w.length * 3 ^ (w.length - 1) < B * (2 ^ V - 3 ^ w.length)) (n : Nat) (hCycle : n * (2 ^ V - 3 ^ w.length) ≤ offset w) : n < B := by
  have hOffsetBd : offset w ≤ w.length * 3 ^ (w.length - 1) :=
    offset_le_slow_growth w hSlow
  have hChain : n * (2 ^ V - 3 ^ w.length) ≤ w.length * 3 ^ (w.length - 1) :=
    le_trans hCycle hOffsetBd
  have hn_g_lt : n * (2 ^ V - 3 ^ w.length) < B * (2 ^ V - 3 ^ w.length) :=
    lt_of_le_of_lt hChain hGap
  have hg_pos : 0 < 2 ^ V - 3 ^ w.length := by
    by_contra h
    push_neg at h
    have hg0 : 2 ^ V - 3 ^ w.length = 0 := Nat.le_zero.mp h
    rw [hg0, Nat.mul_zero] at hGap
    omega
  exact Nat.lt_of_mul_lt_mul_right hn_g_lt


/--
**Gap strength hypothesis (literature import; conditional on Rhin–Viola).**

For every cycle length `L ≥ 1` and every `V` with `2^V > 3^L`, the gap `2^V − 3^L` is large enough that the slow-growth offset bound `L · 3^{L-1}` is dominated: `L · 3^{L-1} < B · (2^V − 3^L)`.

Following the project conditional-theorem convention (see `docs/lean-proof-strategy.md`), this is stated as a `Prop` hypothesis rather than asserted as an axiom. Specialised at `B = 17,087,915` (Eliahous threshold), this is what the irrationality measure of `log₂ 3` (Rhin–Viola 1996; Wu 2003 and successors) provides for sufficiently large `L`, combined with a finite verification for `L` below the analytical threshold.

Empirical evidence (`scripts/method1_kill_criterion.py`, `docs/reports/2026-05-14-method1-survivor-bound.md`): the inequality holds for `L ≤ 400` at the minimal `V`, with the analytical UB `L · 3^{L−1} / (2^V − 3^L)` staying ≤ ~1.3 × 10⁴ for that range — four orders of magnitude below the `1.7 × 10⁷` threshold.
-/
def GapStrengthHypothesis (B : Nat) : Prop := ∀ L V : Nat, 1 ≤ L → 3 ^ L < 2 ^ V → L * 3 ^ (L - 1) < B * (2 ^ V - 3 ^ L)


/--
**Conditional cycle minimum bound for slow-growth survivors.**

Specialisation of `nat_lt_of_slow_growth_gap_strong` against `GapStrengthHypothesis`: any `n` satisfying the cycle-side inequality `n · (2^V − 3^L) ≤ offset w` for a slow-growth v-word `w` of length ≥ 1 with `2^V > 3^{w.length}` lies strictly below `B`, conditional on the gap-strength hypothesis at threshold `B`.

In the Method 1 + Eliahou closure of `cycle.L7_plus.Dpos_large_k`, applied with `B = 17,087,915` (Eliahou) this rules out the slow-growth-survivor branch entirely.
-/
theorem nat_lt_B_of_slow_growth_under_hypothesis (B : Nat) (hHyp : GapStrengthHypothesis B) (w : ParityWord) (V : Nat) (hL : 1 ≤ w.length) (hPos : 3 ^ w.length < 2 ^ V) (hSlow : ∀ k, k ≤ w.length → 2 ^ totalV (w.take k) ≤ 3 ^ k) (n : Nat) (hCycle : n * (2 ^ V - 3 ^ w.length) ≤ offset w) : n < B := nat_lt_of_slow_growth_gap_strong w V B hSlow (hHyp _ _ hL hPos) n hCycle

