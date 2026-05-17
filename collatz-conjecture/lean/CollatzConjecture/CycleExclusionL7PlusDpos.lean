/-
  Conditional cycle exclusion at L ≥ 7, k < 17,087,915 (Dpos sub-range), modulo Eliahou (1993).

  Imports the published result of Eliahou (1993, Discrete Math 118:45–56)
  as a `Prop` hypothesis `EliahouCycleBound`, rather than a Lean `axiom`,
  per the literature-imports policy in `docs/lean-proof-strategy.md`.
  Downstream theorems carry the hypothesis explicitly; `#print axioms`
  stays clean.

  This module closes the sub-range 7 ≤ k < 17,087,915 of cycle.L7_plus.Dpos.
  The unconditional Dpos obligation (k ≥ 17,087,915) remains open and is the
  residue of the classical Collatz no-non-trivial-cycle problem.

  Generated from data/blueprint.db.
-/

import CollatzConjecture.SmallCycles

/--
Eliahou (1993): every non-trivial accelerated Collatz cycle has length k ≥ 17,087,915, where k counts the distinct elements (odd integers) of the cycle. Stated in our vocabulary: for every `IsAcceleratedOddCycle k q` with `q ≠ 1` (non-trivial), `17087915 ≤ k`.

  Status: **imported-conditional**. Eliahou's proof (Discrete Math 118:45–56, 1993; doi:10.1016/0012-365X(93)90052-U) uses Baker's theorem to reduce to a finite computation per excess m = V − k, then exhausts the small-m cases. Out of reach to formalize from scratch in this project. By the policy in `docs/lean-proof-strategy.md` §Literature imports, the result is stated here as a `Prop` rather than a Lean `axiom`: every downstream theorem that uses it takes `hE : EliahouCycleBound` as an explicit hypothesis, so `#print axioms` stays clean and the dependency on the external proof is visible at every use site.

  Convention check: Eliahou's "cycle length" counts the distinct elements of the cycle (one per odd integer). This equals our accelerated cycle length k. Confirmed via Hateley 2026 (cited as [3]) and Zoebelein 2024 (cited as [2]).

  See `data/blueprint.db` document `lit.eliahou.1993` for full publication metadata.
-/
def EliahouCycleBound : Prop := ∀ k q : Nat, IsAcceleratedOddCycle k q → q ≠ 1 → 17087915 ≤ k


/--
Conditional closure of cycle.L7_plus.Dpos on the sub-range 7 ≤ k < 17,087,915, modulo `EliahouCycleBound`.

  Bridge logic is trivial: if `q ≠ 1`, then `EliahouCycleBound` forces `k ≥ 17,087,915`, contradicting `k < 17,087,915`. So `q = 1` by `by_contra` + `omega`.

  Independent of the sign of D = 2^V − 3^k — the proof works for any accelerated cycle in the stated k range, not only the D > 0 regime. Filed under `cycle.L7_plus.Dpos_modulo_Eliahou` because that is the open obligation it shrinks; the stronger fact "no non-trivial cycle exists with 7 ≤ k < 17,087,915, modulo Eliahou" follows immediately from the same body.

  Closes obligation cycle.L7_plus.Dpos_modulo_Eliahou (sub-range only). The unconditional Dpos obligation, covering k ≥ 17,087,915, remains open — that is the classical Collatz cycle problem residue.
-/
theorem isAcceleratedOddCycle_Dpos_modulo_Eliahou (hE : EliahouCycleBound) (k q : Nat) (h : IsAcceleratedOddCycle k q) (_hk7 : 7 ≤ k) (hkE : k < 17087915) : q = 1 := by
  by_cases hq : q = 1
  · exact hq
  · exfalso
    have hgeE : 17087915 ≤ k := hE k q h hq
    omega

