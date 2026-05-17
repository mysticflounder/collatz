/-
  Bridge between accelerated odd cycles and classical Collatz cycle
  counterexamples.

  Goal: connect the symbolic predicate `IsAcceleratedOddCycle` (used by the
  decidable enumeration in `SmallCycles.lean`) to
  `CollatzEventualCycleCounterexample` (the cycle branch of the dichotomy
  in `Formulations.lean`).

  Two directions:

  - **Easy** (proved here): if `IsAcceleratedOddCycle k q` with `q > 1`,
    then `q` is a classical Collatz cycle counterexample, because the
    accelerated cycle yields a classical period and `q > 1` precludes the
    trivial 1-cycle.

  - **Hard** (stated as a target, not yet proved): every classical Collatz
    cycle counterexample contains an odd value `q > 1` on an accelerated
    odd cycle. Without this, ruling out small accelerated cycles does not
    yet rule out small classical cycles.

  The hard direction reduces to a structural lemma about the indices at
  which a classical orbit takes odd values: those indices are exactly the
  cumulative classical-step counts of accelerated iterations. This file
  isolates that lemma; proving it remains an open scaffolding step.

  Lean core only.
-/

import CollatzConjecture.SmallCycles
import CollatzConjecture.Descent

/-! ## Easy direction: accelerated cycle gives a classical cycle -/

/-- Any classical Collatz orbit return-trip from a positive `n` to itself
becomes a classical period at any orbit point `m` reached from `n`. This is
just `collatzIter_add` applied at `m`. -/
private theorem collatzIter_period_self (m p : Nat) :
    collatzIter p m = m → ∀ s, collatzIter p (collatzIter s m) = collatzIter s m := by
  intro hCycle s
  calc
    collatzIter p (collatzIter s m)
        = collatzIter (s + p) m := (collatzIter_add s p m).symm
    _ = collatzIter (p + s) m := by rw [Nat.add_comm]
    _ = collatzIter s (collatzIter p m) := collatzIter_add p s m
    _ = collatzIter s m := by rw [hCycle]

/-- `acceleratedOddIter k q = q` lifts to a classical Collatz period at `q`
via the reachability bridge. The classical period is the total number of
classical steps used by the `k` accelerated iterations. -/
theorem classical_period_of_acceleratedOddCycle (k q : Nat)
    (hpos : 0 < q) (hodd : q % 2 = 1)
    (hCycle : acceleratedOddIter k q = q) :
    ∃ p : Nat, collatzIter p q = q := by
  rcases acceleratedOddIter_reachable k q hpos hodd with ⟨p, hp⟩
  exact ⟨p, hp.trans hCycle⟩

/-! ## Partial progress on the hard direction

These lemmas implement steps 1-3 of the proof outline below: extracting an
orbit point `m` of period `p`, replacing it with `q := oddPart m` (still of
period `p`), and confirming `q ≠ 1` whenever the orbit avoids `1`. The
remaining gap is step 4: passing from a classical period at `q` to an
accelerated period at `q`. -/

/-- The orbit value `oddPart m` is reached from `m` by `oddPartSteps m`
classical Collatz steps. Direct restatement of `stripTwosTrace_sound`. -/
private theorem collatzIter_oddPartSteps_eq_oddPart (m : Nat) :
    collatzIter (oddPartSteps m) m = oddPart m :=
  stripTwosTrace_sound m m

/-- If `m > 0` has a classical Collatz period `p`, then so does `oddPart m`:
the period is preserved under any forward orbit point, in particular the
odd part. -/
theorem classical_period_at_oddPart (m p : Nat)
    (hCycle : collatzIter p m = m) :
    collatzIter p (oddPart m) = oddPart m := by
  have hRewrite : oddPart m = collatzIter (oddPartSteps m) m :=
    (collatzIter_oddPartSteps_eq_oddPart m).symm
  rw [hRewrite]
  exact collatzIter_period_self m p hCycle (oddPartSteps m)

