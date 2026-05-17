/-
  Equivalent formulations and counterexample decomposition.
-/

import CollatzConjecture.StoppingTime
import CollatzConjecture.Accelerated
import CollatzConjecture.FormalConjecturesBridge

/-! ## Classical problem statement

The top-level `CollatzConjecture` is the canonical statement from
`google-deepmind/formal-conjectures`
(`FormalConjectures.Wikipedia.CollatzConjecture`), unfolded to the
universally quantified form. All internal scaffolding works in terms of
our `collatzIter` / `CollatzReachesOne` formulation; the bridge in
`FormalConjecturesBridge.lean` shows the two are equivalent. -/

/-- The classical Collatz conjecture, as stated in
`FormalConjectures.Wikipedia.CollatzConjecture.collatz_conjecture`.

Every positive natural number eventually reaches `1` under the upstream
`CollatzConjecture.collatzStep`. -/
def CollatzConjecture : Prop :=
  ∀ n : Nat, 0 < n → ∃ m : Nat, _root_.CollatzConjecture.collatzStep^[m] n = 1

/-- Classical Collatz restricted to positive odd inputs. -/
def CollatzConjectureOnOdd : Prop :=
  ∀ n : Nat, 0 < n → n % 2 = 1 → CollatzReachesOne n

/-- The top-level conjecture unfolds to the expected quantified statement
using our internal `collatzIter` form, via the bridge to
`Function.iterate` of the upstream step. -/
theorem CollatzConjecture_def :
    CollatzConjecture ↔
      ∀ n : Nat, 0 < n → ∃ k : Nat, collatzIter k n = 1 := by
  unfold CollatzConjecture
  constructor
  · intro h n hn
    exact (CollatzReachesOne_iff_formal_iterate n).mpr (h n hn)
  · intro h n hn
    exact (CollatzReachesOne_iff_formal_iterate n).mp (h n hn)

theorem CollatzConjecture_iff_on_odd :
    CollatzConjecture ↔ CollatzConjectureOnOdd := by
  constructor
  · intro h n hn _hodd
    exact CollatzConjecture_def.mp h n hn
  · intro h
    refine CollatzConjecture_def.mpr ?_
    have hmain : ∀ n : Nat, 0 < n → CollatzReachesOne n := by
      intro n
      induction n using Nat.strongRecOn with
      | ind n ih =>
          intro hn
          by_cases hodd : n % 2 = 1
          · exact h n hn hodd
          · have hEven : n % 2 = 0 := by
              cases Nat.mod_two_eq_zero_or_one n with
              | inl hz => exact hz
              | inr ho => exact False.elim (hodd ho)
            have hne1 : n ≠ 1 := by
              intro h1
              simp [h1] at hEven
            have h1ne : 1 ≠ n := by
              intro h1
              exact hne1 h1.symm
            have h2le : 2 ≤ n := by
              have h1le : 1 ≤ n := Nat.succ_le_of_lt hn
              exact Nat.succ_le_of_lt (Nat.lt_of_le_of_ne h1le h1ne)
            have hpos : 0 < n / 2 := Nat.div_pos h2le (by decide)
            have hlt : n / 2 < n := Nat.div_lt_self hn (by decide)
            have hrec := ih (n / 2) hlt hpos
            rcases hrec with ⟨k, hk⟩
            refine ⟨k + 1, ?_⟩
            calc
              collatzIter (k + 1) n = collatzIter k (collatzStep n) := by
                simpa [Nat.add_comm] using (collatzIter_add 1 k n)
              _ = collatzIter k (n / 2) := by simp [collatzStep, hEven]
              _ = 1 := hk
    intro n hn
    exact hmain n hn

theorem CollatzConjecture_iff_oddPart :
    CollatzConjecture ↔ (∀ n : Nat, 0 < n → CollatzReachesOne (oddPart n)) := by
  rw [CollatzConjecture_def]
  constructor
  · intro h n hn
    exact (CollatzReachesOne_iff_oddPart n hn).mp (h n hn)
  · intro h n hn
    exact (CollatzReachesOne_iff_oddPart n hn).mpr (h n hn)

/-- Odd representatives suffice: normalize to the odd part, and powers of two do not affect reachability. -/
theorem OddRepresentativesSuffice :
    (∀ n : Nat, 0 < n → (CollatzReachesOne n ↔ CollatzReachesOne (oddPart n))) ∧
      (∀ n : Nat, 0 < n → ∀ k : Nat, (CollatzReachesOne (2 ^ k * n) ↔ CollatzReachesOne n)) := by
  constructor
  · intro n
    intro hn
    exact CollatzReachesOne_iff_oddPart n hn
  · intro n
    intro hn
    intro k
    exact CollatzReachesOne_pow_two_mul k n hn

/-! ## Stopping-time formulation -/

/-- Every positive natural has a finite Collatz stopping time. -/
def AllPositiveStoppingTimesExist : Prop :=
  ∀ n : Nat, 0 < n → HasCollatzStoppingTime n

