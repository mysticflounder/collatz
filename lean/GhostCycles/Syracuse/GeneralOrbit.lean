/-
  Ghost Cycles of the Syracuse Map
  Theorems 7-9: Orbit Formula, Negative Rationality, Universal Case-(a)

  The proof chain:
  1. Orbit formula: R_i · 2^{S_{i-1}} = 3^{i-1} · R_1 + D · ghostR(prefix)
     (already proved as `orbit_numerator_iteration`)
  2. All R_i are odd (the KEY lemma — breaks the circularity)
  3. Universal Case-a follows from oddness + recurrence

  Reference: McKenna (2026), Section 9.
-/

import GhostCycles.Syracuse.OrbitFormula
import GhostCycles.Syracuse.NegativeRationality
import GhostCycles.Syracuse.GhostRAppend
import GhostCycles.Syracuse.Persistence
import Mathlib.Algebra.Ring.Parity
import Mathlib.Tactic

namespace GhostCycles

/-! ## ghostR is non-negative -/

theorem ghostR_nonneg : ∀ (ds : List ℕ), 0 ≤ ghostR ds := by
  intro ds
  induction ds with
  | nil => simp [ghostR]
  | cons v vs ih =>
    simp only [ghostR]
    have : (0 : ℤ) ≤ 3 ^ vs.length := by positivity
    have : (0 : ℤ) ≤ 2 ^ v * ghostR vs := mul_nonneg (by positivity) ih
    linarith

/-! ## Theorem 9 conditional: Universal Case-a from oddness

  IF all R_i are odd, THEN v₂(3R_i + D) = v_i at each step.
  This reduces the hard theorem to proving oddness.
-/

/-- **Universal Case-a, conditional on oddness.**
    If R_{i+1} · 2^{v_i} = 3R_i + D and R_{i+1} is odd and v_i ≥ 1,
    then 2^{v_i} exactly divides 3R_i + D. -/
theorem case_a_step (R_cur R_next D : ℤ) (v : ℕ)
    (hrecur : R_next * 2 ^ v = 3 * R_cur + D)
    (hodd_next : Odd R_next)
    (hv_pos : 1 ≤ v) :
    (2 : ℤ) ^ v ∣ (3 * R_cur + D)
    ∧ ¬ (2 : ℤ) ^ (v + 1) ∣ (3 * R_cur + D) := by
  constructor
  · -- 2^v | 3R + D since 3R + D = R_next · 2^v
    exact ⟨R_next, by linarith⟩
  · -- 2^{v+1} ∤ 3R + D: would imply R_next even
    intro ⟨c, hc⟩
    have h1 : 2 ^ v * R_next = 2 ^ v * (2 * c) := by
      have := mul_comm R_next ((2 : ℤ) ^ v)
      rw [pow_succ] at hc; linarith
    have h2 : R_next = 2 * c :=
      mul_left_cancel₀ (ne_of_gt (by positivity : (0 : ℤ) < 2 ^ v)) h1
    have heven : Even R_next := ⟨c, by linarith⟩
    have : ¬ Odd R_next := by rw [Int.not_odd_iff_even]; exact heven
    contradiction