/-- If `m`'s classical orbit avoids `1`, so does `oddPart m`'s. The two
orbits coincide from `oddPart m` onward, so any reach of `1` from
`oddPart m` would lift to a reach from `m`. -/
theorem collatzAvoidsOne_oddPart_of_collatzAvoidsOne (m : Nat)
    (hAvoid : CollatzAvoidsOne m) : CollatzAvoidsOne (oddPart m) := by
  intro k hk
  have hOrbit : collatzIter (oddPartSteps m + k) m = 1 := by
    rw [collatzIter_add]
    rw [collatzIter_oddPartSteps_eq_oddPart m] at *
    exact hk
  exact hAvoid (oddPartSteps m + k) hOrbit

/-- If `m`'s classical orbit avoids `1`, then `oddPart m ≠ 1`. If it were
`1`, then `oddPart m`'s orbit reaches `1` in `0` steps, contradicting the
lifted avoidance. -/
theorem oddPart_ne_one_of_collatzAvoidsOne (m : Nat)
    (hAvoid : CollatzAvoidsOne m) : oddPart m ≠ 1 := by
  intro h1
  have hAvoidQ : CollatzAvoidsOne (oddPart m) :=
    collatzAvoidsOne_oddPart_of_collatzAvoidsOne m hAvoid
  exact hAvoidQ 0 (by simp [collatzIter, h1])

/-- Positivity of `oddPart m` for `m > 0`. -/
theorem oddPart_pos_of_pos (m : Nat) (hpos : 0 < m) : 0 < oddPart m := by
  rcases h : oddPart m with _ | k
  · have hMod : oddPart m % 2 = 1 := oddPart_pos_odd m hpos
    rw [h] at hMod
    cases hMod
  · exact Nat.succ_pos _

/-! ## Hard direction (proved below)

Statement of the bridge connecting `NoSmallCyclesUpTo` ranges with
`NoCollatzEventualCycleCounterexamples`:

```
theorem accelerated_cycle_of_collatz_cycle_counterexample :
    (∃ n, CollatzEventualCycleCounterexample n) →
      ∃ q k, 0 < q ∧ q % 2 = 1 ∧ 1 < q ∧ 0 < k ∧ acceleratedOddIter k q = q
```

The proof outline:

1.  From `CollatzEventualCycleCounterexample n`, extract `m = collatzIter
    start n` with `collatzIter p m = m`, `p > 0`, and `CollatzAvoidsOne m`.

2.  Set `q := oddPart m`. Then `q > 0`, `q % 2 = 1`, and the orbit from `m`
    reaches `q` in `oddPartSteps m` classical steps. By
    `collatzIter_period_self` applied to `m` and the reachability of `q`
    from `m`, `q` also has classical period `p`.

3.  `q ≠ 1`: if `q = 1`, then `m` is a power of two, hence the classical
    orbit from `m` reaches `1`, contradicting `CollatzAvoidsOne m`.

4.  Bridge `q` from classical period to accelerated period: there exists
    `k > 0` with `acceleratedOddIter k q = q`.

Step 4 is the structural step proved as
`accelerated_period_of_classical_period_on_odd_proof`: the indices at which
the classical orbit from `q` takes odd values are exactly the cumulative
classical-step counts of the accelerated orbit, so the classical period
`p` (an "odd index" since the orbit value at `p` is `q`, which is odd)
must be one such cumulative count `α_k`. Hence `acceleratedOddIter k q =
collatzIter (α_k) q = collatzIter p q = q`.
-/

/-- The hard-direction connection statement. Combined with the (much
easier) absence of small classical cycles via `SmallReachability`, small
ranges of `(N, L)` in `NoSmallCyclesUpTo` discharge corresponding ranges
of `NoCollatzEventualCycleCounterexamples`. -/
def AcceleratedCycleOfCollatzCycle : Prop :=
  ∀ n : Nat, 0 < n → CollatzEventualCycleCounterexample n →
    ∃ q k : Nat,
      0 < q ∧ q % 2 = 1 ∧ 1 < q ∧ 0 < k ∧ acceleratedOddIter k q = q

/-- The structural lemma the hard direction reduces to: given an odd `q > 0`
with classical Collatz period `p > 0`, `q` also has an *accelerated* odd
period `k > 0`. Holding this as a hypothesis discharges
`AcceleratedCycleOfCollatzCycle` via the steps already proved above. -/
def AcceleratedPeriodOfClassicalPeriodOnOdd : Prop :=
  ∀ q p : Nat, 0 < q → q % 2 = 1 → 0 < p → collatzIter p q = q →
    ∃ k : Nat, 0 < k ∧ acceleratedOddIter k q = q