theorem CollatzConjecture_iff_stopping_times :
    CollatzConjecture ↔ AllPositiveStoppingTimesExist := by
  unfold AllPositiveStoppingTimesExist
  rw [CollatzConjecture_def]
  constructor
  · intro h n hn
    exact (hasCollatzStoppingTime_iff_reaches_one n).mpr (h n hn)
  · intro h n hn
    exact (hasCollatzStoppingTime_iff_reaches_one n).mp (h n hn)

/-! ## Avoidance and counterexamples -/

/-- The forward orbit of `n` never visits `1`. -/
def CollatzAvoidsOne (n : Nat) : Prop :=
  ∀ k : Nat, collatzIter k n ≠ 1

/-- A positive starting value whose orbit never reaches `1`. -/
def CollatzCounterexample (n : Nat) : Prop :=
  0 < n ∧ CollatzAvoidsOne n

/-- There are no positive Collatz counterexamples. -/
def NoCollatzCounterexamples : Prop :=
  ∀ n : Nat, ¬ CollatzCounterexample n

theorem reaches_one_iff_not_avoids_one (n : Nat) :
    CollatzReachesOne n ↔ ¬ CollatzAvoidsOne n := by
  constructor
  · intro h hAvoid
    match h with
    | ⟨k, hk⟩ => exact hAvoid k hk
  · intro h
    exact Classical.byContradiction
      (fun hReach => h (fun k hk => hReach ⟨k, hk⟩))

theorem CollatzConjecture_iff_no_counterexamples :
    CollatzConjecture ↔ NoCollatzCounterexamples := by
  rw [CollatzConjecture_def]
  constructor
  · intro h n hCounter
    exact (reaches_one_iff_not_avoids_one n).mp (h n hCounter.left) hCounter.right
  · intro h n hn
    exact (reaches_one_iff_not_avoids_one n).mpr
      (fun hAvoid => h n ⟨hn, hAvoid⟩)

/-! ## Cycle/no-divergence decomposition -/

/-- A counterexample whose orbit eventually cycles without ever reaching `1`.

The `CollatzAvoidsOne n` conjunct makes this a counterexample-cycle predicate,
not merely eventual periodicity; the usual `1 → 4 → 2 → 1` cycle is therefore
not counted as a counterexample. -/
def CollatzEventualCycleCounterexample (n : Nat) : Prop :=
  CollatzAvoidsOne n ∧
    ∃ start period : Nat,
      0 < period ∧
        collatzIter period (collatzIter start n) = collatzIter start n

/-- A counterexample whose orbit does not eventually cycle. -/
def CollatzDivergentCounterexample (n : Nat) : Prop :=
  CollatzAvoidsOne n ∧ ¬ CollatzEventualCycleCounterexample n

def NoCollatzEventualCycleCounterexamples : Prop :=
  ∀ n : Nat, 0 < n → ¬ CollatzEventualCycleCounterexample n

def NoCollatzDivergentCounterexamples : Prop :=
  ∀ n : Nat, 0 < n → ¬ CollatzDivergentCounterexample n

theorem counterexample_cycle_or_divergent (n : Nat) :
    CollatzAvoidsOne n →
      CollatzEventualCycleCounterexample n ∨
        CollatzDivergentCounterexample n := by
  intro hAvoid
  by_cases hCycle : CollatzEventualCycleCounterexample n
  · exact Or.inl hCycle
  · exact Or.inr ⟨hAvoid, hCycle⟩

theorem CollatzConjecture_of_no_cycles_and_no_divergence
    (hCycles : NoCollatzEventualCycleCounterexamples)
    (hDivergence : NoCollatzDivergentCounterexamples) :
    CollatzConjecture := by
  refine CollatzConjecture_def.mpr ?_
  intro n hn
  exact (reaches_one_iff_not_avoids_one n).mpr
    (fun hAvoid =>
      match counterexample_cycle_or_divergent n hAvoid with
      | Or.inl hCycle => hCycles n hn hCycle
      | Or.inr hDiv => hDivergence n hn hDiv)

theorem CollatzConjecture_iff_no_cycles_and_no_divergence :
    CollatzConjecture ↔
      NoCollatzEventualCycleCounterexamples ∧
        NoCollatzDivergentCounterexamples := by
  rw [CollatzConjecture_def]
  constructor
  · intro h
    constructor
    · intro n hn hCycle
      exact (reaches_one_iff_not_avoids_one n).mp (h n hn) hCycle.left
    · intro n hn hDiv
      exact (reaches_one_iff_not_avoids_one n).mp (h n hn) hDiv.left
  · intro h n hn
    exact (reaches_one_iff_not_avoids_one n).mpr
      (fun hAvoid =>
        match counterexample_cycle_or_divergent n hAvoid with
        | Or.inl hCycle => h.1 n hn hCycle
        | Or.inr hDiv => h.2 n hn hDiv)

