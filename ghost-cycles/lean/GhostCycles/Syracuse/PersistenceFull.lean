/-
  Ghost Cycles of the Syracuse Map
  Theorem 6: Full Persistence of Case-(a) Ghosts

  Key results:
  1. D odd → D is coprime to 2^k (modular inverse exists)
  2. The congruence n₁ · D ≡ R (mod 2^k) has a unique solution
  3. The solution n₁ is odd (from R odd, D odd)
  4. Solutions at higher levels refine those at lower levels
  5. Persistence: the ghost materializes at all sufficiently large levels

  Reference: McKenna (2026), Section 7.
-/

import GhostCycles.Syracuse.Persistence
import GhostCycles.Syracuse.GeneralOrbit
import Mathlib.RingTheory.Coprime.Lemmas
import Mathlib.Tactic

namespace GhostCycles

/-! ## Part 1: Coprimality

  D odd → IsCoprime D (2^k) for all k.
  The modular inverse of D exists modulo any power of 2.
-/

/-- An odd integer is coprime to 2. Constructive: D = 2m+1 gives 1·D + (-m)·2 = 1. -/
theorem odd_isCoprime_two {D : ℤ} (hD : Odd D) : IsCoprime D 2 := by
  obtain ⟨m, hm⟩ := hD
  exact ⟨1, -m, by rw [hm]; ring⟩

/-- An odd integer is coprime to any power of 2. -/
theorem odd_isCoprime_two_pow {D : ℤ} (hD : Odd D) (k : ℕ) :
    IsCoprime D ((2 : ℤ) ^ k) :=
  odd_isCoprime_two hD |>.pow_right

/-! ## Part 2: Existence and uniqueness of the modular solution

  The congruence n₁ · D ≡ R (mod 2^k) has a unique solution modulo 2^k.
  This is the starting point n₁ of the modular cycle at level k.
-/

/-- If D is coprime to M, the congruence n·D ≡ R (mod M) has a solution.
    Constructive: from IsCoprime D M we get a·D + b·M = 1,
    so (R·a)·D = R·(1 - b·M) ≡ R (mod M). -/
theorem coprime_mod_solution_exists {D M : ℤ} (R : ℤ) (hcop : IsCoprime D M) :
    ∃ n : ℤ, M ∣ (n * D - R) := by
  obtain ⟨a, b, hab⟩ := hcop
  -- R·a·D - R = R·(a·D - 1) = R·(-(b·M)) = -(R·b)·M
  refine ⟨R * a, -(R * b), ?_⟩
  -- Goal: R * a * D - R = -(R * b) * M
  -- From hab: a * D + b * M = 1, so R·(a·D + b·M) = R
  -- i.e., R·a·D + R·b·M = R, i.e., R·a·D - R = -(R·b·M)
  have hmul : R * (a * D + b * M) = R * 1 := congr_arg (R * ·) hab
  linarith [mul_add R (a * D) (b * M)]

/-- If D is coprime to M, the solution is unique modulo M.
    Proof: (n₁ - n₂)·D ≡ 0 (mod M) and gcd(D, M) = 1 implies M | (n₁ - n₂). -/
theorem coprime_mod_solution_unique {D M : ℤ} (hcop : IsCoprime D M)
    {n₁ n₂ R : ℤ} (h1 : M ∣ (n₁ * D - R)) (h2 : M ∣ (n₂ * D - R)) :
    M ∣ (n₁ - n₂) := by
  have hdiff : M ∣ ((n₁ - n₂) * D) := by
    have : (n₁ - n₂) * D = (n₁ * D - R) - (n₂ * D - R) := by ring
    rw [this]; exact dvd_sub h1 h2
  exact hcop.symm.dvd_of_dvd_mul_right hdiff

/-- Ghost cycle solution exists: D odd → ∃ n₁ with n₁·D ≡ R (mod 2^k). -/
theorem ghost_solution_exists {D : ℤ} (R : ℤ) (hD : Odd D) (k : ℕ) :
    ∃ n₁ : ℤ, (2 : ℤ) ^ k ∣ (n₁ * D - R) :=
  coprime_mod_solution_exists R (odd_isCoprime_two_pow hD k)

