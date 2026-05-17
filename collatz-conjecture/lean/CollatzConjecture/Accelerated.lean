/-
  Accelerated odd-map scaffold.

  The accelerated map divides out powers of two from `3n + 1` using explicit
  fuel. This keeps the definition total on `Nat` without proving termination of
  repeated division up front.
-/

import CollatzConjecture.Basic

/-! ## Removing factors of two -/

/-- Repeatedly divide by two while fuel remains and the value is even.

The result is a pair `(m, k)` where `m` is the remaining value and `k` is the
number of halving steps that were actually performed. -/
def stripTwosTrace : Nat → Nat → Nat × Nat
  | 0, n => (n, 0)
  | fuel + 1, n =>
      if n % 2 = 0 then
        let p := stripTwosTrace fuel (n / 2)
        (p.1, p.2 + 1)
      else
        (n, 0)

/-- The odd part of `n`, computed with `n` units of fuel. -/
def oddPartWithSteps (n : Nat) : Nat × Nat :=
  stripTwosTrace n n

/-- The odd part of `n`, computed with `n` units of fuel. -/
def oddPart (n : Nat) : Nat :=
  (oddPartWithSteps n).1

/-- The number of halving steps used to compute the odd part of `n`. -/
def oddPartSteps (n : Nat) : Nat :=
  (oddPartWithSteps n).2

/-- The accelerated Collatz map on odd inputs: `n ↦ oddPart (3n + 1)`.

The definition is total on all naturals; the intended conjectural formulation
restricts the input to positive odd `n`. -/
def acceleratedOddStep (n : Nat) : Nat :=
  oddPart (3 * n + 1)

/-- Finite iteration of the accelerated odd map. -/
def acceleratedOddIter : Nat → Nat → Nat
  | 0, n => n
  | k + 1, n => acceleratedOddStep (acceleratedOddIter k n)

@[simp] theorem acceleratedOddIter_zero (n : Nat) :
    acceleratedOddIter 0 n = n := rfl

@[simp] theorem acceleratedOddIter_succ (k n : Nat) :
    acceleratedOddIter (k + 1) n =
      acceleratedOddStep (acceleratedOddIter k n) := rfl

/-- Composition law for finite accelerated iteration. -/
theorem acceleratedOddIter_add (a b n : Nat) :
    acceleratedOddIter (a + b) n = acceleratedOddIter b (acceleratedOddIter a n) := by
  induction b with
  | zero => rfl
  | succ b ih =>
      calc
        acceleratedOddIter (a + (b + 1)) n =
            acceleratedOddIter ((a + b) + 1) n := by
              rw [Nat.add_assoc]
        _ = acceleratedOddStep (acceleratedOddIter (a + b) n) := by
              rw [acceleratedOddIter_succ]
        _ = acceleratedOddStep (acceleratedOddIter b (acceleratedOddIter a n)) := by
              rw [ih]
        _ = acceleratedOddIter (b + 1) (acceleratedOddIter a n) := by
              exact (acceleratedOddIter_succ b (acceleratedOddIter a n)).symm

/-- `n` reaches `1` under accelerated odd-map iteration. -/
def AcceleratedOddReachesOne (n : Nat) : Prop :=
  ∃ k : Nat, acceleratedOddIter k n = 1

/-- The accelerated odd-map formulation, restricted to positive odd inputs. -/
def AcceleratedOddConjecture : Prop :=
  ∀ n : Nat, 0 < n → n % 2 = 1 → AcceleratedOddReachesOne n

/-! ## Numeric sanity checks -/

theorem oddPart_one : oddPart 1 = 1 := rfl

theorem oddPart_four : oddPart 4 = 1 := rfl

theorem acceleratedOddStep_one : acceleratedOddStep 1 = 1 := rfl

theorem acceleratedOddStep_three : acceleratedOddStep 3 = 5 := rfl