theorem AcceleratedOddConjecture_implies_on_odd :
    AcceleratedOddConjecture → CollatzConjectureOnOdd := by
  intro h n hn hodd
  have hReach : AcceleratedOddReachesOne n := h n hn hodd
  rcases hReach with ⟨k, hk⟩
  exact collatzReaches_trans_one
    (acceleratedOddIter_reachable k n hn hodd)
    ⟨0, hk⟩

theorem CollatzConjectureOnOdd_implies_AcceleratedOddConjecture :
    CollatzConjectureOnOdd → AcceleratedOddConjecture := by
  intro h n hn hodd
  have hmain : ∀ k : Nat, ∀ n : Nat, 0 < n → n % 2 = 1 →
      collatzIter k n = 1 → AcceleratedOddReachesOne n := by
    intro k
    induction k using Nat.strongRecOn with
    | ind k ih =>
        intro n hn hodd hk
        cases k with
        | zero =>
            exact ⟨0, by simpa using hk⟩
        | succ k =>
            have hkStep : collatzIter k (3 * n + 1) = 1 := by
              calc
                collatzIter k (3 * n + 1) = collatzIter k (collatzStep n) := by
                  simp [collatzStep, hodd]
                _ = collatzIter (k + 1) n := by
                  simpa [Nat.add_comm] using (collatzIter_add 1 k n).symm
                _ = 1 := hk
            let t := oddPartSteps (3 * n + 1)
            have hleStep : t ≤ k := by
              apply Nat.le_of_not_gt
              intro hlt
              exact collatzIter_ne_one_before_oddPart k (3 * n + 1) (Nat.succ_pos _) hlt hkStep
            have hleT : t + 1 ≤ k + 1 := Nat.succ_le_succ hleStep
            have hTailW : collatzIter (k - t) (acceleratedOddStep n) = 1 := by
              have hAccelStep : collatzIter (t + 1) n = acceleratedOddStep n := by
                calc
                  collatzIter (t + 1) n = collatzIter t (collatzStep n) := by
                    simpa [t, Nat.add_comm, collatzStep, hodd] using (collatzIter_add 1 t n)
                  _ = collatzIter t (3 * n + 1) := by
                    simp [collatzStep, hodd]
                  _ = acceleratedOddStep n := by
                    simpa [t, oddPartSteps, oddPart, oddPartWithSteps, acceleratedOddStep] using
                      (stripTwosTrace_sound (3 * n + 1) (3 * n + 1))
              have hEq : t + (k - t) = k := Nat.add_sub_of_le hleStep
              have hEq' : t + 1 + (k - t) = k + 1 := by
                simp [Nat.add_comm, Nat.add_assoc, hEq]
              calc
                collatzIter (k - t) (acceleratedOddStep n) =
                    collatzIter (k - t) (collatzIter (t + 1) n) := by
                      rw [hAccelStep]
                _ = collatzIter ((t + 1) + (k - t)) n := by
                      simpa [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc] using
                        ((collatzIter_add (t + 1) (k - t) n).symm)
                _ = collatzIter (k + 1) n := by rw [hEq']
                _ = 1 := hk
            have hTail : CollatzReachesOne (acceleratedOddStep n) :=
              ⟨k - t, hTailW⟩
            have hTailLt : k - t < k + 1 := by
              have hsub : (k + 1) - (t + 1) < k + 1 := by
                exact Nat.sub_lt_self (Nat.succ_pos _) hleT
              simpa [Nat.succ_sub_succ] using hsub
            have hposStep : 0 < acceleratedOddStep n := by
              have hoddStep : acceleratedOddStep n % 2 = 1 := acceleratedOddStep_odd n
              have hne0 : acceleratedOddStep n ≠ 0 := by
                intro h0
                rw [h0] at hoddStep
                cases hoddStep
              exact Nat.pos_of_ne_zero hne0
            have hAccelReach : AcceleratedOddReachesOne (acceleratedOddStep n) := by
              exact ih (k - t) hTailLt (acceleratedOddStep n) hposStep
                (acceleratedOddStep_odd n) hTailW
            rcases hAccelReach with ⟨r, hr⟩
            refine ⟨r + 1, ?_⟩
            calc
              acceleratedOddIter (r + 1) n = acceleratedOddIter r (acceleratedOddStep n) := by
                simpa [Nat.add_comm] using (acceleratedOddIter_add 1 r n)
              _ = 1 := hr
  have hReach : CollatzReachesOne n := h n hn hodd
  rcases hReach with ⟨k, hk⟩
  exact hmain k n hn hodd hk

theorem CollatzConjectureOnOdd_iff_AcceleratedOddConjecture :
    CollatzConjectureOnOdd ↔ AcceleratedOddConjecture := by
  constructor
  · exact CollatzConjectureOnOdd_implies_AcceleratedOddConjecture
  · exact AcceleratedOddConjecture_implies_on_odd