/-- Ghost cycle solution unique: if n₁·D ≡ n₂·D ≡ R (mod 2^k), then n₁ ≡ n₂ (mod 2^k). -/
theorem ghost_solution_unique {D : ℤ} (hD : Odd D) (k : ℕ)
    {n₁ n₂ R : ℤ} (h1 : (2 : ℤ) ^ k ∣ (n₁ * D - R)) (h2 : (2 : ℤ) ^ k ∣ (n₂ * D - R)) :
    (2 : ℤ) ^ k ∣ (n₁ - n₂) :=
  coprime_mod_solution_unique (odd_isCoprime_two_pow hD k) h1 h2

/-! ## Part 3: The solution is odd

  R odd and D odd → R·D⁻¹ is odd (mod 2^k for k ≥ 1).
  Equivalently: if n₁·D ≡ R (mod 2^k) with k ≥ 1, then n₁ is odd.
-/

/-- If n₁·D ≡ R (mod 2) with D odd and R odd, then n₁ is odd.
    Proof: n₁ even → n₁·D even → n₁·D - R odd → 2 ∤ (n₁·D - R), contradiction. -/
theorem ghost_solution_odd_mod2 {D R n₁ : ℤ} (_hD : Odd D) (hR : Odd R)
    (h : (2 : ℤ) ∣ (n₁ * D - R)) : Odd n₁ := by
  by_contra hne
  rw [Int.not_odd_iff_even] at hne
  -- n₁ even → n₁ * D even → n₁ * D - R = even - odd is odd
  -- But h says 2 | (n₁ * D - R), contradicting oddness
  have heven_prod : Even (n₁ * D) := hne.mul_right _
  obtain ⟨m, hm⟩ := heven_prod  -- n₁ * D = m + m
  obtain ⟨r, hr⟩ := hR          -- R = 2 * r + 1
  obtain ⟨c, hc⟩ := h           -- n₁ * D - R = 2 * c
  -- m + m - (2r + 1) = 2c, so 2m - 2r - 1 = 2c, so 2(m - r - c) = 1. Impossible.
  omega

/-- The ghost cycle starting point n₁ is odd at any level k ≥ 1. -/
theorem ghost_solution_odd {D R n₁ : ℤ} (hD : Odd D) (hR : Odd R)
    {k : ℕ} (hk : 1 ≤ k) (h : (2 : ℤ) ^ k ∣ (n₁ * D - R)) : Odd n₁ := by
  apply ghost_solution_odd_mod2 hD hR
  exact dvd_trans (pow_dvd_pow 2 hk) h

/-! ## Part 4: Solution refinement

  Solutions at higher levels extend solutions at lower levels:
  if n₁·D ≡ R (mod 2^{k+m}), then n₁·D ≡ R (mod 2^k).
-/

/-- A divisibility at a higher power implies divisibility at a lower power. -/
theorem ghost_solution_refines {D R n₁ : ℤ} {k m : ℕ}
    (h : (2 : ℤ) ^ (k + m) ∣ (n₁ * D - R)) :
    (2 : ℤ) ^ k ∣ (n₁ * D - R) :=
  dvd_trans (pow_dvd_pow 2 (Nat.le_add_right k m)) h

/-! ## Part 5: Full Persistence Theorem

  Combining everything: for any deposit pattern ds with all deposits ≥ 1,
  the ghost cycle materializes at every level k ≥ 1.

  Specifically: the exact cycle equation n₁ · D = R gives:
  - A unique n₁ mod 2^k satisfying the congruence
  - n₁ is odd
  - The modular orbit has the correct valuations (from universal case-a)
  - The modular orbit closes (from the exact closure)
-/

/-- **Exact equation implies oddness.**
    If n₁ · D = R exactly (with D, R odd), then n₁ is odd.
    Note: part (1) is trivially true since n₁·D - R = 0. -/
