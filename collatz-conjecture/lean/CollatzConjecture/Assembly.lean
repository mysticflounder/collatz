/-
  Final assembly: the Collatz conjecture as a parity-word problem.

  Phase 6 of the roadmap. The roadmap target

      no_positive_cycles → no_divergent_counterexamples → CollatzConjecture

  is already realised by `CollatzConjecture_of_no_cycles_and_no_divergence`
  in `Formulations.lean`. This file adds the *parity-word-flavoured*
  assembly layer: it expresses the conjecture as "no extracted
  persistently-non-descending positive odd `n`" via the counterexample
  extraction principle from `Descent.lean`, and translates that into
  parity-word language via the canonical accelerated trace.

  This file uses only Lean core.
-/

import CollatzConjecture.Descent

/-! ## Extraction-based assembly -/

/-- The Collatz conjecture is equivalent to ruling out the *extracted*
counterexample shape: a positive odd `n` whose accelerated orbit stays
weakly above `n` and which never reaches `1`.

This is the assembly route favoured by the roadmap: counterexample
existence reduces, via minimality and the counterexample extraction
principle, to the existence of an `n` whose forward accelerated orbit is
bounded below by `n` itself. -/
theorem CollatzConjecture_iff_no_extracted_counterexample :
    CollatzConjecture ↔
      ¬ ∃ n : Nat,
        0 < n ∧ n % 2 = 1 ∧ CollatzAvoidsOne n ∧
          ∀ k : Nat, n ≤ acceleratedOddIter k n := by
  rw [CollatzConjecture_iff_no_counterexamples]
  constructor
  · intro hNoCE hExt
    rcases hExt with ⟨n, hpos, _hOdd, hAvoid, _hBound⟩
    exact hNoCE n ⟨hpos, hAvoid⟩
  · intro hNoExt n hCE
    exact hNoExt (counterexample_extraction ⟨n, hCE⟩)

/-! ## Parity-word formulation -/

/-- Parity-word version of the extracted counterexample: every initial
segment of the accelerated trace from `n` is non-descending in the sense
of `BlockNonDescent`.

Admissibility is automatic via `admissible_acceleratedTrace` and is
therefore not encoded in the disjunctive hypothesis. -/
theorem CollatzConjecture_iff_no_persistent_nonDescent :
    CollatzConjecture ↔
      ¬ ∃ n : Nat,
        0 < n ∧ n % 2 = 1 ∧ CollatzAvoidsOne n ∧
          ∀ k : Nat,
            ParityWords.BlockNonDescent (ParityWords.acceleratedTrace k n) n := by
  rw [CollatzConjecture_iff_no_extracted_counterexample]
  constructor
  · intro h hExt
    rcases hExt with ⟨n, hpos, hOdd, hAvoid, hBound⟩
    apply h
    refine ⟨n, hpos, hOdd, hAvoid, ?_⟩
    intro k
    have hb := hBound k
    unfold ParityWords.BlockNonDescent at hb
    rw [ParityWords.applyWord_acceleratedTrace] at hb
    exact hb
  · intro h hExt
    rcases hExt with ⟨n, hpos, hOdd, hAvoid, hBound⟩
    apply h
    refine ⟨n, hpos, hOdd, hAvoid, ?_⟩
    intro k
    unfold ParityWords.BlockNonDescent
    rw [ParityWords.applyWord_acceleratedTrace]
    exact hBound k

/-! ## Affine non-descent formulation -/

/-- Fully affine version of the extracted counterexample formulation:
the Collatz conjecture is equivalent to ruling out a positive odd
counterexample whose every canonical accelerated trace satisfies

`AcceleratedAffineNonDescent k n`.

This is the form intended for later long-block inequality arguments. -/
theorem CollatzConjecture_iff_no_persistent_affine_nonDescent :
    CollatzConjecture ↔
      ¬ ∃ n : Nat,
        0 < n ∧ n % 2 = 1 ∧ CollatzAvoidsOne n ∧
          ∀ k : Nat, ParityWords.AcceleratedAffineNonDescent k n := by
  rw [CollatzConjecture_iff_no_persistent_nonDescent]
  constructor
  · intro h hExt
    rcases hExt with ⟨n, hpos, hOdd, hAvoid, hAffine⟩
    apply h
    refine ⟨n, hpos, hOdd, hAvoid, ?_⟩
    exact (ParityWords.persistent_nonDescent_iff_acceleratedAffine n).mpr hAffine
  · intro h hExt
    rcases hExt with ⟨n, hpos, hOdd, hAvoid, hNonDescent⟩
    apply h
    refine ⟨n, hpos, hOdd, hAvoid, ?_⟩
    exact (ParityWords.persistent_nonDescent_iff_acceleratedAffine n).mp hNonDescent

/-! ## Cycle-and-divergence assembly (re-export) -/

/-- The roadmap target: the Collatz conjecture follows from ruling out
both branches of the dichotomy at the classical level. This restates
`CollatzConjecture_of_no_cycles_and_no_divergence` from `Formulations.lean`
as the final assembly entry point. -/
theorem CollatzConjecture_from_cycle_and_divergence
    (hCycles : NoCollatzEventualCycleCounterexamples)
    (hDivergence : NoCollatzDivergentCounterexamples) :
    CollatzConjecture :=
  CollatzConjecture_of_no_cycles_and_no_divergence hCycles hDivergence

/-! ## Public entry-point summary

The reductions composed by this file are:

```
CollatzConjecture
  ↔ NoCollatzCounterexamples                                  (Formulations)
  ↔ NoCollatzEventualCycleCounterexamples ∧
      NoCollatzDivergentCounterexamples                        (Formulations)
  ↔ ¬ ∃ extracted counterexample                               (this file)
  ↔ ¬ ∃ positive odd `n` with persistent block non-descent     (this file)
  ↔ ¬ ∃ positive odd `n` with persistent affine non-descent    (this file)
```

Together with the equivalences

```
CollatzConjecture ↔ CollatzConjectureOnOdd                     (Formulations)
                  ↔ AcceleratedOddConjecture                   (Formulations)
                  ↔ ∀ n > 0, CollatzReachesOne (oddPart n)     (Formulations)
```

these form the public reduction API. The remaining proof obligation,
ruling out a persistently non-descending admissible parity-word
trajectory at a positive odd `n`, is the open problem this scaffold
isolates. -/