theorem acceleratedOdd_reaches_one_one : AcceleratedOddReachesOne 1 := by
  exact ⟨0, rfl⟩

theorem stripTwosTrace_sound : ∀ fuel n : Nat,
    collatzIter (stripTwosTrace fuel n).2 n = (stripTwosTrace fuel n).1 := by
  intro fuel
  induction fuel with
  | zero =>
      intro n
      rfl
  | succ fuel ih =>
      intro n
      by_cases hEven : n % 2 = 0
      · dsimp [stripTwosTrace]
        rw [if_pos hEven]
        dsimp
        have hRec := ih (n / 2)
        calc
          collatzIter ((stripTwosTrace fuel (n / 2)).2 + 1) n =
              collatzIter (stripTwosTrace fuel (n / 2)).2 (collatzIter 1 n) := by
                simpa [Nat.add_comm] using (collatzIter_add 1 (stripTwosTrace fuel (n / 2)).2 n)
          _ = collatzIter (stripTwosTrace fuel (n / 2)).2 (n / 2) := by
                simp [collatzIter, collatzStep, hEven]
          _ = (stripTwosTrace fuel (n / 2)).1 := by
                simpa using hRec
      · dsimp [stripTwosTrace]
        rw [if_neg hEven]
        rfl

/-- Once the fuel is at least the input, and the input is positive,
`stripTwosTrace` is independent of the exact fuel value. -/
theorem stripTwosTrace_stable : ∀ fuel n : Nat, 0 < n → n ≤ fuel →
    stripTwosTrace fuel n = stripTwosTrace n n := by
  intro fuel n hpos hle
  induction n using Nat.strongRecOn generalizing fuel with
  | ind n ih =>
      cases n with
      | zero =>
          cases hpos
      | succ n =>
          cases fuel with
          | zero =>
              cases hle
          | succ fuel =>
              by_cases hEven : Nat.succ n % 2 = 0
              · have hltFuel : Nat.succ n / 2 < Nat.succ fuel := by
                  exact Nat.lt_of_lt_of_le
                    (Nat.div_lt_self (Nat.succ_pos n) (by decide))
                    hle
                have hleFuel : Nat.succ n / 2 ≤ fuel := Nat.le_of_lt_succ hltFuel
                have hltSelf : Nat.succ n / 2 < Nat.succ n := by
                  exact Nat.div_lt_self (Nat.succ_pos n) (by decide)
                have hleSelf : Nat.succ n / 2 ≤ n := Nat.le_of_lt_succ hltSelf
                have hrecFuel : stripTwosTrace fuel (Nat.succ n / 2) =
                    stripTwosTrace (Nat.succ n / 2) (Nat.succ n / 2) := by
                  exact ih (Nat.succ n / 2) hltSelf fuel
                    (Nat.div_pos (Nat.le_of_dvd (Nat.succ_pos n)
                      (Nat.dvd_of_mod_eq_zero hEven)) (by decide))
                    hleFuel
                have hrecSelf : stripTwosTrace n (Nat.succ n / 2) =
                    stripTwosTrace (Nat.succ n / 2) (Nat.succ n / 2) := by
                  exact ih (Nat.succ n / 2) hltSelf n
                    (Nat.div_pos (Nat.le_of_dvd (Nat.succ_pos n)
                      (Nat.dvd_of_mod_eq_zero hEven)) (by decide))
                    hleSelf
                calc
                  stripTwosTrace (Nat.succ fuel) (Nat.succ n) =
                      ((stripTwosTrace fuel (Nat.succ n / 2)).1,
                        (stripTwosTrace fuel (Nat.succ n / 2)).2 + 1) := by
                          simp [stripTwosTrace, hEven]
                  _ = ((stripTwosTrace (Nat.succ n / 2) (Nat.succ n / 2)).1,
                        (stripTwosTrace (Nat.succ n / 2) (Nat.succ n / 2)).2 + 1) := by
                          rw [hrecFuel]
                  _ = stripTwosTrace (Nat.succ n) (Nat.succ n) := by
                          simp [stripTwosTrace, hEven, hrecSelf]
              · simp [stripTwosTrace, hEven]