theorem exact_equation_odd
    (ds : List ℕ) (hne : ds ≠ [])
    (hvalid : ∀ x ∈ ds, 0 < x)
    (hV : 1 ≤ ds.sum)
    (n₁ : ℤ)
    (hexact : n₁ * (2 ^ ds.sum - 3 ^ ds.length) = ghostR ds)
    (k : ℕ) :
    -- (1) The congruence holds mod 2^k
    (2 : ℤ) ^ k ∣ (n₁ * (2 ^ ds.sum - 3 ^ ds.length) - ghostR ds)
    -- (2) n₁ is odd
    ∧ Odd n₁ := by
  constructor
  · -- (1) follows from the exact equation
    rw [hexact]; simp
  · -- (2) n₁ is odd since D and R are both odd
    have hD_odd : Odd ((2 : ℤ) ^ ds.sum - 3 ^ ds.length) :=
      ghostDenom_odd (L := ds.length) hV
    have hR_odd : Odd (ghostR ds) := by
      obtain ⟨v, vs, hds_eq⟩ := List.exists_cons_of_ne_nil hne
      have hv_pos : 1 ≤ v := by
        apply hvalid; rw [hds_eq]; exact List.Mem.head vs
      rw [hds_eq]; exact ghostR_odd hv_pos
    -- If n₁ were even, n₁ * D would be even, contradicting R odd
    by_contra hne
    rw [Int.not_odd_iff_even] at hne
    have heven_prod : Even (n₁ * (2 ^ ds.sum - 3 ^ ds.length)) := hne.mul_right _
    rw [hexact] at heven_prod
    -- heven_prod : Even (ghostR ds), but hR_odd : Odd (ghostR ds)
    obtain ⟨m, hm⟩ := heven_prod
    obtain ⟨r, hr⟩ := hR_odd
    omega  -- m + m = 2 * r + 1 is impossible

/-- **Persistence corollary: any solution to the modular congruence is odd.**
    For a case-(a) ghost (all deposits ≥ 1), any n₁ satisfying
    n₁ · D ≡ R (mod 2^k) must be odd. -/
theorem persistence_solution_odd
    (ds : List ℕ) (hne : ds ≠ [])
    (hvalid : ∀ x ∈ ds, 0 < x)
    (hV : 1 ≤ ds.sum)
    (n₁ : ℤ) (k : ℕ) (hk : 1 ≤ k)
    (h : (2 : ℤ) ^ k ∣ (n₁ * (2 ^ ds.sum - 3 ^ ds.length) - ghostR ds)) :
    Odd n₁ := by
  have hD_odd : Odd ((2 : ℤ) ^ ds.sum - 3 ^ ds.length) :=
    ghostDenom_odd (L := ds.length) hV
  have hR_odd : Odd (ghostR ds) := by
    obtain ⟨v, vs, hds_eq⟩ := List.exists_cons_of_ne_nil hne
    rw [hds_eq]; exact ghostR_odd (by apply hvalid; rw [hds_eq]; exact List.Mem.head vs)
  exact ghost_solution_odd hD_odd hR_odd hk h

/-! ## Part 6: Euler-Lagrange periodicity

  D odd and |D| > 1 → there exists p > 0 with |D| ∣ (2^p - 1).
  This p (the multiplicative order of 2 mod |D|) controls the period
  of the 2-adic expansion of D⁻¹.
-/

/-- D odd implies |D| is odd (as a natural number). -/
theorem natAbs_odd_of_odd {D : ℤ} (hD : Odd D) : Odd D.natAbs :=
  Int.natAbs_odd.mpr hD

/-- D odd implies 2 is coprime to |D|. -/
theorem two_coprime_natAbs {D : ℤ} (hD : Odd D) : Nat.Coprime 2 D.natAbs :=
  Nat.coprime_two_left.mpr (natAbs_odd_of_odd hD)

/-- **Euler-Lagrange theorem for ghost denominators.**
    D odd and |D| > 1 implies there exists p > 0 with |D| ∣ (2^p - 1).
    Proof: 2 is a unit in (ZMod |D|)ˣ; by Lagrange, 2^|G| = 1.
    The smallest such p is the multiplicative order ord₂(|D|). -/
