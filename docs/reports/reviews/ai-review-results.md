# Multi-Model AI Review: "Ghost Cycles of the Syracuse Map"

**Date:** 2026-03-12
**Paper:** Ghost Cycles of the Syracuse Map (v2)
**Zenodo:** https://zenodo.org/records/18970369
**Prompt:** "I'd like a section-by-section review of the attached mathematics preprint on the Collatz conjecture. For each section, write 1–2 paragraphs covering: (1) what the section claims or proves, (2) whether the mathematics looks correct and well-supported, and (3) any concerns a referee might raise. Be critical — I want genuine assessment of the work, not encouragement. Sections to cover: Abstract, Introduction, Transfer Matrix, Spectral Theory, Ghost Cycles, Persistence, Density, Spectral Radius, Negative Rationality (Conjecture 4 + Theorem 6), Fredholm Determinant, Related Work, Discussion/Conclusion."
**Raw outputs:** `docs/reviews/raw/`

---

## Models Tested

| Model | Version | Date | Verdict |
|-------|---------|------|---------|
| GPT | 5.4 Pro (run 1) | 2026-03-12 | False positive (mod-3 clopenness); context-burned run |
| GPT | 5.4 Pro (run 2) | 2026-03-12 | Same false positive confirmed model-intrinsic; most thorough computational review |
| GPT | 5.4 Thinking | 2026-03-12 | No false positives; one new concern (persistence primitivity); verdict: rejection |
| GPT | 5.3 Instant | | pending |
| Gemini | 3.1 Pro | 2026-03-12 | Zero false positives; all criticisms fair or known open problems |
| Gemini | 3 Thinking | 2026-03-12 | Zero false positives; one outdated claim (compactness now resolved) |
| Claude | Sonnet 4.6 | 2026-03-12 | Zero false positives except one significant miss (Theorem 6); thorough on small issues |
| Claude | Opus 4.6 | 2026-03-12 | Zero false positives; most careful on Conjecture 4 implications and missing citations |
| DeepSeek | R1 70B | 2026-03-12 | Zero false positives; most positive verdict (9/10, minor clarifications only); input via markdown |
| Mistral | Large (standard, version unknown) | 2026-03-12 | Zero false positives; all criticisms fair; one outdated compactness claim |
| Mistral | Magistral (Think mode) | 2026-03-12 | Degenerate run — returned in ~1s, no specific criticisms, not usable |

---

## GPT-5.4 Pro

**Raw:** `raw/gpt-5.4-pro-run1.txt`, `raw/gpt-5.4-pro-run1-thoughts.txt`

**Run conditions (run 1):** Model spent ~15 minutes attempting to fetch the PDF from the Zenodo URL before failing; user then uploaded directly. Significant context window consumed before reading began. Thoughts trace shows early fixation on mod-3 and clopenness, suggesting compressed reasoning.

**Run 2 raw:** `raw/gpt-5.4-pro-run2.txt`, `raw/gpt-5.4-pro-run2-thoughts.txt`

**Run conditions (run 2):** Clean prompt, PDF uploaded directly. Thoughts trace (17m 51s) shows model rendering the PDF, writing and running Python to verify claims, and independently discovering the D=-601 persistence pattern (k=12, 37, 62) without prompting.

### Correct criticisms
- Persistence proof needs more rigor — valuation conditions not fully argued
- Baker–Wüstholz "superexponential" claim overstated (run 2 only)
- Eigenfunction δ_1 = 1_{1} needs careful treatment in the 2-adic setting
- Product formula independence assumption speculative
- Fredholm determinant terminology misleading
- Abstract/intro rhetoric too strong
- n = −1/3 exceptional point: S not obviously a self-map of all odd 2-adics (run 2 only)