/-- Odd inputs do not need any halving steps. -/
theorem oddPartSteps_odd_eq_zero (n : Nat) (hodd : n % 2 = 1) :
    oddPartSteps n = 0 := by
  cases n with
  | zero =>
      simp at hodd
  | succ n =>
      simp [oddPartSteps, oddPartWithSteps, stripTwosTrace, hodd]

/-- Positive even inputs take exactly one more halving step than their half. -/
theorem oddPartSteps_even_succ (n : Nat) (hpos : 0 < n) (hEven : n % 2 = 0) :
    oddPartSteps n = oddPartSteps (n / 2) + 1 := by
  rcases Nat.exists_eq_add_one.mpr hpos with ⟨m, rfl⟩
  have h2le : 2 ≤ m + 1 := Nat.le_of_dvd hpos (Nat.dvd_of_mod_eq_zero hEven)
  have hhalfpos : 0 < (m + 1) / 2 := Nat.div_pos h2le (by decide)
  have hhalfle : (m + 1) / 2 ≤ m := by
    exact Nat.le_of_lt_succ (Nat.div_lt_self (Nat.succ_pos m) (by decide))
  have hstable : stripTwosTrace m ((m + 1) / 2) =
      stripTwosTrace ((m + 1) / 2) ((m + 1) / 2) :=
    stripTwosTrace_stable m ((m + 1) / 2) hhalfpos hhalfle
  calc
    oddPartSteps (m + 1) =
        (stripTwosTrace m ((m + 1) / 2)).2 + 1 := by
          simp [oddPartSteps, oddPartWithSteps, stripTwosTrace, hEven]
    _ = oddPartSteps ((m + 1) / 2) + 1 := by
          rw [hstable]
          rfl

/-- Doubling a positive input adds exactly one halving step before the odd part is reached. -/
theorem oddPartSteps_two_mul (n : Nat) (hpos : 0 < n) :
    oddPartSteps (2 * n) = oddPartSteps n + 1 := by
  have hEven : (2 * n) % 2 = 0 := Nat.mod_eq_zero_of_dvd ⟨n, rfl⟩
  have hpos2 : 0 < 2 * n := Nat.mul_pos (by decide) hpos
  have hstep := oddPartSteps_even_succ (2 * n) hpos2 hEven
  have hdiv : (2 * n) / 2 = n := Nat.mul_div_right n (by decide)
  rw [hdiv] at hstep
  exact hstep

/-- Before the odd part is reached, the classical orbit cannot already be `1`. -/
theorem collatzIter_ne_one_before_oddPart : ∀ s n : Nat,
    0 < n → s < oddPartSteps n → collatzIter s n ≠ 1 := by
  intro s
  induction s with
  | zero =>
      intro n hpos hlt
      by_cases hodd : n % 2 = 1
      · have h0 : oddPartSteps n = 0 := oddPartSteps_odd_eq_zero n hodd
        omega
      · have hEven : n % 2 = 0 := by
          cases Nat.mod_two_eq_zero_or_one n with
          | inl hz => exact hz
          | inr ho => exact False.elim (hodd ho)
        have hne1 : n ≠ 1 := by
          intro h1
          simp [h1] at hEven
        simp [collatzIter, hne1]
  | succ s ih =>
      intro n hpos hlt
      by_cases hodd : n % 2 = 1
      · have h0 : oddPartSteps n = 0 := oddPartSteps_odd_eq_zero n hodd
        omega
      · have hEven : n % 2 = 0 := by
          cases Nat.mod_two_eq_zero_or_one n with
          | inl hz => exact hz
          | inr ho => exact False.elim (hodd ho)
        have hpos2 : 0 < n / 2 := by
          have h2le : 2 ≤ n := Nat.le_of_dvd hpos (Nat.dvd_of_mod_eq_zero hEven)
          exact Nat.div_pos h2le (by decide)
        have hrec : s < oddPartSteps (n / 2) := by
          have hsucc : s + 1 < oddPartSteps (n / 2) + 1 := by
            have hstep : s + 1 < oddPartSteps n := hlt
            rw [oddPartSteps_even_succ n hpos hEven] at hstep
            exact hstep
          exact Nat.lt_of_succ_lt_succ hsucc
        have hne : collatzIter s (n / 2) ≠ 1 := ih (n / 2) hpos2 hrec
        intro h1
        have hcalc : collatzIter (s + 1) n = collatzIter s (n / 2) := by
          simpa [Nat.add_comm, collatzStep, hEven] using
            (collatzIter_add 1 s n)
        have h1' : collatzIter s (n / 2) = 1 := by
          rw [hcalc] at h1
          exact h1
        exact hne h1'