theorem exists_period {D : ℤ} (hD : Odd D) (habs : 1 < D.natAbs) :
    ∃ p : ℕ, 0 < p ∧ (D.natAbs : ℤ) ∣ ((2 : ℤ) ^ p - 1) := by
  haveI : NeZero D.natAbs := ⟨by omega⟩
  set n := D.natAbs with hn_def
  -- Create 2 as a unit in (ZMod n)ˣ
  have hcop := two_coprime_natAbs hD
  let u : (ZMod n)ˣ := ZMod.unitOfCoprime 2 hcop
  -- By Lagrange: u ^ |G| = 1 in the finite group (ZMod n)ˣ
  have hpow : u ^ Fintype.card (ZMod n)ˣ = 1 := pow_card_eq_one
  have hcard_pos : 0 < Fintype.card (ZMod n)ˣ := Fintype.card_pos
  set p := Fintype.card (ZMod n)ˣ with hp_def
  refine ⟨p, hcard_pos, ?_⟩
  -- Step 1: u^p = 1 in units → (2 : ZMod n)^p = 1 in ZMod n
  have hzmod : ((2 : ℕ) : ZMod n) ^ p = 1 := by
    have hu_val : (u : ZMod n) = ((2 : ℕ) : ZMod n) := ZMod.coe_unitOfCoprime 2 hcop
    calc ((2 : ℕ) : ZMod n) ^ p
        = (u : ZMod n) ^ p := by rw [hu_val]
      _ = ((u ^ p : (ZMod n)ˣ) : ZMod n) := (Units.val_pow_eq_pow_val u p).symm
      _ = 1 := by rw [hpow, Units.val_one]
  -- Step 2: (2 : ZMod n)^p = 1 → n ∣ (2^p - 1) as natural numbers
  have h2p_mod : (2 ^ p : ℕ) % n = 1 := by
    have h : ((2 ^ p : ℕ) : ZMod n) = ((1 : ℕ) : ZMod n) := by push_cast; exact hzmod
    rw [ZMod.natCast_eq_natCast_iff'] at h
    simpa [Nat.mod_eq_of_lt habs] using h
  have hnat_dvd : n ∣ (2 ^ p - 1 : ℕ) := by
    rw [← Nat.modEq_iff_dvd' (Nat.one_le_pow p 2 (by omega))]
    exact (Nat.ModEq.symm (by rwa [Nat.ModEq, Nat.mod_eq_of_lt habs]))
  -- Step 3: Cast to integer divisibility
  have h1 : 1 ≤ 2 ^ p := Nat.one_le_pow p 2 (by omega)
  zify [h1] at hnat_dvd
  exact hnat_dvd

/-! ## Part 7: Valuation bridge — connecting rational and modular orbits

  The key identity: D·(3n+1) - (3R+D) = 3·(nD - R).
  So if nD ≡ R (mod 2^k), then D·(3n+1) ≡ 3R+D (mod 2^k).
  Since D is odd, v₂(3n+1) = v₂(D·(3n+1)) = v₂(3R+D).
-/

/-- **Valuation bridge.** If n·D ≡ R (mod 2^k),
    then D·(3n+1) ≡ 3R+D (mod 2^k).
    Proof: D·(3n+1) - (3R+D) = 3·(nD - R). -/
theorem modular_valuation_bridge {D R n : ℤ} {k : ℕ}
    (h : (2 : ℤ) ^ k ∣ (n * D - R)) :
    (2 : ℤ) ^ k ∣ (D * (3 * n + 1) - (3 * R + D)) := by
  have : D * (3 * n + 1) - (3 * R + D) = 3 * (n * D - R) := by ring
  rw [this]; exact dvd_mul_of_dvd_right h 3

/-- **Valuation transfer (divisibility direction).**
    If 2^v ∣ (3R+D) and n·D ≡ R (mod 2^k) with v ≤ k,
    then 2^v ∣ (3n+1).
    Uses: D odd → 2^v ∣ D·(3n+1) → 2^v ∣ (3n+1). -/
theorem valuation_transfer_dvd {D R n : ℤ} {k v : ℕ}
    (hD : Odd D) (hv : v ≤ k)
    (hmod : (2 : ℤ) ^ k ∣ (n * D - R))
    (hdvd : (2 : ℤ) ^ v ∣ (3 * R + D)) :
    (2 : ℤ) ^ v ∣ (3 * n + 1) := by
  -- Step 1: 2^v ∣ D·(3n+1) - (3R+D) (from bridge, truncated to 2^v)
  have hbridge_v : (2 : ℤ) ^ v ∣ (D * (3 * n + 1) - (3 * R + D)) :=
    dvd_trans (pow_dvd_pow 2 hv) (modular_valuation_bridge hmod)
  -- Step 2: 2^v ∣ D·(3n+1) (from steps 1 + hypothesis, via dvd_add)
  have hprod : (2 : ℤ) ^ v ∣ (D * (3 * n + 1)) := by
    have heq : D * (3 * n + 1) = (D * (3 * n + 1) - (3 * R + D)) + (3 * R + D) := by ring
    rw [heq]; exact dvd_add hbridge_v hdvd
  -- Step 3: D odd → coprime to 2^v → cancel D
  exact (odd_isCoprime_two_pow hD v).symm.dvd_of_dvd_mul_left hprod

/-- **Valuation transfer (non-divisibility direction).**
    If ¬ 2^{v+1} ∣ (3R+D) and n·D ≡ R (mod 2^k) with v+1 ≤ k,
    then ¬ 2^{v+1} ∣ (3n+1).
    Contrapositive: 2^{v+1} ∣ (3n+1) → 2^{v+1} ∣ D·(3n+1) → 2^{v+1} ∣ (3R+D). -/
theorem valuation_transfer_not_dvd {D R n : ℤ} {k v : ℕ}
    (hD : Odd D) (hv : v + 1 ≤ k)
    (hmod : (2 : ℤ) ^ k ∣ (n * D - R))
    (hndvd : ¬ (2 : ℤ) ^ (v + 1) ∣ (3 * R + D)) :
    ¬ (2 : ℤ) ^ (v + 1) ∣ (3 * n + 1) := by
  intro habs
  apply hndvd
  -- 2^{v+1} ∣ D·(3n+1) (D is just a factor, no coprimality needed)
  have hprod : (2 : ℤ) ^ (v + 1) ∣ (D * (3 * n + 1)) := dvd_mul_of_dvd_right habs D
  -- 2^{v+1} ∣ D·(3n+1) - (3R+D) (from bridge)
  have hbridge_v : (2 : ℤ) ^ (v + 1) ∣ (D * (3 * n + 1) - (3 * R + D)) :=
    dvd_trans (pow_dvd_pow 2 hv) (modular_valuation_bridge hmod)
  -- 3R+D = D·(3n+1) - (D·(3n+1) - (3R+D))
  have heq : 3 * R + D = D * (3 * n + 1) - (D * (3 * n + 1) - (3 * R + D)) := by ring
  rw [heq]; exact dvd_sub hprod hbridge_v

/-- **Modular valuation stability (combined).**
    The modular orbit inherits exact valuations from the rational orbit. -/
theorem modular_valuation_stable {D R n : ℤ} {k v : ℕ}
    (hD : Odd D) (hv : v + 1 ≤ k)
    (hmod : (2 : ℤ) ^ k ∣ (n * D - R))
    (hval : (2 : ℤ) ^ v ∣ (3 * R + D) ∧ ¬ (2 : ℤ) ^ (v + 1) ∣ (3 * R + D)) :
    (2 : ℤ) ^ v ∣ (3 * n + 1) ∧ ¬ (2 : ℤ) ^ (v + 1) ∣ (3 * n + 1) :=
  ⟨valuation_transfer_dvd hD (Nat.le_of_succ_le hv) hmod hval.1,
   valuation_transfer_not_dvd hD hv hmod hval.2⟩

/-! ## Part 8: Full Persistence Theorem (Theorem 6)

  Given the rational orbit R satisfying the numerator recurrence
  and universal case-a, and given ANY sequence n₀, ..., n_L satisfying
  n_i · D ≡ R_i (mod 2^k), the three persistence conditions hold:
  (1) Each n_i is odd
  (2) 2^{v_i} ∥ (3n_i + 1) — valuations match
  (3) n_L ≡ n_0 (mod 2^k) — cycle closes
-/

/-- **Theorem 6 (Persistence of case-(a) ghosts, operational form).**
    The rational orbit induces a valid modular cycle at every sufficiently
    large level k. Any sequence of integers n_i with n_i·D ≡ R_i (mod 2^k)
    satisfies oddness, valuation stability, and cycle closure. -/
theorem persistence_theorem6
    (ds : List ℕ) (hne : ds ≠ [])
    (hvalid : ∀ x ∈ ds, 0 < x)
    (hV : 1 ≤ ds.sum)
    -- The rational orbit
    (R : ℕ → ℤ) (D : ℤ)
    (hD : D = 2 ^ ds.sum - 3 ^ ds.length)
    (hR0 : R 0 = ghostR ds)
    (hsteps : ∀ i (h : i < ds.length),
      R (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * R i + D)
    -- The modular approximations
    (n : ℕ → ℤ) (k : ℕ)
    (hmod : ∀ i (hi : i ≤ ds.length),
      (2 : ℤ) ^ k ∣ (n i * D - R i))
    -- Level is large enough: k ≥ v_i + 1 for all i
    (hk : ∀ i (hi : i < ds.length), ds.get ⟨i, hi⟩ + 1 ≤ k) :
    -- (1) Each n_i is odd
    (∀ i (hi : i ≤ ds.length), Odd (n i))
    -- (2) Valuations match: 2^{v_i} ∥ (3n_i + 1)
    ∧ (∀ i (hi : i < ds.length),
        (2 : ℤ) ^ ds.get ⟨i, hi⟩ ∣ (3 * n i + 1)
        ∧ ¬ (2 : ℤ) ^ (ds.get ⟨i, hi⟩ + 1) ∣ (3 * n i + 1))
    -- (3) Cycle closes modularly
    ∧ (2 : ℤ) ^ k ∣ (n ds.length - n 0) := by
  have hD_odd : Odd D := hD ▸ ghostDenom_odd (L := ds.length) hV
  -- Extract ghost R oddness for each orbit element
  have hR_odd : ∀ i (hi : i ≤ ds.length), Odd (R i) :=
    orbit_all_odd ds hne hvalid R D hD hR0 hsteps
  -- (1) Oddness: R_i odd + D odd + n_i·D ≡ R_i (mod 2^k) → n_i odd
  have hodd : ∀ i (hi : i ≤ ds.length), Odd (n i) := by
    intro i hi
    have hk_pos : 1 ≤ k := by
      obtain ⟨v, _, hds_eq⟩ := List.exists_cons_of_ne_nil hne
      have : 0 < ds.length := by rw [hds_eq]; simp
      have := hk 0 this
      have hv_pos := hvalid v (by rw [hds_eq]; exact List.Mem.head _)
      omega
    exact ghost_solution_odd hD_odd (hR_odd i hi) hk_pos (hmod i hi)
  -- (2) Valuations: use universal_case_a_general + valuation transfer
  have hvals : ∀ i (hi : i < ds.length),
      (2 : ℤ) ^ ds.get ⟨i, hi⟩ ∣ (3 * n i + 1)
      ∧ ¬ (2 : ℤ) ^ (ds.get ⟨i, hi⟩ + 1) ∣ (3 * n i + 1) := by
    intro i hi
    -- Get the rational valuation: 2^{v_i} ∥ (3R_i + D)
    have hvi : 0 < ds.get ⟨i, hi⟩ := hvalid _ (List.get_mem ds ⟨i, hi⟩)
    have hval_rat := universal_case_a_general ds hne hvalid R D hD hR0 hsteps i hi hvi
    -- Transfer to modular: n_i·D ≡ R_i (mod 2^k)
    exact modular_valuation_stable hD_odd (hk i hi) (hmod i (le_of_lt hi)) hval_rat
  -- (3) Cycle closure: R(L) = R(0) from the orbit formula, then uniqueness
  have hclosure : (2 : ℤ) ^ k ∣ (n ds.length - n 0) := by
    -- R(L) = ghostR(ds) = R(0)
    have hRL : R ds.length = R 0 := by
      have iter := orbit_numerator_iteration D ds R hsteps
      rw [hR0, hD] at iter
      -- iter: R(L)·2^V = 3^L·ghostR(ds) + (2^V-3^L)·ghostR(ds) = 2^V·ghostR(ds)
      have hsimp : 3 ^ ds.length * ghostR ds +
          (2 ^ ds.sum - 3 ^ ds.length) * ghostR ds =
          2 ^ ds.sum * ghostR ds := by ring
      have key : 2 ^ ds.sum * R ds.length = 2 ^ ds.sum * ghostR ds := by linarith
      have := mul_left_cancel₀ (show (2 : ℤ) ^ ds.sum ≠ 0 by positivity) key
      linarith [hR0]
    -- Specialize hmod at i=L and i=0, use R(L) = R(0)
    have hmodL := hmod ds.length le_rfl
    rw [hRL] at hmodL
    exact ghost_solution_unique hD_odd k hmodL (hmod 0 (Nat.zero_le _))
  exact ⟨hodd, hvals, hclosure⟩

/-! ## Part 9: Materialization predicate and self-contained theorem

  Package the three conditions into a formal predicate.
  Prove: given a rational orbit, the ghost materializes at every sufficiently large level.
-/

/-- **Ghost materialization at level k.**
    A ghost cycle with deposit pattern ds materializes at level k if there exist
    integers n₀, ..., n_L (the modular orbit) satisfying:
    (1) all odd, (2) correct valuations, (3) cycle closure mod 2^k. -/
def GhostMaterializes (ds : List ℕ) (k : ℕ) : Prop :=
  ∃ n : ℕ → ℤ,
    (∀ i, i ≤ ds.length → Odd (n i))
    ∧ (∀ i (hi : i < ds.length),
        (2 : ℤ) ^ ds.get ⟨i, hi⟩ ∣ (3 * n i + 1)
        ∧ ¬ (2 : ℤ) ^ (ds.get ⟨i, hi⟩ + 1) ∣ (3 * n i + 1))
    ∧ (2 : ℤ) ^ k ∣ (n ds.length - n 0)

/-- **Ghost materializes at all sufficiently large levels.**
    Given a deposit pattern with a valid rational orbit, the ghost materializes
    at every level k ≥ max(v_i) + 1. The modular orbit is constructed via
    the modular inverse (ghost_solution_exists). -/
theorem ghost_materializes_all_large
    (ds : List ℕ) (hne : ds ≠ [])
    (hvalid : ∀ x ∈ ds, 0 < x)
    (hV : 1 ≤ ds.sum)
    -- The rational orbit (hypothesized, as in the rest of the codebase)
    (R : ℕ → ℤ)
    (hR0 : R 0 = ghostR ds)
    (hsteps : ∀ i (h : i < ds.length),
      R (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * R i + (2 ^ ds.sum - 3 ^ ds.length))
    -- Level is large enough
    (k : ℕ)
    (hk : ∀ i (hi : i < ds.length), ds.get ⟨i, hi⟩ + 1 ≤ k) :
    GhostMaterializes ds k := by
  set D := (2 : ℤ) ^ ds.sum - 3 ^ ds.length with hD_def
  have hD_odd : Odd D := ghostDenom_odd (L := ds.length) hV
  -- Construct modular orbit: for each i, pick n_i solving n_i·D ≡ R_i (mod 2^k)
  choose n_func hn_func using fun i => ghost_solution_exists (R i) hD_odd k
  -- Apply persistence_theorem6
  have ⟨hodd, hvals, hclosure⟩ := persistence_theorem6 ds hne hvalid hV R D
    hD_def.symm hR0 hsteps n_func k (fun i hi => hn_func i) hk
  exact ⟨n_func, hodd, hvals, hclosure⟩

/-- **Materialization is monotone in k (for large k).**
    If the ghost materializes at level k, it materializes at all levels k' ≥ k
    (provided k is already above the threshold). -/
theorem ghost_materializes_monotone
    (ds : List ℕ) (hne : ds ≠ [])
    (hvalid : ∀ x ∈ ds, 0 < x)
    (hV : 1 ≤ ds.sum)
    (R : ℕ → ℤ)
    (hR0 : R 0 = ghostR ds)
    (hsteps : ∀ i (h : i < ds.length),
      R (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * R i + (2 ^ ds.sum - 3 ^ ds.length))
    (k k' : ℕ)
    (hk : ∀ i (hi : i < ds.length), ds.get ⟨i, hi⟩ + 1 ≤ k)
    (hkk' : k ≤ k') :
    GhostMaterializes ds k' := by
  exact ghost_materializes_all_large ds hne hvalid hV R hR0 hsteps k'
    (fun i hi => le_trans (hk i hi) hkk')

/-- **Periodicity corollary (Theorem 6, Part B).**
    If k₀ is above the threshold and k ≡ k₀ (mod p) with k ≥ k₀,
    then the ghost materializes at level k.
    This follows trivially because we prove materialization at ALL k ≥ threshold. -/
theorem ghost_materializes_periodic
    (ds : List ℕ) (hne : ds ≠ [])
    (hvalid : ∀ x ∈ ds, 0 < x)
    (hV : 1 ≤ ds.sum)
    (R : ℕ → ℤ)
    (hR0 : R 0 = ghostR ds)
    (hsteps : ∀ i (h : i < ds.length),
      R (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * R i + (2 ^ ds.sum - 3 ^ ds.length))
    -- k₀ is above threshold
    (k₀ : ℕ)
    (hk₀ : ∀ i (hi : i < ds.length), ds.get ⟨i, hi⟩ + 1 ≤ k₀)
    -- k ≥ k₀ (and k ≡ k₀ mod p, which we don't need)
    (k : ℕ) (hk : k₀ ≤ k) :
    GhostMaterializes ds k :=
  ghost_materializes_monotone ds hne hvalid hV R hR0 hsteps k₀ k hk₀ hk

end GhostCycles
