/-
  Ghost Cycles of the Syracuse Map
  Formal definition of the Syracuse map and connection to step relations

  Gap 2: Show that the hypothesis `orbit(i+1) * 2^{v_i} = 3 * orbit(i) + 1`
  is exactly what the Syracuse map produces when v₂(3·orbit(i)+1) = v_i.

  Uses Mathlib's `padicValNat` for the 2-adic valuation.

  Reference: McKenna (2026), Section 2.
-/

import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Tactic

namespace GhostCycles

/-! ## The Syracuse map using Mathlib's padicValNat -/

/-- The Syracuse map: S(n) = (3n+1) / 2^{v₂(3n+1)} for odd n > 0.
    Returns 0 for even n or n = 0. -/
def syracuse (n : ℕ) : ℕ :=
  if n % 2 = 1 then (3 * n + 1) / 2 ^ padicValNat 2 (3 * n + 1)
  else 0

/-! ## The step relation IS the Syracuse map -/

/-- **The Syracuse step relation follows from the map definition.**

    If n is odd, then syracuse(n) * 2^{v₂(3n+1)} = 3n + 1.

    This is EXACTLY the hypothesis used in CycleEquation.lean:
      orbit(i+1) * 2^{v_i} = 3 * orbit(i) + 1
    with orbit(i+1) = syracuse(orbit(i)) and v_i = padicValNat 2 (3·orbit(i)+1).

    Proof: (3n+1) / 2^{v₂(3n+1)} * 2^{v₂(3n+1)} = 3n+1 by Nat.div_mul_cancel,
    since 2^{v₂(m)} | m (Mathlib: pow_padicValNat_dvd). -/
theorem syracuse_step_relation (n : ℕ) (hn : n % 2 = 1) :
    syracuse n * 2 ^ padicValNat 2 (3 * n + 1) = 3 * n + 1 := by
  unfold syracuse
  rw [if_pos hn]
  exact Nat.div_mul_cancel pow_padicValNat_dvd

/-- **Lifting to integers.**
    The step relation over ℤ, matching CycleEquation.lean's hypotheses. -/
theorem syracuse_step_relation_int (n : ℕ) (hn : n % 2 = 1) :
    (syracuse n : ℤ) * 2 ^ padicValNat 2 (3 * n + 1) = 3 * (n : ℤ) + 1 := by
  exact_mod_cast syracuse_step_relation n hn

/-! ## For odd n, 3n+1 is even (v₂ ≥ 1) -/

/-- For odd n, 3n+1 is even, so the Syracuse map divides by at least 2. -/
theorem val2_three_mul_odd_pos (n : ℕ) (hn : n % 2 = 1) :
    1 ≤ padicValNat 2 (3 * n + 1) := by
  haveI : Fact (Nat.Prime 2) := Fact.mk Nat.prime_two
  apply one_le_padicValNat_of_dvd (by omega : 3 * n + 1 ≠ 0)
  exact ⟨(3 * n + 1) / 2, by omega⟩

/-! ## Syracuse produces odd outputs -/

/-- **Syracuse sends odd to odd.**
    S(n) is always odd when n is odd and n > 0.

    Proof: syracuse(n) = (3n+1) / 2^{v₂(3n+1)}.
    By padicValNat.div_pow, v₂(syracuse(n)) = v₂(3n+1) - v₂(3n+1) = 0.
    Since v₂(x) = 0 and x > 0 implies x is odd, syracuse(n) is odd. -/
theorem syracuse_odd (n : ℕ) (hn : n % 2 = 1) (hn0 : 0 < n) :
    syracuse n % 2 = 1 := by
  haveI : Fact (Nat.Prime 2) := Fact.mk Nat.prime_two
  unfold syracuse
  rw [if_pos hn]
  -- Goal: (3*n+1) / 2^{v₂(3*n+1)} % 2 = 1
  set m := 3 * n + 1
  set v := padicValNat 2 m
  -- v₂(m/2^v) = v₂(m) - v = 0
  have hm_pos : 0 < m := by omega
  have hm_ne : m ≠ 0 := by omega
  have hdvd : 2 ^ v ∣ m := pow_padicValNat_dvd
  have hval_div : padicValNat 2 (m / 2 ^ v) = 0 := by
    rw [padicValNat.div_pow hdvd]
    omega
  -- m / 2^v > 0
  have hdiv_pos : 0 < m / 2 ^ v := Nat.div_pos (Nat.le_of_dvd hm_pos hdvd) (by positivity)
  -- v₂ = 0 means 2 does not divide m/2^v
  have hndvd : ¬ 2 ∣ (m / 2 ^ v) := by
    intro h
    have := one_le_padicValNat_of_dvd (by omega) h
    omega
  omega

end GhostCycles