/-! ## The oddness theorem

  SIMPLIFIED PROOF (vs the paper's double-sum analysis):

  Using ghostR_append: ghostR(a ++ b) = 3^|b| · ghostR(a) + 2^{sum a} · ghostR(b)

  The orbit formula gives: R(i) · 2^{S_i} = 3^i · R(0) + D · ghostR(ds.take i)
  Substitute R(0) = ghostR(ds) = ghostR(take ++ drop):

  R(i) · 2^{S_i} = 3^i · [3^{L-i} · ghostR(take) + 2^{S_i} · ghostR(drop)] + D · ghostR(take)
                  = [3^L + D] · ghostR(take) + 3^i · 2^{S_i} · ghostR(drop)
                  = 2^V · ghostR(take) + 3^i · 2^{S_i} · ghostR(drop)
                  = 2^{S_i} · [2^{V-S_i} · ghostR(take) + 3^i · ghostR(drop)]

  Since ghostR(drop) is odd (starts with v_i ≥ 1) and 3^i is odd:
    3^i · ghostR(drop) is odd.
  Since V - S_i ≥ 1:
    2^{V-S_i} · ghostR(take) is even (or 0).
  Therefore R(i) = even + odd = odd.
-/

/-- **All orbit numerators are odd.**
    The key lemma that makes Theorems 8 and 9 work.

    Proof: factor Q_i using ghostR_append + the cancellation 3^L + D = 2^V,
    then observe even + odd = odd. -/
theorem orbit_all_odd
    (ds : List ℕ) (hne : ds ≠ [])
    (hvalid : ∀ x ∈ ds, 0 < x)
    (R : ℕ → ℤ) (D : ℤ)
    (hD : D = 2 ^ ds.sum - 3 ^ ds.length)
    (hR0 : R 0 = ghostR ds)
    (hsteps : ∀ i (h : i < ds.length),
      R (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * R i + D)
    (i : ℕ) (hi : i ≤ ds.length) :
    Odd (R i) := by
  by_cases hiL : i < ds.length
  · -- Case i < L: use the factored orbit formula
    -- Step 1: Split ds = take i ++ drop i
    have hds_split : ds = ds.take i ++ ds.drop i := (List.take_append_drop i ds).symm
    -- Step 2: ghostR decomposition
    have hgR := ghostR_append (ds.take i) (ds.drop i)
    rw [← hds_split] at hgR
    rw [List.length_drop] at hgR
    -- Step 3: Orbit formula for prefix
    -- R(i) · 2^{S_i} = 3^i · R(0) + D · ghostR(take i)
    -- (from generalized_iteration applied to the take-prefix)
    -- We use the fact that R satisfies the recurrence on the prefix
    -- Step 3: Build step relations for the prefix ds.take i
    have hsteps_prefix : ∀ j (h : j < (ds.take i).length),
        R (j + 1) * 2 ^ (ds.take i).get ⟨j, h⟩ = 3 * R j + D := by
      intro j hj
      have hji : j < i := by rwa [List.length_take_of_le (by omega : i ≤ ds.length)] at hj
      have hj' : j < ds.length := by omega
      have : (ds.take i).get ⟨j, hj⟩ = ds.get ⟨j, hj'⟩ := by
        simp [List.getElem_take']
      rw [this]
      exact hsteps j hj'
    -- Step 4: Apply orbit formula to prefix
    have iter := orbit_numerator_iteration D (ds.take i) R hsteps_prefix
    rw [List.length_take_of_le (by omega : i ≤ ds.length)] at iter
    -- iter: R(i) · 2^{sum(take i)} = 3^i · R(0) + D · ghostR(take i)
    -- Step 5: Substitute R(0) = ghostR(ds) and decompose
    rw [hR0] at iter
    -- iter: R(i) · 2^{S_i} = 3^i · ghostR(ds) + D · ghostR(take i)
    -- Use hgR: ghostR(ds) = 3^{L-i} · ghostR(take i) + 2^{S_i} · ghostR(drop i)
    -- So: 3^i · ghostR(ds) = 3^i · 3^{L-i} · ghostR(take) + 3^i · 2^{S_i} · ghostR(drop)
    --                       = 3^L · ghostR(take) + 3^i · 2^{S_i} · ghostR(drop)
    -- Then: R(i) · 2^{S_i} = (3^L + D) · ghostR(take) + 3^i · 2^{S_i} · ghostR(drop)
    --                       = 2^V · ghostR(take) + 3^i · 2^{S_i} · ghostR(drop)
    --                       = 2^{S_i} · (2^{V-S_i} · ghostR(take) + 3^i · ghostR(drop))
    -- So R(i) = 2^{V-S_i} · ghostR(take) + 3^i · ghostR(drop)
    -- This is even + odd = odd.

    -- Compute the key quantity R(i) equals
    have hcancel : (3 : ℤ) ^ ds.length + D = 2 ^ ds.sum := by rw [hD]; ring
    -- ghostR(drop i) is odd
    have hdrop_ne : ds.drop i ≠ [] := by
      intro h; simp [List.length_drop] at h; omega
    obtain ⟨v, vs, hdrop_eq⟩ := List.exists_cons_of_ne_nil hdrop_ne
    have hv_pos : 1 ≤ v := by
      apply hvalid; exact List.mem_of_mem_drop (hdrop_eq ▸ List.Mem.head vs)
    have hdrop_odd : Odd (ghostR (ds.drop i)) := hdrop_eq ▸ ghostR_odd hv_pos

    -- The factored form: R(i) · 2^{S_i} = 2^{S_i} · (2^{V-S_i} · ghostR(take) + 3^i · ghostR(drop))
    -- First establish: R(i) · 2^{S_i} = 2^V · ghostR(take) + 3^i · 2^{S_i} · ghostR(drop)
    -- From iter: R(i) · 2^{S_i} = 3^i · ghostR(ds) + D · ghostR(take)
    -- From hgR: ghostR(ds) = 3^{L-i} · ghostR(take) + 2^{S_i} · ghostR(drop)
    -- Substituting and using 3^L + D = 2^V:
    have hV_gt : (ds.take i).sum < ds.sum := by
      have : ds.sum = (ds.take i).sum + (ds.drop i).sum := by
        conv_lhs => rw [hds_split]; rw [List.sum_append]
      have : 0 < (ds.drop i).sum := by
        rw [hdrop_eq]; simp [List.sum_cons]; omega
      omega
    -- Show R(i) = 2^{V-S_i} · ghostR(take) + 3^i · ghostR(drop)
    have hReq : R i = 2 ^ (ds.sum - (ds.take i).sum) * ghostR (ds.take i)
        + 3 ^ i * ghostR (ds.drop i) := by
      -- R(i) · 2^{S_i} = 3^i · ghostR(ds) + D · ghostR(take)
      -- = 3^i · (3^{L-i}·ghostR(take) + 2^{S_i}·ghostR(drop)) + D · ghostR(take)
      -- = (3^L + D) · ghostR(take) + 3^i · 2^{S_i} · ghostR(drop)
      -- = 2^V · ghostR(take) + 3^i · 2^{S_i} · ghostR(drop)
      -- = 2^{S_i} · (2^{V-S_i} · ghostR(take) + 3^i · ghostR(drop))
      -- R(i) · 2^{S_i} = 3^i · ghostR(ds) + D · ghostR(take)       [iter]
      -- ghostR(ds) = 3^{L-i} · ghostR(take) + 2^{S_i} · ghostR(drop)  [hgR]
      -- 3^i · 3^{L-i} = 3^L,  3^L + D = 2^V,  2^V = 2^{S_i} · 2^{V-S_i}
      -- Combining: R(i) · 2^{S_i} = 2^{S_i} · (2^{V-S_i} · ghostR(take) + 3^i · ghostR(drop))
      -- Cancel 2^{S_i}: R(i) = 2^{V-S_i} · ghostR(take) + 3^i · ghostR(drop)
      have h3pow : (3 : ℤ) ^ i * 3 ^ (ds.length - i) = 3 ^ ds.length := by
        rw [← pow_add]; congr 1; omega
      have h2pow : (2 : ℤ) ^ ds.sum =
          2 ^ (ds.take i).sum * 2 ^ (ds.sum - (ds.take i).sum) := by
        rw [← pow_add]; congr 1; omega
      -- The key: R(i) · 2^{S_i} = 2^{S_i} · (target expression)
      suffices h : 2 ^ (ds.take i).sum * R i =
          2 ^ (ds.take i).sum * (2 ^ (ds.sum - (ds.take i).sum) * ghostR (ds.take i)
          + 3 ^ i * ghostR (ds.drop i)) by
        exact mul_left_cancel₀ (by positivity : (2 : ℤ) ^ (ds.take i).sum ≠ 0) h
      -- Expand the RHS and match with iter + hgR + cancellation
      have rhs_expand : 2 ^ (ds.take i).sum *
          (2 ^ (ds.sum - (ds.take i).sum) * ghostR (ds.take i) +
           3 ^ i * ghostR (ds.drop i)) =
          2 ^ ds.sum * ghostR (ds.take i) +
          3 ^ i * 2 ^ (ds.take i).sum * ghostR (ds.drop i) := by
        rw [h2pow]; ring
      rw [rhs_expand]
      -- Now show: 2^{S_i} * R i = 2^V * ghostR(take) + 3^i * 2^{S_i} * ghostR(drop)
      -- From iter: R i * 2^{S_i} = 3^i * ghostR(ds) + D * ghostR(take)
      -- Expand ghostR(ds) via hgR, use h3pow and hcancel
      have lhs : 2 ^ (ds.take i).sum * R i = R i * 2 ^ (ds.take i).sum := by ring
      rw [lhs, iter, hgR]
      -- Goal: 3^i * (3^{L-i} * gR_take + 2^{S_i} * gR_drop) + D * gR_take
      --     = 2^V * gR_take + 3^i * 2^{S_i} * gR_drop
      -- Step 1: 3^i * 3^{L-i} = 3^L [h3pow], so factor and simplify
      -- Step 2: (3^L + D) = 2^V [hcancel]
      set gT := ghostR (ds.take i)
      set gD := ghostR (ds.drop i)
      set S := (ds.take i).sum
      -- After expansion, LHS = (3^i * 3^{L-i} + D) * gT + 3^i * 2^S * gD
      -- = (3^L + D) * gT + 3^i * 2^S * gD = 2^V * gT + 3^i * 2^S * gD = RHS
      have key : 3 ^ i * 3 ^ (ds.length - i) + D = 2 ^ ds.sum := by
        linarith [h3pow, hcancel]
      -- Distribute: 3^i * (A + B) + D * gT = (3^i * 3^{L-i} + D) * gT + 3^i * 2^S * gD
      have expand : 3 ^ i * (3 ^ (ds.length - i) * gT + 2 ^ S * gD) + D * gT =
          (3 ^ i * 3 ^ (ds.length - i) + D) * gT + 3 ^ i * 2 ^ S * gD := by ring
      rw [expand, key]
    rw [hReq]
    -- Now: 2^{V-S_i} · ghostR(take) is even, 3^i · ghostR(drop) is odd
    have heven : Even (2 ^ (ds.sum - (ds.take i).sum) * ghostR (ds.take i)) :=
      Even.mul_right (Even.pow_of_ne_zero even_two (by omega)) _
    have hodd : Odd (3 ^ i * ghostR (ds.drop i)) :=
      (Odd.pow ⟨1, by ring⟩ : Odd ((3 : ℤ) ^ i)).mul hdrop_odd
    exact heven.add_odd hodd
  · -- Case i ≥ L: must have i = L
    have hiL : i = ds.length := by omega
    subst hiL
    -- At i = L: orbit formula gives R(L) · 2^V = 3^L · R(0) + D · ghostR(ds)
    have iter := orbit_numerator_iteration D ds R hsteps
    rw [hR0, hD] at iter
    -- R(L) · 2^V = 3^L · ghostR + (2^V - 3^L) · ghostR = 2^V · ghostR
    have hReq : R ds.length = ghostR ds := by
      have : R ds.length * 2 ^ ds.sum = 2 ^ ds.sum * ghostR ds := by linarith
      exact mul_left_cancel₀ (by positivity : (2 : ℤ) ^ ds.sum ≠ 0)
        (by linarith)
    rw [hReq]
    obtain ⟨v, vs, hds_eq⟩ := List.exists_cons_of_ne_nil hne
    have hv_pos : 1 ≤ v := by
      apply hvalid; rw [hds_eq]; exact List.Mem.head vs
    rw [hds_eq]
    exact ghostR_odd hv_pos

/-! ## Full Theorems 8 and 9 -/

/-- **Theorem 8 (Negative Rationality).** All R_i > 0 when D < 0.
    Currently sorry — requires the cancellation analysis. -/
theorem negative_rationality_general
    (ds : List ℕ) (hne : ds ≠ [])
    (hvalid : ∀ x ∈ ds, 0 < x)
    (R : ℕ → ℤ) (D : ℤ)
    (hD : D = 2 ^ ds.sum - 3 ^ ds.length) (hDneg : D < 0)
    (hR0 : R 0 = ghostR ds)
    (hsteps : ∀ i (h : i < ds.length),
      R (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * R i + D)
    (i : ℕ) (hi : i ≤ ds.length) :
    0 < R i := by
  sorry

/-- **Theorem 9 (Universal Case-a).** v₂(3R_i + D) = v_i for all i.
    Proved from `orbit_all_odd` + `case_a_step`. -/
theorem universal_case_a_general
    (ds : List ℕ) (hne : ds ≠ [])
    (hvalid : ∀ x ∈ ds, 0 < x)
    (R : ℕ → ℤ) (D : ℤ)
    (hD : D = 2 ^ ds.sum - 3 ^ ds.length)
    (hR0 : R 0 = ghostR ds)
    (hsteps : ∀ i (h : i < ds.length),
      R (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * R i + D)
    (i : ℕ) (hi : i < ds.length)
    (hvi : 0 < ds.get ⟨i, hi⟩) :
    (2 : ℤ) ^ ds.get ⟨i, hi⟩ ∣ (3 * R i + D)
    ∧ ¬ (2 : ℤ) ^ (ds.get ⟨i, hi⟩ + 1) ∣ (3 * R i + D) := by
  have hodd_next := orbit_all_odd ds hne hvalid R D hD hR0 hsteps (i + 1) (by omega)
  exact case_a_step (R i) (R (i + 1)) D (ds.get ⟨i, hi⟩)
    (by linarith [hsteps i hi]) hodd_next hvi

end GhostCycles