theorem acceleratedOddStep_as_collatzIter (n : Nat) (hodd : n % 2 = 1) :
    ∃ k : Nat, collatzIter k n = acceleratedOddStep n := by
  refine ⟨oddPartSteps (3 * n + 1) + 1, ?_⟩
  calc
    collatzIter (oddPartSteps (3 * n + 1) + 1) n =
        collatzIter (oddPartSteps (3 * n + 1)) (collatzIter 1 n) := by
          simpa [Nat.add_comm] using
            (collatzIter_add 1 (oddPartSteps (3 * n + 1)) n)
    _ = collatzIter (oddPartSteps (3 * n + 1)) (3 * n + 1) := by
          simp [collatzIter, collatzStep, hodd]
    _ = acceleratedOddStep n := by
          simpa [oddPartSteps, oddPart, oddPartWithSteps, acceleratedOddStep] using
            (stripTwosTrace_sound (3 * n + 1) (3 * n + 1))

/-- If the trace fuel is at least the input and the input is positive, the
trace result is odd. -/
theorem stripTwosTrace_odd_of_pos_le : ∀ fuel n : Nat,
    0 < n → n ≤ fuel → (stripTwosTrace fuel n).1 % 2 = 1 := by
  intro fuel
  induction fuel with
  | zero =>
      intro n hpos hle
      have hn0 : n = 0 := Nat.le_zero.mp hle
      exact False.elim ((Nat.ne_of_gt hpos) hn0)
  | succ fuel ih =>
      intro n hpos hle
      cases n with
      | zero =>
          exact False.elim ((Nat.ne_of_gt hpos) rfl)
      | succ n =>
          by_cases hEven : Nat.succ n % 2 = 0
          · dsimp [stripTwosTrace]
            rw [if_pos hEven]
            have h2dvd : 2 ∣ Nat.succ n := Nat.dvd_of_mod_eq_zero hEven
            have h2le : 2 ≤ Nat.succ n := Nat.le_of_dvd (Nat.succ_pos _) h2dvd
            have hdivpos : 0 < Nat.succ n / 2 := Nat.div_pos h2le (by decide)
            have hlt : Nat.succ n / 2 < fuel + 1 := by
              exact Nat.lt_of_lt_of_le
                (Nat.div_lt_self (Nat.succ_pos n) (by decide))
                hle
            have hle' : Nat.succ n / 2 ≤ fuel := Nat.le_of_lt_add_one hlt
            have hRec := ih (Nat.succ n / 2) hdivpos hle'
            simpa [stripTwosTrace] using hRec
          · have hOdd : Nat.succ n % 2 = 1 := by
              cases Nat.mod_two_eq_zero_or_one (Nat.succ n) with
              | inl hz => exact False.elim (hEven hz)
              | inr ho => exact ho
            dsimp [stripTwosTrace]
            rw [if_neg hEven]
            exact hOdd

