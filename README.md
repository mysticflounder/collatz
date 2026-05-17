# Collatz

Adam McKenna's research on the 3n+1 problem. Two self-contained subprojects.

---

## Looking for the *Ghost Cycles* paper? → [`ghost-cycles/`](./ghost-cycles)

Everything from the paper *Ghost Cycles of the Syracuse Map: 2-Adic Periodic
Orbits and the Exceptional Set* (McKenna, March 2026,
[DOI 10.5281/zenodo.18949342](https://doi.org/10.5281/zenodo.18949342)) now
lives under [`ghost-cycles/`](./ghost-cycles):

- Python analysis (`analysis/`, `collatz/`, `tests/`)
- Lean formalization of the cycle results (`lean/`)
- Paper sources and figures (`docs/`)
- Setup, build, and reproduction instructions are in
  [`ghost-cycles/README.md`](./ghost-cycles/README.md)

If you cloned this repo before May 2026, those files used to be at the
repository root — they were moved into the subdirectory to make room for the
second project below.

---

## [`collatz-conjecture/`](./collatz-conjecture)

A live Lean proof effort targeting the full Collatz conjecture. The directory
contains:

- [`data/blueprint.db`](./collatz-conjecture/data/blueprint.db) — a SQLite
  proof blueprint: obligations, dependencies, Lean artifacts, status.
- [`lean/CollatzConjecture/`](./collatz-conjecture/lean/CollatzConjecture) —
  the Lean source files realizing those obligations.

This subdirectory is the data source for the public dashboard at
[**proofprojects.org**](https://proofprojects.org), which renders the
obligation tree, proof status, and chain-completeness rollup directly from
`blueprint.db`.

---

## License

[MIT](./LICENSE). Both subprojects.