### False positives
- **"mod 3 is not a continuous notion on Z_2, so the preimage structure is wrong"** — persists in both runs, confirming model-intrinsic weakness. GPT conflates two definitions of L: (1) the projective limit of integer Syracuse maps, where W ∈ {1/3, 2/3} follows from integer arithmetic; (2) a hypothetical full 2-adic preimage operator where all branches g_v(n) = (2^v n−1)/3 are included, giving W ≡ 1. The paper uses (1). GPT's counterexample (m = 1/3 as a preimage) is a non-integer 2-adic element, irrelevant under definition (1). The fix is one clarifying sentence, not a rewrite.
- Downstream claims (‖L‖ = 2/3 wrong, Lemma 1 false, LY obstruction invalid) all follow from the above misread and are equally invalid.

### Missed
- Theorem 1(e) quasi-compactness subtlety
- Primitivity gap in persistence proof

### Notable
- Run 2 independently verified D=-601 persistence via live computation — most rigorous mathematical engagement of any model tested.
- False positive confirmed as model-intrinsic (identical misread in both runs despite clean context in run 2).

---

## GPT-5.4 Thinking

**Raw:** `raw/gpt-5.4-thinking.txt`

### Correct criticisms
- Theorem 1(e) (σ(L) = ∪σ(P_k)) asserted rather than proved
- **Primitivity gap in persistence proof** — reduced orbit might collapse to shorter period mod 2^k; not addressed anywhere in the paper (unique to this model)
- λ = 1/4 simplicity only computationally verified through k=36
- Product formula heuristic; visually resembles a theorem
- k=1000 scan is algebraic membership testing, not exhaustive cycle search
- Fredholm determinant terminology misleading
- Notation: L overloaded for operator and cycle length
- σ(L) ⊃ [1/4, 1/2] claim rests on unproved spectral identification
- "Closing the Mahler/Amice program" too sweeping

### False positives
- None.

### Missed
- Operator definition ambiguity (projective limit vs. full 2-adic preimage)
- Archimedean compactness (now resolved negatively — not compact)

### Notable
- Only model to raise the **primitivity concern** — a genuine mathematical gap worth addressing.
- Did not reproduce GPT Pro's mod-3 false positive.
- Verdict "rejection" vs. Gemini's "major revision" — same substance, harsher framing.

---

## Gemini 3.1 Pro

**Raw:** `raw/gemini-3.1-pro.txt`

### Correct criticisms
- Theorem 1(e) closure argument delicate without quasi-compactness
- Product formula assumes equidistribution between ghost periods — non-trivial
- Fredholm determinant section brief
- Iwasawa analogy underdeveloped
- Materialization not proved — correctly identified as the central open problem

### False positives
- None.

### Missed
- Nothing significant.

### Notable
- Correctly distinguished proved results from conjectures throughout.
- Identified Theorem 6 as the analytical high point.
- Best overall accuracy of any model tested.
- Verdict: **solid review, zero false positives.**

---

## Gemini 3 Thinking

**Raw:** `raw/gemini-3-thinking.txt`, `raw/gemini-3-thinking-referee-report.txt`

*Also generated a formal referee report unprompted — the only model to do so.*

### Correct criticisms
- λ = 1/4 simplicity only computationally verified
- Product formula independence assumption non-trivial
- Universal case-(a) lacks general proof
- Theorem 6 concentrated-only; non-concentrated patterns require new control
- Persistence theorem requires careful 2-adic expansion argument

### False positives / outdated claims
- "Archimedean compactness of L on C(Z_2, R) remains open" — subsequently proved false: L is NOT compact (proved via mod-3 equicontinuity argument; see `docs/spectral-limits-analysis.md`). The model correctly identified it as a weakness in the paper; our follow-up work resolved it negatively.

### Missed
- Operator definition ambiguity
- Theorem 1(e) quasi-compactness subtlety (caught by Gemini 3.1 Pro)

### Notable
- Generated a referee report unprompted; verdict: Major Revision (accurate).
- No hallucinations on core mathematics.
- Archimedean compactness flag is interesting in retrospect — correct diagnosis, negative resolution.

---

## Mistral Large (standard)

**Raw:** `raw/mistral-large-standard.txt`