/-- Positive inputs always have odd odd-part. -/
theorem oddPart_pos_odd (n : Nat) (h : 0 < n) : oddPart n % 2 = 1 := by
  simpa [oddPart, oddPartWithSteps] using
    stripTwosTrace_odd_of_pos_le n n h (Nat.le_refl n)

/-- Odd inputs are already their own odd part. -/
theorem oddPart_eq_of_odd (n : Nat) (hodd : n % 2 = 1) : oddPart n = n := by
  cases n with
  | zero =>
      simp at hodd
  | succ n =>
      simp [oddPart, oddPartWithSteps, stripTwosTrace, hodd]

/-- Doubling does not change the odd part. -/
theorem oddPart_two_mul (n : Nat) : oddPart (2 * n) = oddPart n := by
  cases n with
  | zero =>
      rfl
  | succ n =>
      have hpos : 0 < Nat.succ n := Nat.succ_pos _
      have hsteps : oddPartSteps (2 * Nat.succ n) = oddPartSteps (Nat.succ n) + 1 :=
        oddPartSteps_two_mul (Nat.succ n) hpos
      have hEven : (2 * Nat.succ n) % 2 = 0 := Nat.mod_eq_zero_of_dvd ⟨Nat.succ n, rfl⟩
      have hdiv : (2 * Nat.succ n) / 2 = Nat.succ n := Nat.mul_div_right (Nat.succ n) (by decide)
      calc
        oddPart (2 * Nat.succ n) = collatzIter (oddPartSteps (2 * Nat.succ n)) (2 * Nat.succ n) := by
          change (stripTwosTrace (2 * Nat.succ n) (2 * Nat.succ n)).1 =
            collatzIter (stripTwosTrace (2 * Nat.succ n) (2 * Nat.succ n)).2 (2 * Nat.succ n)
          exact (stripTwosTrace_sound (2 * Nat.succ n) (2 * Nat.succ n)).symm
        _ = collatzIter (oddPartSteps (Nat.succ n) + 1) (2 * Nat.succ n) := by rw [hsteps]
        _ = collatzIter (oddPartSteps (Nat.succ n)) (collatzIter 1 (2 * Nat.succ n)) := by
          simpa [Nat.add_comm] using
            (collatzIter_add 1 (oddPartSteps (Nat.succ n)) (2 * Nat.succ n))
        _ = collatzIter (oddPartSteps (Nat.succ n)) (Nat.succ n) := by
          simp [collatzIter, collatzStep, hEven, hdiv]
        _ = oddPart (Nat.succ n) := by
          change collatzIter (stripTwosTrace (Nat.succ n) (Nat.succ n)).2 (Nat.succ n) =
            (stripTwosTrace (Nat.succ n) (Nat.succ n)).1
          exact stripTwosTrace_sound (Nat.succ n) (Nat.succ n)

/-- Repeated doubling does not change the odd part. -/
theorem oddPart_pow_two_mul (k n : Nat) :
    oddPart (2 ^ k * n) = oddPart n := by
  induction k with
  | zero =>
      simp
  | succ k ih =>
      have hpow : 2 ^ (k + 1) * n = 2 * (2 ^ k * n) := by
        simp [Nat.pow_succ, Nat.mul_left_comm, Nat.mul_comm]
      calc
        oddPart (2 ^ (k + 1) * n) = oddPart (2 * (2 ^ k * n)) := by
          rw [hpow]
        _ = oddPart (2 ^ k * n) := oddPart_two_mul (2 ^ k * n)
        _ = oddPart n := ih