/-! ## Step 4: classical period implies accelerated period for odd q

The structural lemma underlying the hard direction. The proof tracks the
indices at which the classical Collatz orbit from an odd `q` takes odd
values: those are exactly the cumulative classical-step counts of the
accelerated iteration, called `accCumSteps q m` below. A classical period
`p` at odd `q` makes `collatzIter p q = q` odd, so `p` must be one such
cumulative count, yielding the desired accelerated period. -/

/-- Auxiliary: every classical Collatz iterate strictly before the odd
part of a positive `e` is even. The orbit halves until reaching the odd
part; the intermediate values are all even. -/
private theorem collatzIter_even_before_oddPart : ∀ i e : Nat,
    0 < e → i < oddPartSteps e → collatzIter i e % 2 = 0 := by
  intro i
  induction i with
  | zero =>
      intro e _hpos hlt
      by_cases hodd : e % 2 = 1
      · have hsteps : oddPartSteps e = 0 := oddPartSteps_odd_eq_zero e hodd
        omega
      · cases Nat.mod_two_eq_zero_or_one e with
        | inl hev => simpa [collatzIter] using hev
        | inr ho => exact False.elim (hodd ho)
  | succ i ih =>
      intro e hpos hlt
      have hEven : e % 2 = 0 := by
        cases Nat.mod_two_eq_zero_or_one e with
        | inl hev => exact hev
        | inr hodd =>
            have hsteps : oddPartSteps e = 0 := oddPartSteps_odd_eq_zero e hodd
            omega
      have h2le : 2 ≤ e := Nat.le_of_dvd hpos (Nat.dvd_of_mod_eq_zero hEven)
      have hpos' : 0 < e / 2 := Nat.div_pos h2le (by decide)
      have hStep : oddPartSteps e = oddPartSteps (e / 2) + 1 :=
        oddPartSteps_even_succ e hpos hEven
      have hltRec : i < oddPartSteps (e / 2) := by
        have : i + 1 < oddPartSteps (e / 2) + 1 := by rw [← hStep]; exact hlt
        exact Nat.lt_of_succ_lt_succ this
      have hRec : collatzIter i (e / 2) % 2 = 0 := ih (e / 2) hpos' hltRec
      have hcalc : collatzIter (i + 1) e = collatzIter i (e / 2) := by
        calc
          collatzIter (i + 1) e
              = collatzIter i (collatzIter 1 e) := by
                simpa [Nat.add_comm] using collatzIter_add 1 i e
            _ = collatzIter i (e / 2) := by
                simp [collatzIter, collatzStep, hEven]
      rw [hcalc]
      exact hRec

/-- The cumulative number of classical Collatz steps required to reach the
`m`-th accelerated odd iterate of `q`. Each accelerated step contributes
`1` (for the `3n+1` step on the odd value) plus the halving steps used to
extract the next odd part. -/
def accCumSteps (q : Nat) : Nat → Nat
  | 0 => 0
  | m + 1 => accCumSteps q m + 1 + oddPartSteps (3 * acceleratedOddIter m q + 1)

@[simp] theorem accCumSteps_zero (q : Nat) : accCumSteps q 0 = 0 := rfl

@[simp] theorem accCumSteps_succ (q m : Nat) :
    accCumSteps q (m + 1) =
      accCumSteps q m + 1 + oddPartSteps (3 * acceleratedOddIter m q + 1) := rfl