**Run conditions:** Default mode on chat.mistral.ai (no Think, no Research). Model version not exposed in UI; assumed Mistral Large (likely Large 2 or Large 3 from December 2025). PDF uploaded directly.

### Correct criticisms
- Product formula independence assumption unproved (equidistribution between ghost periods non-trivial)
- Theorem 1(e) σ(L) = ∪σ(P_k) needs more detail on projective-limit/spectrum interaction
- Persistence proof edge cases — valuation stability under modular reduction not fully argued; k₀ determination not discussed
- "Closing the Mahler/Amice program entirely" too strong; does this rule out distributions or other p-adic spaces?
- k=1000 density estimate needs error bars or convergence discussion
- Growing gaps pattern in [3,36] — more data beyond k=200 requested

### False positives
- None.

### Outdated claims
- **"Archimedean compactness of L might hold — referees may want this explored further"** — subsequently proved false: L is NOT compact. Same correct-diagnosis/negative-resolution pattern as Gemini 3 Thinking.

### Missed
- Primitivity gap in persistence proof (GPT Thinking exclusive)
- Fredholm determinant terminology
- Theorem 1(e) quasi-compactness subtlety

### Notable
- Correctly assessed ‖L‖ = 2/3 proof as "correct and elegant" — no mod-3 false positive.
- Identified case-(b) ghosts as an underexplored gap: are they truly non-persistent, or just more subtle?
- Verdict implicit: **major revision** (all criticisms fair, no hallucinations).

---

## DeepSeek R1 70B

**Raw:** `raw/deepseek-r1-70b.txt`

**Run conditions:** Run locally via Ollama on 64GB M3 Max MacBook Pro. Input provided as `docs/arxiv-paper-a.md` from the monorepo (markdown, not the v2 PDF). Extended chain-of-thought reasoning visible in output (prefixed "Thinking..."). Total run time: several hours.

**Version caveat:** `arxiv-paper-a.md` had three post-v2 commits on 2026-03-12 before DeepSeek ran:
- `02888dd` accumulated updates
- `f1f6f68` replace hard-coded theorem numbers with `\ref{}` labels
- `27610dd` add `\label{}` to all conjectures/definitions, fix cross-refs, add Table 5, cite figures

These are structural/LaTeX improvements, not substantive content changes — the core mathematical claims, proofs, and the issues identified by other models were unchanged. However, improved cross-references and labels may have made the paper easier to follow, potentially contributing to DeepSeek's more positive assessment. The 9/10 verdict should be read with this in mind.

### Correct criticisms
- Abstract/intro rhetoric: some claims should be more explicitly qualified as conjectural — consistent with all other models
- Product formula needs inclusion-exclusion for overlapping ghost periods — consensus issue
- Theorem 1(e) σ(L) = ∪σ(P_k): flagged as "well-supported by density arguments" but not pinned as an explicit gap — softer than other models

### False positives
- None.

### Notable
- **Most positive verdict of any model**: "deserves publication in a top-tier journal with minor clarifications" — explicit accept with minor revision.
- **Rating: 9/10.** No other model gave a numerical rating or an explicit accept recommendation.
- Correctly assessed ‖L‖ = 2/3, Lasota–Yorke obstruction, and 2-adic unboundedness as "high mathematical correctness."
- Thinking section shows genuine section-by-section engagement before writing the review.
- Persistence theorem called "sound"; Baker–Wüstholz bounds "appropriately limit ghost types."

### Caveats
- Markdown input may reduce friction vs. PDF parsing — hard to fully control for.
- Thinking section mentions "88+ materializing types" — slight misread; paper has 157,909 ghost types of which 13 materialize. Not reflected in the actual review text.

---

## Mistral — Magistral (Think mode)

**Raw:** `raw/mistral-magistral-think.txt`