/-- Every positive natural factors as a power of two times its odd part. -/
theorem oddPart_factorization : ∀ n : Nat, 0 < n →
    n = 2 ^ oddPartSteps n * oddPart n := by
  intro n
  induction n using Nat.strongRecOn with
  | ind n ih =>
      intro hpos
      by_cases hodd : n % 2 = 1
      · have hsteps : oddPartSteps n = 0 := oddPartSteps_odd_eq_zero n hodd
        have hOdd : oddPart n = n := oddPart_eq_of_odd n hodd
        simp [hsteps, hOdd]
      · have hEven : n % 2 = 0 := by
          cases Nat.mod_two_eq_zero_or_one n with
          | inl hz => exact hz
          | inr ho => exact False.elim (hodd ho)
        have hpos2 : 0 < n / 2 := by
          have h2le : 2 ≤ n := Nat.le_of_dvd hpos (Nat.dvd_of_mod_eq_zero hEven)
          exact Nat.div_pos h2le (by decide)
        have hlt : n / 2 < n := Nat.div_lt_self hpos (by decide)
        have hrec := ih (n / 2) hlt hpos2
        have hmul : n = 2 * (n / 2) := by
          exact
            (Nat.div_eq_iff_eq_mul_right (by decide)
              (Nat.dvd_of_mod_eq_zero hEven)).mp rfl
        have hsteps : oddPartSteps n = oddPartSteps (n / 2) + 1 :=
          oddPartSteps_even_succ n hpos hEven
        have hOdd2 : oddPart (2 * (n / 2)) = oddPart (n / 2) :=
          oddPart_two_mul (n / 2)
        have hOdd : oddPart n = oddPart (n / 2) := by
          calc
            oddPart n = oddPart (2 * (n / 2)) := congrArg oddPart hmul
            _ = oddPart (n / 2) := hOdd2
        have hpow :
            2 * (2 ^ oddPartSteps (n / 2) * oddPart (n / 2)) =
              2 ^ (oddPartSteps (n / 2) + 1) * oddPart (n / 2) := by
          calc
            2 * (2 ^ oddPartSteps (n / 2) * oddPart (n / 2)) =
                (2 * 2 ^ oddPartSteps (n / 2)) * oddPart (n / 2) := by
                  rw [Nat.mul_assoc]
            _ = (2 ^ oddPartSteps (n / 2) * 2) * oddPart (n / 2) := by
                  rw [Nat.mul_comm 2]
            _ = 2 ^ (oddPartSteps (n / 2) + 1) * oddPart (n / 2) := by
                  simp [Nat.pow_succ, Nat.mul_left_comm, Nat.mul_comm]
        calc
          n = 2 * (n / 2) := hmul
          _ = 2 * (2 ^ oddPartSteps (n / 2) * oddPart (n / 2)) := by
                exact congrArg (fun x => 2 * x) hrec
          _ = 2 ^ (oddPartSteps (n / 2) + 1) * oddPart (n / 2) := hpow
          _ = 2 ^ oddPartSteps n * oddPart n := by rw [hsteps, hOdd]

/-- The next power of two after the odd-part exponent does not divide a positive input. -/
theorem oddPartSteps_pow_two_not_dvd (n : Nat) (hpos : 0 < n) :
    ¬ 2 ^ (oddPartSteps n + 1) ∣ n := by
  intro hdiv
  rcases hdiv with ⟨m, hm⟩
  have hfac : n = 2 ^ oddPartSteps n * oddPart n := oddPart_factorization n hpos
  have hEqn : 2 ^ oddPartSteps n * oddPart n = 2 ^ oddPartSteps n * (2 * m) := by
    calc
      2 ^ oddPartSteps n * oddPart n = n := hfac.symm
      _ = 2 ^ (oddPartSteps n + 1) * m := hm
      _ = 2 ^ oddPartSteps n * (2 * m) := by
            rw [Nat.pow_succ, Nat.mul_assoc]
  have hpowpos : 0 < 2 ^ oddPartSteps n := Nat.pow_pos (by decide)
  have hEq : 2 ^ oddPartSteps n * oddPart n = 2 ^ oddPartSteps n * (2 * m) := by
    exact hEqn
  have hOddEq : oddPart n = 2 * m := Nat.mul_left_cancel hpowpos hEq
  have hdivOdd : 2 ∣ oddPart n := ⟨m, hOddEq⟩
  have hmod0 : oddPart n % 2 = 0 := Nat.mod_eq_zero_of_dvd hdivOdd
  have hmod1 : oddPart n % 2 = 1 := oddPart_pos_odd n hpos
  have h01 : (0 : Nat) = 1 := by
    rw [hmod0] at hmod1
    exact hmod1
  exact Nat.zero_ne_one h01