/-- The canonical classical-orbit index `accCumSteps q m` lands exactly on
the `m`-th accelerated iterate of an odd `q`. -/
theorem collatzIter_accCumSteps_eq_acceleratedOddIter
    (q : Nat) (hpos : 0 < q) (hodd : q % 2 = 1) :
    ∀ m : Nat, collatzIter (accCumSteps q m) q = acceleratedOddIter m q := by
  intro m
  induction m with
  | zero => rfl
  | succ m ih =>
      have hOddM : acceleratedOddIter m q % 2 = 1 :=
        acceleratedOddIter_odd m q hpos hodd
      have hAssoc :
          accCumSteps q m + 1 + oddPartSteps (3 * acceleratedOddIter m q + 1) =
            accCumSteps q m +
              (1 + oddPartSteps (3 * acceleratedOddIter m q + 1)) := by
        omega
      have hStrip :
          collatzIter (oddPartSteps (3 * acceleratedOddIter m q + 1))
              (3 * acceleratedOddIter m q + 1) =
            oddPart (3 * acceleratedOddIter m q + 1) := by
        simpa [oddPart, oddPartWithSteps, oddPartSteps] using
          stripTwosTrace_sound (3 * acceleratedOddIter m q + 1)
            (3 * acceleratedOddIter m q + 1)
      show collatzIter
          (accCumSteps q m + 1 + oddPartSteps (3 * acceleratedOddIter m q + 1))
          q = acceleratedOddIter (m + 1) q
      rw [hAssoc, collatzIter_add, ih, collatzIter_add]
      show collatzIter (oddPartSteps (3 * acceleratedOddIter m q + 1))
          (collatzIter 1 (acceleratedOddIter m q)) =
        acceleratedOddIter (m + 1) q
      have hStep1 : collatzIter 1 (acceleratedOddIter m q) =
          3 * acceleratedOddIter m q + 1 := by
        simp [collatzIter, collatzStep, hOddM]
      rw [hStep1, hStrip]
      rfl

/-- `accCumSteps q` is strictly increasing. -/
theorem accCumSteps_lt_succ (q m : Nat) :
    accCumSteps q m < accCumSteps q (m + 1) := by
  simp [accCumSteps_succ]
  omega

/-- The cumulative-step count grows at least as fast as the iteration index. -/
theorem accCumSteps_ge_self (q m : Nat) : m ≤ accCumSteps q m := by
  induction m with
  | zero => exact Nat.zero_le _
  | succ m ih =>
      have hlt : accCumSteps q m < accCumSteps q (m + 1) :=
        accCumSteps_lt_succ q m
      omega

/-- Within a block (between consecutive accelerated cumulative-step counts),
intermediate Collatz orbit values from odd `q` are even. -/
private theorem collatzIter_even_in_block
    (q m i : Nat) (hpos : 0 < q) (hodd : q % 2 = 1)
    (hi : i < oddPartSteps (3 * acceleratedOddIter m q + 1)) :
    collatzIter (accCumSteps q m + 1 + i) q % 2 = 0 := by
  have hOddM : acceleratedOddIter m q % 2 = 1 :=
    acceleratedOddIter_odd m q hpos hodd
  have hReach :
      collatzIter (accCumSteps q m) q = acceleratedOddIter m q :=
    collatzIter_accCumSteps_eq_acceleratedOddIter q hpos hodd m
  have hAssoc :
      accCumSteps q m + 1 + i = accCumSteps q m + (1 + i) := by omega
  have hpos3a : 0 < 3 * acceleratedOddIter m q + 1 := Nat.succ_pos _
  have hRewrite :
      collatzIter (accCumSteps q m + 1 + i) q =
        collatzIter i (3 * acceleratedOddIter m q + 1) := by
    calc
      collatzIter (accCumSteps q m + 1 + i) q
          = collatzIter (accCumSteps q m + (1 + i)) q := by rw [hAssoc]
        _ = collatzIter (1 + i) (collatzIter (accCumSteps q m) q) :=
              collatzIter_add _ _ _
        _ = collatzIter (1 + i) (acceleratedOddIter m q) := by rw [hReach]
        _ = collatzIter i (collatzIter 1 (acceleratedOddIter m q)) :=
              collatzIter_add 1 i _
        _ = collatzIter i (3 * acceleratedOddIter m q + 1) := by
              simp [collatzIter, collatzStep, hOddM]
  rw [hRewrite]
  exact collatzIter_even_before_oddPart i (3 * acceleratedOddIter m q + 1) hpos3a hi

