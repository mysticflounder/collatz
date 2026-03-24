/-
  Ghost Cycles of the Syracuse Map
  Decomposition of ghostR over list concatenation

  Key lemma: ghostR(a ++ b) = 3^|b| · ghostR(a) + 2^{sum a} · ghostR(b)

  This is the algebraic backbone for proving all orbit numerators are odd.
-/

import GhostCycles.Syracuse.CycleEquation
import Mathlib.Tactic

namespace GhostCycles

/-- **ghostR append decomposition.**
    ghostR(a ++ b) = 3^|b| · ghostR(a) + 2^{sum a} · ghostR(b)

    Proof by induction on a:
    - Base: ghostR([] ++ b) = ghostR(b) = 3^|b| · 0 + 2^0 · ghostR(b) ✓
    - Step: ghostR((v :: as) ++ b) = 3^{|as|+|b|} + 2^v · ghostR(as ++ b)
            = 3^{|as|+|b|} + 2^v · [3^|b| · ghostR(as) + 2^{sum as} · ghostR(b)]   (IH)
            = 3^|b| · [3^|as| + 2^v · ghostR(as)] + 2^{v+sum as} · ghostR(b)
            = 3^|b| · ghostR(v :: as) + 2^{sum(v::as)} · ghostR(b)  ✓ -/
theorem ghostR_append (a b : List ℕ) :
    ghostR (a ++ b) = 3 ^ b.length * ghostR a + 2 ^ a.sum * ghostR b := by
  induction a with
  | nil => simp [ghostR]
  | cons v as ih =>
    simp only [List.cons_append, ghostR, List.length_append, List.sum_cons]
    rw [ih]
    rw [pow_add (2 : ℤ) v as.sum]
    ring

end GhostCycles