**Run conditions:** Think mode on chat.mistral.ai, which activates Magistral (Mistral's dedicated reasoning model). PDF uploaded directly. Response returned in approximately 1 second.

**Verdict: Degenerate run — not usable.**

The output is uniformly shallow: every section receives one sentence of summary followed by "a referee might want to verify in detail." No specific claims are challenged, no false positives, no mathematical engagement. The 1-second return time indicates the model did not actually perform any extended reasoning. This may reflect a capacity/routing issue rather than a fundamental capability ceiling — Magistral is documented as capable of mathematical reasoning. Raw output archived for completeness.

---

## Claude Sonnet 4.6

**Raw:** `raw/claude-sonnet-4.6.txt`

**Run conditions:** New Linux user account on a separate host with no Claude configuration; Claude Code installed via the standard install script. Input: `arxiv-paper-a.md` (markdown, pre-v3 version — same base used for v2). Effort: Medium. Prompt references "the markdown file in this directory."

### Correct criticisms

- Abstract conflates proved ("ghosts are 2-adic orbits") with unproved ("elements are negative rationals") in one sentence — a real but minor distinction
- Companion paper cited in Introduction but not in the reference list
- "Extends prior searches" not substantiated — prior state-of-the-art search depth not cited
- Proposition 1 proof has a minor off-by-one in the intermediate step (the intermediate probability is misstated before correcting to the final answer $2^{-j}$)
- Theorem 1(e): coarsening error argument is hand-wavy; $\mathcal{L}$ does not map $A_k$ into $A_k$ in general; the Stone–Weierstrass converse gives density of approximate eigenvectors but not the spectral identity without norm-resolvent convergence
- Theorem 1(c): simplicity of $\lambda = 1/4$ is computational, not proved
- Second Remark in Section 4: "a global Lasota–Yorke inequality cannot be recovered" from conditional contraction is stated as a fact rather than proved
- Theorem 4: the threshold $k > \max_i v_i$ for condition (ii) to stabilise is not explicitly identified; the relationship between this threshold and $k_0$ is not addressed
- $K_0(5) \leq 269$, $K_0(10) \leq 465{,}239$ stated without derivation or reference
- Conjecture 2: convergence of the infinite product $\prod(1 - r_\mathcal{G}/p_\mathcal{G})$ not discussed; empirical density checked only to $k = 1000$ while $\mathrm{lcm}(\text{periods}) \sim 10^{10}$
- Conjecture 4 remark about Collatz periodic orbits could mislead a non-specialist about the paper's scope; the two-directional nature of the implication is not emphasized
- Fredholm determinant appears only as a two-sentence observation with no proof or application — vestigial
- Matthews (1985) vs Matthews (2010) reference ambiguity in the reference list
- Lagarias (1985) appears in the reference list but is not cited in the body
- Iwasawa analogy ("$\mu \neq 0$") is a single sentence with no support

### False positives

- **"No theorem bearing number 6 appears in the paper; the numbering stops at Theorem 4."** — Incorrect. The paper has six theorems: Theorems 1–4 each preceded by explicit `\setcounter{theorem}` resets in the LaTeX source (which the model apparently read as the theorem numbering itself), but Theorem 5 (Persistence, Section 7) and Theorem 6 (Negative Rationality for Concentrated Patterns, Section 9) follow without explicit resets and are present in the paper. The model miscounted by confusing the `\setcounter` commands for theorem identifiers.

### Missed

- Missing Eliahou (1993) citation — relevant to Conjecture 4's Collatz implications (Opus caught this)
- LY obstruction doesn't rule out Lasota–Yorke on function spaces not defined by a 2-adic modulus of continuity (Opus caught this)
- Bohm–Sontacchi (1978) for cycle equation attribution alongside Steiner (Opus caught this)
- $D$ near zero subtlety for positive-integer cycles and Conjecture 4 (Opus caught this)
- Spectral radius proof: "every eigenvalue of $\mathcal{L}$ corresponds to a periodic orbit" needs justification (Opus caught this)

### Notable

- Most thorough treatment of small expository issues (proof steps, reference list, remark statuses).
- False positive on Theorem 6 is a significant miss: the model appears to have been confused by the `\setcounter` LaTeX commands and failed to identify the last two theorems in the paper.

---

## Claude Opus 4.6

**Raw:** `raw/claude-opus-4.6.txt`

**Run conditions:** Same as Sonnet 4.6 — new Linux user account on a separate host, no Claude configuration, same markdown input, Medium effort.

### Correct criticisms

- Abstract: "replacement conjectures" framing unclear without context; "88+ materializing ghost types" is a lower bound from sampling and deserves more careful phrasing
- "Falsifying own earlier conjecture" has less rhetorical impact than the framing suggests; "revising" would be more accurate
- Prior exhaustive search depth not cited for comparison
- Companion paper reference is a loose thread if unpublished
- Proposition 1 proof: minor expository hiccup (probability phrased incorrectly in an intermediate step)
- Theorem 1(e): Stone–Weierstrass gives approximate eigenvectors but not the spectral identity without collective norm-resolvent convergence of the $P_k$
- Theorem 1(c): simplicity of $\lambda = 1/4$ is computational, not proved — a cycle with $V = 2L$ for any $L$ would also produce eigenvalue $1/4$, and no proof excludes such cycles at large $k$
- Spectral radius bound (Proposition 3): proof asserts "every eigenvalue corresponds to a periodic orbit" without justification; this is non-obvious for a general bounded operator on $C(X)$
- LY obstruction (Theorem 2): the result blocks spectral gap via 2-adic regularity, but does not preclude a Lasota–Yorke inequality on a function space not defined by a 2-adic modulus of continuity
- Conjecture 1 (universal case-(a)): no theoretical argument for why case-(b) never occurs in the range $V < 2L$; restriction to $V < 2L$ seems arbitrary given the paper notes case-(a) holds even for $V \geq 2L$
- Theorem 4 (persistence): gap between "first appearance" and "periodic from the first appearance" not carefully addressed; the periodicity of $D^{-1} \bmod 2^k$ should be stated more precisely (it follows from the 2-adic expansion of $1/D$ being eventually periodic, not directly from $2^p \equiv 1 \pmod{|D|}$)
- Conjecture 2: product formula is really a heuristic estimate with an explicit error term, not a conjecture; convergence of the infinite product $\prod(1 - r_\mathcal{G}/p_\mathcal{G})$ not argued; only accounts for ghost types with $L \leq 12$
- Conjecture 3: paper does not discuss what $\rho(\mathcal{L}) = 1/2$ would imply for the Collatz conjecture itself
- Missing Eliahou (1993) citation — existing cycle-exclusion results (no cycle of length $< 17{,}087{,}915$) are directly relevant to Conjecture 4's claimed implications for Collatz cycles
- Conjecture 4: the implication "no positive-integer Collatz cycles" requires $D < 0$, which holds for $V < L\log_2 3$; for $V/L$ close to $\log_2 3$, $D$ is near zero and the argument needs care
- Bohm–Sontacchi (1978) should be cited alongside Steiner (1977) for the cycle equation
- Fredholm determinant: stated only for the finite matrix, not the infinite-dimensional operator $\mathcal{L}$; underdeveloped and could be cut
- Iwasawa analogy unexplained — "deep observation or superficial analogy" with no way to judge
- Discussion has no clear statement of the single most important open problem from the paper's perspective
- Claude acknowledgment may prompt referee questions about reliability of AI-assisted mathematical reasoning

### False positives

- None.

### Missed

- Abstract conflation of proved/unproved in a single sentence (Sonnet caught this)
- Matthews (1985) vs (2010) reference ambiguity (Sonnet caught this)
- Lagarias (1985) in reference list but not cited in body (Sonnet caught this)

### Notable

- Only model to flag the missing Eliahou (1993) citation — a genuine gap given Conjecture 4's stated implications.
- Most careful treatment of the Conjecture 4 ↔ Collatz cycles implication, identifying the $D$-near-zero subtlety.
- Correctly noted that the LY obstruction does not close the door on all Banach space approaches.
- Zero false positives.

---

## Cross-Model Summary

*Pending remaining models (GPT-5.3 Instant).*

### Issues flagged by multiple models (consensus)

| Issue | Models |
|-------|--------|
| Persistence proof too compressed / needs rigorous congruence lemma | GPT Pro ×2, GPT Thinking, Gemini Thinking |
| Theorem 1(e) σ(L) = ∪σ(P_k) asserted not proved | GPT Thinking, Gemini 3.1 Pro |
| λ = 1/4 simplicity only computationally verified | GPT Thinking, Gemini Thinking |
| Product formula independence assumption unproved | All 4 + Mistral |
| Abstract/intro rhetoric too strong | GPT Pro ×2, GPT Thinking, Mistral |
| Fredholm determinant terminology misleading | GPT Thinking, Gemini 3.1 Pro, Gemini Thinking |

### Issues flagged by only one model

| Issue | Model |
|-------|-------|
| Primitivity gap in persistence proof | GPT-5.4 Thinking |
| k=1000 scan is membership test, not exhaustive search | GPT-5.4 Thinking |
| Baker–Wüstholz "superexponential" claim wrong | GPT-5.4 Pro run 2 |
| n = −1/3 exceptional point | GPT-5.4 Pro run 2 |
| Theorem 1(e) quasi-compactness subtlety | Gemini 3.1 Pro |

### Issues flagged by Claude models (new, not in prior summary)

| Issue | Models |
|-------|--------|
| Theorem 1(e) coarsening error hand-wavy; Stone–Weierstrass gives eigenvectors, not spectral identity | Sonnet, Opus |
| Theorem 1(c) simplicity computational, not proved | Sonnet, Opus |
| Companion paper not in reference list | Sonnet, Opus |
| Prior exhaustive search depth not cited | Sonnet, Opus |
| Conjecture 2 infinite-product convergence not addressed | Sonnet, Opus |
| Fredholm determinant vestigial — two sentences, no proof or application | Sonnet, Opus |
| Iwasawa analogy unexplained | Sonnet, Opus |
| Spectral radius proof: "eigenvalues = periodic orbits" needs justification | Opus |
| LY obstruction doesn't rule out all function space approaches | Opus |
| Missing Eliahou (1993) citation re: Conjecture 4 implications | Opus |
| $D$ near zero subtlety for Conjecture 4 and positive-integer cycles | Opus |
| Bohm–Sontacchi (1978) missing for cycle equation attribution | Opus |

### Common false positives

| Claim | Model | Why wrong |
|-------|-------|-----------|
| mod-3 preimage structure invalid on Z_2 | GPT-5.4 Pro (both runs) | Conflates projective-limit definition with full 2-adic preimage definition; paper uses the former |
| "Theorem 6 doesn't exist; numbering stops at Theorem 4" | Claude Sonnet 4.6 | Theorems 5 (Persistence) and 6 (Concentrated Patterns) exist; model was confused by explicit `\setcounter` commands in the LaTeX source preceding Theorems 1–4, which it read as theorem numbers rather than counter resets |

### Items to address before arXiv submission
1. **Operator definition** — one sentence clarifying L is the projective limit of integer Syracuse maps (prevents the GPT Pro misread recurring with a human referee)
2. **Persistence proof** — standalone congruence lemma; address primitivity explicitly
3. **Archimedean compactness** — update paper: L is NOT compact (proved, cite spectral-limits-analysis)
4. **Theorem 1(e)** — add detail on why approximate-eigenvalue closure works
5. **Rhetoric** — soften "closing the Mahler/Amice program entirely"
6. **k=1000 scan** — one sentence: algebraic membership testing via periodicity formula, not exhaustive enumeration
7. **Eliahou (1993)** — cite in context of Conjecture 4's Collatz implications (Opus)
8. **Companion paper** — add to reference list or note as in preparation
9. **Conjecture 2 convergence** — acknowledge infinite-product convergence as an open sub-question