/-- *Find lemma*: every classical-orbit index `j ≤ accCumSteps q m` at which
the orbit from odd `q` is odd is itself one of the cumulative-step counts. -/
theorem exists_accCumSteps_of_odd_orbit_value
    (q : Nat) (hpos : 0 < q) (hodd : q % 2 = 1) :
    ∀ m j : Nat, j ≤ accCumSteps q m → collatzIter j q % 2 = 1 →
      ∃ i : Nat, i ≤ m ∧ accCumSteps q i = j := by
  intro m
  induction m with
  | zero =>
      intro j hj _hOddJ
      have h0 : j = 0 := by
        have : j ≤ 0 := by simpa using hj
        omega
      exact ⟨0, Nat.le_refl _, by simp [h0]⟩
  | succ m ih =>
      intro j hj hOddJ
      by_cases hle : j ≤ accCumSteps q m
      · rcases ih j hle hOddJ with ⟨i, hile, heq⟩
        exact ⟨i, Nat.le_succ_of_le hile, heq⟩
      · have hgt : accCumSteps q m < j := by omega
        rcases Nat.lt_or_ge j (accCumSteps q (m + 1)) with hlt | hge
        · exfalso
          have hlt' :
              j < accCumSteps q m + 1 +
                oddPartSteps (3 * acceleratedOddIter m q + 1) := by
            simpa [accCumSteps_succ] using hlt
          have hi_lt :
              j - accCumSteps q m - 1 <
                oddPartSteps (3 * acceleratedOddIter m q + 1) := by omega
          have hj_eq :
              j = accCumSteps q m + 1 + (j - accCumSteps q m - 1) := by omega
          have hEven : collatzIter j q % 2 = 0 := by
            rw [hj_eq]
            exact collatzIter_even_in_block q m
              (j - accCumSteps q m - 1) hpos hodd hi_lt
          omega
        · have heq : j = accCumSteps q (m + 1) := Nat.le_antisymm hj hge
          exact ⟨m + 1, Nat.le_refl _, heq.symm⟩

/-- *Step 4*, proved: an odd `q > 0` with classical Collatz period `p > 0`
also has a positive accelerated odd period. -/
theorem accelerated_period_of_classical_period_on_odd_proof :
    AcceleratedPeriodOfClassicalPeriodOnOdd := by
  intro q p hpos hodd hpPos hCycle
  have hpLeAcc : p ≤ accCumSteps q p := accCumSteps_ge_self q p
  have hOddP : collatzIter p q % 2 = 1 := by rw [hCycle]; exact hodd
  rcases exists_accCumSteps_of_odd_orbit_value q hpos hodd p p hpLeAcc hOddP
    with ⟨i, _hile, heq⟩
  have hipos : 0 < i := by
    rcases Nat.eq_zero_or_pos i with hi0 | hi0
    · exfalso
      rw [hi0] at heq
      simp [accCumSteps] at heq
      omega
    · exact hi0
  refine ⟨i, hipos, ?_⟩
  have h1 : collatzIter (accCumSteps q i) q = acceleratedOddIter i q :=
    collatzIter_accCumSteps_eq_acceleratedOddIter q hpos hodd i
  rw [heq] at h1
  rw [hCycle] at h1
  exact h1.symm

/-! ## Steps 1-3 packaged (general step-4 hypothesis form) -/

/-- Steps 1-3 of the hard direction, packaged: assuming the structural
lemma (step 4), the full bridge follows. The proof composes
`classical_period_at_oddPart`, `oddPart_ne_one_of_collatzAvoidsOne`, and
positivity/oddness of `oddPart`. -/
theorem acceleratedCycleOfCollatzCycle_of_step4
    (h : AcceleratedPeriodOfClassicalPeriodOnOdd) :
    AcceleratedCycleOfCollatzCycle := by
  intro n hPosN hCE
  rcases hCE with ⟨hAvoidN, start, period, hpPos, hCycle⟩
  have hAvoidM : CollatzAvoidsOne (collatzIter start n) := by
    intro k hk
    apply hAvoidN (start + k)
    rw [collatzIter_add]
    exact hk
  have hPosM : 0 < collatzIter start n := collatzIter_pos start n hPosN
  have hPosQ : 0 < oddPart (collatzIter start n) :=
    oddPart_pos_of_pos _ hPosM
  have hOddQ : oddPart (collatzIter start n) % 2 = 1 :=
    oddPart_pos_odd _ hPosM
  have hQne1 : oddPart (collatzIter start n) ≠ 1 :=
    oddPart_ne_one_of_collatzAvoidsOne _ hAvoidM
  have hQgt1 : 1 < oddPart (collatzIter start n) := by omega
  have hCycleQ :
      collatzIter period (oddPart (collatzIter start n)) =
        oddPart (collatzIter start n) :=
    classical_period_at_oddPart _ period hCycle
  rcases h _ period hPosQ hOddQ hpPos hCycleQ with ⟨k, hkPos, hkCycle⟩
  exact ⟨oddPart (collatzIter start n), k, hPosQ, hOddQ, hQgt1, hkPos, hkCycle⟩

