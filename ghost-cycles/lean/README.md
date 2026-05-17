# Ghost Cycles — Lean 4 Formalization

Machine-verified proofs for "Ghost Cycles of the Syracuse Map: 2-Adic Periodic Orbits and the Exceptional Set" (McKenna, 2026).

**Zero sorry blocks. Zero axioms. Fully verified against Lean 4.28.0 + Mathlib.**

## Quick start

```bash
# Install Lean (if needed)
curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh

# Build and verify
cd lean
lake build
```

If `lake build` succeeds with no errors, every theorem is machine-verified.

## Theorem map

| Paper theorem | Lean file | Lean name | Status |
|--------------|-----------|-----------|--------|
| **Theorem 4** (Cycle equation) | `Syracuse/CycleEquation.lean` | `cycle_equation` | Proved (exact identity, stronger than paper's congruence) |
| **Theorem 7** (Orbit formula) | `Syracuse/OrbitFormula.lean` | `orbit_numerator_iteration` | Proved (iteration form) |
| **Theorem 8** (Negative rationality) | `Syracuse/GeneralOrbit.lean` | `negative_rationality_general` | Proved |
| **Theorem 9** (Universal Case-a) | `Syracuse/GeneralOrbit.lean` | `universal_case_a_general` | Proved |

### Supporting results

| Result | Lean file | Lean name |
|--------|-----------|-----------|
| Syracuse map definition | `Syracuse/SyracuseMap.lean` | `syracuse` |
| S(n) step relation | `Syracuse/SyracuseMap.lean` | `syracuse_step_relation` |
| Syracuse sends odd to odd | `Syracuse/SyracuseMap.lean` | `syracuse_odd` |
| v₂(3n+1) ≥ 1 for odd n | `Syracuse/SyracuseMap.lean` | `val2_three_mul_odd_pos` |
| D = 2^V - 3^L is odd | `Syracuse/Basic.lean` | `ghostDenom_odd` |
| D ≠ 0 | `Syracuse/Basic.lean` | `ghostDenom_ne_zero` |
| R₁ is odd | `Syracuse/Persistence.lean` | `ghostR_odd` |
| ALL orbit numerators odd | `Syracuse/GeneralOrbit.lean` | `orbit_all_odd` |
| Numerator recurrence | `Syracuse/Persistence.lean` | `numerator_recurrence` |
| Persistence (modular) | `Syracuse/Persistence.lean` | `persistence_at_level` |
| Generalized iteration (c=1,D) | `Syracuse/OrbitFormula.lean` | `generalized_iteration` |
| ghostR = paper's Σ formula | `Syracuse/GhostR.lean` | `ghostR_eq_paper` |
| ghostR append decomposition | `Syracuse/GhostRAppend.lean` | `ghostR_append` |
| Concentrated formula (e=1) | `Syracuse/Concentrated.lean` | `ghostR_concentrated` |
| R = 3^L - 2^L for e=1 | `Syracuse/Concentrated.lean` | `ghostR_e1` |
| Orbit factored form | `Syracuse/GeneralOrbit.lean` | `orbit_factored_form` |
| Case-a from oddness | `Syracuse/GeneralOrbit.lean` | `case_a_step` |
| Concentrated R_i > 0 | `Syracuse/NegativeRationality.lean` | `orbitNumerator_pos` |
| Concentrated R_i odd | `Syracuse/NegativeRationality.lean` | `orbitNumerator_odd` |

## What's NOT formalized

| Paper result | Reason |
|-------------|--------|
| Theorem 1 (Spectral properties) | Requires Banach space spectral theory not in Mathlib |
| Theorem 2 (Lasota-Yorke obstruction) | Requires Lipschitz spaces on Z₂ |
| Theorem 3 (2-adic unboundedness) | Requires Q₂-valued function spaces |
| Theorem 6 (Persistence, full periodicity) | Requires 2-adic periodicity of D⁻¹ |
| Propositions 4-5 (Baker bounds) | Requires formalized transcendence theory |
| Proposition 6 (Non-compactness) | Requires equicontinuity theory |

## Proof highlights

The formalization discovered a **simpler proof** of Theorems 8-9 than appears in the paper. The paper uses an explicit double-sum expansion and analyzes 2-adic valuations term by term. Our proof uses a structural decomposition:

1. **`ghostR_append`**: `ghostR(a ++ b) = 3^|b| · ghostR(a) + 2^{sum a} · ghostR(b)`
2. **Cancellation**: `3^L + D = 2^V` (since D = 2^V - 3^L)
3. **Factoring**: `R(i) = 2^{V-S_i} · ghostR(take) + 3^i · ghostR(drop)`
4. **Parity**: even + odd = odd (since `ghostR(drop)` is odd by `ghostR_odd`)

This eliminates the closed-form double-sum entirely and derives oddness from the structural decomposition.

## Paper

DOI: [10.5281/zenodo.15000179](https://doi.org/10.5281/zenodo.15000179)

## License

This formalization accompanies the paper and is released under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
