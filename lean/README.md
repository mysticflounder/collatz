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
| **Theorem 6** (Persistence) | `Syracuse/PersistenceFull.lean` | `persistence_theorem6` | Proved (oddness + valuations + closure) |
| **Theorem 7** (Orbit formula) | `Syracuse/OrbitFormula.lean` | `orbit_numerator_iteration` | Proved (iteration form) |
| **Theorem 8** (Negative rationality) | `Syracuse/GeneralOrbit.lean` | `negative_rationality_general` | Proved |
| **Theorem 9** (Universal Case-a) | `Syracuse/GeneralOrbit.lean` | `universal_case_a_general` | Proved |

### Theorem 6 — Persistence of case-(a) ghosts (24 theorems)

| Result | Lean file | Lean name |
|--------|-----------|-----------|
| D odd → coprime to 2 | `Syracuse/PersistenceFull.lean` | `odd_isCoprime_two` |
| D odd → coprime to 2^k | `Syracuse/PersistenceFull.lean` | `odd_isCoprime_two_pow` |
| Modular solution exists | `Syracuse/PersistenceFull.lean` | `coprime_mod_solution_exists` |
| Modular solution unique | `Syracuse/PersistenceFull.lean` | `coprime_mod_solution_unique` |
| Ghost solution exists | `Syracuse/PersistenceFull.lean` | `ghost_solution_exists` |
| Ghost solution unique | `Syracuse/PersistenceFull.lean` | `ghost_solution_unique` |
| Modular solution is odd (mod 2) | `Syracuse/PersistenceFull.lean` | `ghost_solution_odd_mod2` |
| Modular solution is odd (mod 2^k) | `Syracuse/PersistenceFull.lean` | `ghost_solution_odd` |
| Solution refinement | `Syracuse/PersistenceFull.lean` | `ghost_solution_refines` |
| Euler-Lagrange: ∃ p > 0, \|D\| ∣ (2^p − 1) | `Syracuse/PersistenceFull.lean` | `exists_period` |
| Valuation bridge: D(3n+1) ≡ 3R+D | `Syracuse/PersistenceFull.lean` | `modular_valuation_bridge` |
| Valuation transfer (divisibility) | `Syracuse/PersistenceFull.lean` | `valuation_transfer_dvd` |
| Valuation transfer (non-divisibility) | `Syracuse/PersistenceFull.lean` | `valuation_transfer_not_dvd` |
| Modular valuation stability | `Syracuse/PersistenceFull.lean` | `modular_valuation_stable` |
| **Full persistence (Theorem 6)** | `Syracuse/PersistenceFull.lean` | `persistence_theorem6` |
| Materialization predicate | `Syracuse/PersistenceFull.lean` | `GhostMaterializes` |
| Ghost materializes at all large k | `Syracuse/PersistenceFull.lean` | `ghost_materializes_all_large` |
| Materialization is monotone | `Syracuse/PersistenceFull.lean` | `ghost_materializes_monotone` |
| Periodicity corollary | `Syracuse/PersistenceFull.lean` | `ghost_materializes_periodic` |

### Supporting results (Theorems 4, 7, 8, 9)

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
| Propositions 4-5 (Baker bounds) | Requires formalized transcendence theory |
| Proposition 6 (Non-compactness) | Requires equicontinuity theory |

## Proof highlights

The formalization discovered a **simpler proof** of Theorems 8-9 than appears in the paper. The paper uses an explicit double-sum expansion and analyzes 2-adic valuations term by term. Our proof uses a structural decomposition:

1. **`ghostR_append`**: `ghostR(a ++ b) = 3^|b| · ghostR(a) + 2^{sum a} · ghostR(b)`
2. **Cancellation**: `3^L + D = 2^V` (since D = 2^V - 3^L)
3. **Factoring**: `R(i) = 2^{V-S_i} · ghostR(take) + 3^i · ghostR(drop)`
4. **Parity**: even + odd = odd (since `ghostR(drop)` is odd by `ghostR_odd`)

This eliminates the closed-form double-sum entirely and derives oddness from the structural decomposition.

Theorem 6 (persistence) uses a **valuation bridge** to transfer results from the rational orbit to modular orbits: the identity `D·(3n+1) - (3R+D) = 3·(nD - R)` lets us prove that modular orbit elements inherit exact valuations from the rational orbit numerators, since D is odd and coprime to all powers of 2.

## Paper

DOI: [10.5281/zenodo.15000179](https://doi.org/10.5281/zenodo.15000179)

## License

This formalization accompanies the paper and is released under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