/-- A power of two divides a positive input iff its exponent is at most the odd-part exponent. -/
theorem oddPartSteps_pow_two_dvd_iff (n : Nat) (hpos : 0 < n) (k : Nat) :
    2 ^ k ∣ n ↔ k ≤ oddPartSteps n := by
  constructor
  · intro hdiv
    apply Nat.le_of_not_gt
    intro hgt
    have hdiv' : 2 ^ (oddPartSteps n + 1) ∣ n := by
      have hpow : 2 ^ (oddPartSteps n + 1) ∣ 2 ^ k := Nat.pow_dvd_pow 2 (Nat.succ_le_of_lt hgt)
      exact Nat.dvd_trans hpow hdiv
    exact oddPartSteps_pow_two_not_dvd n hpos hdiv'
  · intro hle
    have hpow : 2 ^ k ∣ 2 ^ oddPartSteps n := Nat.pow_dvd_pow 2 hle
    have hdiv : 2 ^ oddPartSteps n ∣ n := by
      exact ⟨oddPart n, oddPart_factorization n hpos⟩
    exact Nat.dvd_trans hpow hdiv

/-- A positive starting value reaches `1` iff its odd part does. -/
theorem CollatzReachesOne_iff_oddPart (n : Nat) (hpos : 0 < n) :
    CollatzReachesOne n ↔ CollatzReachesOne (oddPart n) := by
  constructor
  · intro hReach
    rcases hReach with ⟨k, hk⟩
    have hle : oddPartSteps n ≤ k := by
      apply Nat.le_of_not_gt
      intro hlt
      exact collatzIter_ne_one_before_oddPart k n hpos hlt hk
    refine ⟨k - oddPartSteps n, ?_⟩
    have hnorm : collatzIter (oddPartSteps n) n = oddPart n := by
      simpa [oddPart, oddPartWithSteps, oddPartSteps] using
        (stripTwosTrace_sound n n)
    have hEq : oddPartSteps n + (k - oddPartSteps n) = k :=
      Nat.add_sub_of_le hle
    calc
      collatzIter (k - oddPartSteps n) (oddPart n) =
          collatzIter (k - oddPartSteps n) (collatzIter (oddPartSteps n) n) := by
            rw [hnorm]
      _ = collatzIter (oddPartSteps n + (k - oddPartSteps n)) n := by
            exact (collatzIter_add (oddPartSteps n) (k - oddPartSteps n) n).symm
      _ = collatzIter k n := by rw [hEq]
      _ = 1 := hk
  · intro hReach
    rcases hReach with ⟨k, hk⟩
    refine ⟨oddPartSteps n + k, ?_⟩
    have hnorm : collatzIter (oddPartSteps n) n = oddPart n := by
      simpa [oddPart, oddPartWithSteps, oddPartSteps] using
        (stripTwosTrace_sound n n)
    calc
      collatzIter (oddPartSteps n + k) n =
          collatzIter k (collatzIter (oddPartSteps n) n) := by
            rw [collatzIter_add]
      _ = collatzIter k (oddPart n) := by rw [hnorm]
      _ = 1 := hk