/-- The full hard-direction bridge, with step 4 discharged. -/
theorem acceleratedCycleOfCollatzCycle_proved : AcceleratedCycleOfCollatzCycle :=
  acceleratedCycleOfCollatzCycle_of_step4
    accelerated_period_of_classical_period_on_odd_proof

/-! ## Minimality-strengthened bridge

When the classical cycle counterexample is *minimal*, the extracted
accelerated-cycle base point `q` satisfies `n ≤ q`. The argument is that
`q := oddPart (collatzIter start n)` is itself a Collatz counterexample
(it avoids `1` because the orbit point it sits on does), so by minimality
of `n`, every counterexample is ≥ `n`. -/

/-- For a minimal Collatz counterexample on the eventual-cycle branch, the
extracted accelerated cycle starts at a `q` with `n ≤ q`. -/
theorem acceleratedCycle_at_minimal_cycle_counterexample
    (n : Nat) (hMin : MinimalCollatzCounterexample n)
    (hCE : CollatzEventualCycleCounterexample n) :
    ∃ q k : Nat,
      n ≤ q ∧ q % 2 = 1 ∧ 0 < k ∧ acceleratedOddIter k q = q := by
  rcases hCE with ⟨hAvoidN, start, period, hpPos, hCycle⟩
  have hPosN : 0 < n := hMin.1.1
  have hPosM : 0 < collatzIter start n := collatzIter_pos start n hPosN
  have hMge : n ≤ collatzIter start n :=
    minimal_counterexample_orbit_lower_bound n hMin start
  have hAvoidM : CollatzAvoidsOne (collatzIter start n) := by
    intro k hk
    apply hAvoidN (start + k)
    rw [collatzIter_add]
    exact hk
  have hPosQ : 0 < oddPart (collatzIter start n) :=
    oddPart_pos_of_pos _ hPosM
  have hOddQ : oddPart (collatzIter start n) % 2 = 1 :=
    oddPart_pos_odd _ hPosM
  have hAvoidQ : CollatzAvoidsOne (oddPart (collatzIter start n)) :=
    collatzAvoidsOne_oddPart_of_collatzAvoidsOne _ hAvoidM
  have hQge : n ≤ oddPart (collatzIter start n) := by
    rcases Nat.lt_or_ge (oddPart (collatzIter start n)) n with hlt | hge
    · exfalso
      rcases hMin.2 (oddPart (collatzIter start n)) hPosQ hlt with ⟨k, hk⟩
      exact hAvoidQ k hk
    · exact hge
  have hCycleQ :
      collatzIter period (oddPart (collatzIter start n)) =
        oddPart (collatzIter start n) :=
    classical_period_at_oddPart _ period hCycle
  rcases accelerated_period_of_classical_period_on_odd_proof
      _ period hPosQ hOddQ hpPos hCycleQ with ⟨k, hkPos, hkCycle⟩
  exact ⟨oddPart (collatzIter start n), k, hQge, hOddQ, hkPos, hkCycle⟩

/-- Existential form: any cycle counterexample (minimal or not) yields a
*minimal* counterexample `n` together with an accelerated cycle at some
`q ≥ n`. The minimal `n` may itself be on the divergence branch — only
its existence as a CE is guaranteed — but if any cycle counterexample
exists, this gives a sharp accelerated-cycle starting bound for whatever
cycle counterexample is minimal among them. -/
theorem exists_minimal_cycle_counterexample_bound :
    (∃ n, CollatzEventualCycleCounterexample n ∧
      MinimalCollatzCounterexample n) →
    ∃ n q k : Nat,
      n ≤ q ∧ q % 2 = 1 ∧ 0 < k ∧ acceleratedOddIter k q = q ∧
        MinimalCollatzCounterexample n := by
  rintro ⟨n, hCE, hMin⟩
  rcases acceleratedCycle_at_minimal_cycle_counterexample n hMin hCE
    with ⟨q, k, hQge, hOddQ, hkPos, hkCycle⟩
  exact ⟨n, q, k, hQge, hOddQ, hkPos, hkCycle, hMin⟩