/-- Multiplying a positive starting value by a power of two does not change whether it reaches `1`. -/
theorem CollatzReachesOne_pow_two_mul (k n : Nat) (hpos : 0 < n) :
    CollatzReachesOne (2 ^ k * n) ↔ CollatzReachesOne n := by
  have hpos' : 0 < 2 ^ k * n := Nat.mul_pos (Nat.pow_pos (by decide)) hpos
  calc
    CollatzReachesOne (2 ^ k * n) ↔ CollatzReachesOne (oddPart (2 ^ k * n)) :=
      CollatzReachesOne_iff_oddPart (2 ^ k * n) hpos'
    _ ↔ CollatzReachesOne (oddPart n) := by
          rw [oddPart_pow_two_mul]
    _ ↔ CollatzReachesOne n := (CollatzReachesOne_iff_oddPart n hpos).symm

/-- The accelerated step preserves oddness. -/
theorem acceleratedOddStep_odd (n : Nat) :
    acceleratedOddStep n % 2 = 1 := by
  have hpos : 0 < 3 * n + 1 := by
    exact Nat.succ_pos _
  simpa [acceleratedOddStep] using oddPart_pos_odd (3 * n + 1) hpos

/-- Iterating the accelerated odd map preserves oddness. -/
theorem acceleratedOddIter_odd : ∀ k n : Nat, 0 < n → n % 2 = 1 →
    acceleratedOddIter k n % 2 = 1
  | 0, _, _, hodd => hodd
  | k + 1, n, hn, hodd => by
      have hprev : acceleratedOddIter k n % 2 = 1 :=
        acceleratedOddIter_odd k n hn hodd
      have hne : acceleratedOddIter k n ≠ 0 := by
        intro h0
        rw [h0] at hprev
        cases hprev
      have hpos : 0 < acceleratedOddIter k n := Nat.pos_of_ne_zero hne
      simpa [acceleratedOddIter] using
        acceleratedOddStep_odd (acceleratedOddIter k n)

/-- Each accelerated iterate is reachable by a finite classical orbit segment. -/
theorem acceleratedOddIter_reachable : ∀ k n : Nat, 0 < n → n % 2 = 1 →
    CollatzReaches n (acceleratedOddIter k n)
  | 0, _, _, _ => ⟨0, rfl⟩
  | k + 1, n, hn, hodd => by
      have hmid : CollatzReaches n (acceleratedOddIter k n) :=
        acceleratedOddIter_reachable k n hn hodd
      have hodd' : acceleratedOddIter k n % 2 = 1 :=
        acceleratedOddIter_odd k n hn hodd
      have hstep : CollatzReaches (acceleratedOddIter k n)
          (acceleratedOddStep (acceleratedOddIter k n)) := by
        simpa [CollatzReaches] using
          acceleratedOddStep_as_collatzIter (acceleratedOddIter k n) hodd'
      have hcomp : CollatzReaches n (acceleratedOddStep (acceleratedOddIter k n)) :=
        collatzReaches_trans hmid hstep
      simpa [acceleratedOddIter] using hcomp

/-- Repeated doubling adds the corresponding number of halving steps before the odd part is reached. -/
theorem oddPartSteps_pow_two_mul (k n : Nat) (hpos : 0 < n) :
    oddPartSteps (2 ^ k * n) = oddPartSteps n + k := by
  induction k with
  | zero =>
      simp
  | succ k ih =>
      have hpow2 : 0 < 2 ^ k := Nat.pow_pos (by decide)
      have hpos' : 0 < 2 ^ k * n := Nat.mul_pos hpow2 hpos
      have hpow : 2 ^ (k + 1) * n = 2 * (2 ^ k * n) := by
        simp [Nat.pow_succ, Nat.mul_left_comm, Nat.mul_comm]
      calc
        oddPartSteps (2 ^ (k + 1) * n) = oddPartSteps (2 * (2 ^ k * n)) := by
          rw [hpow]
        _ = oddPartSteps (2 ^ k * n) + 1 := oddPartSteps_two_mul (2 ^ k * n) hpos'
        _ = (oddPartSteps n + k) + 1 := by rw [ih]
        _ = oddPartSteps n + (k + 1) := by simp [Nat.add_assoc]
