## arXiv Pre-Submission Checklist Review
**Paper:** Ghost Cycles of the Syracuse Map (v3)
**Date:** 2026-03-12

### 1. Abstract <-> Body Consistency

**"88+ materializing ghost types"** (abstract L25): Body L796-798 says "at least **88** materialize." PASS.

**">= 4%"** (abstract L26): Body L943 says "delta(E) >= 1/25 = 4%" from D=-601 ghost alone. PASS.

**"k = 36"** (abstract L20): Body L556 confirms exhaustive enumeration through k=36. PASS.

**"5,996"** (abstract L29): Body L1039-1040 says "5,996 canonical case-(a) ghost types." PASS.

**"L = 12"** (abstract L26): Body L795-796 says "through cycle length L = 12." PASS.

**"k = 200"** (abstract L20): Body L1188 says "confirmed through k = 200." PASS.

**"rho >= 2^{-16/15}"** (abstract L27): Body L881 and L1029 confirm this bound. PASS.

**"||L|| = 2/3"** (abstract L9): Body Proposition 2 (L284) confirms. PASS.

**"rho(L) <= 1/2"** (abstract L9): Body Proposition 3 (L310) confirms. PASS.

**"||P_k||_{2-adic} = 2^{k+O(1)}"** (abstract L13): Body Theorem 3 (L494) confirms. PASS.

**"four replacement conjectures"** (abstract L27): Body has Conjectures 1-4 (Universal case-(a), Density of E, Spectral Radius, Negative Rationality). PASS.

**Conjecture refs in abstract**: Conjecture~\ref{conj:negative-rationality} (abstract L28, L33) resolves to Conjecture 4 (L1033). PASS.

**Three obstructions and common root cause** (abstract L14-17): The abstract claims all three obstructions trace to "the weight 2^{-v} is archimedeanly small but 2-adically large." The "Common root cause" remark at L530-541 only discusses the first two obstructions (Theorems 2 and 3). The third obstruction (Proposition 6, non-compactness at L1219) is proved via a different technique (non-equicontinuity / Tietze extension), though it ultimately relies on the same mod-3 weight-sum oscillation (1/3 vs 2/3). The body never explicitly states that all three share the same root cause. **Moderate** (L14-17, L530-541): The abstract's "All three obstructions trace to a common root cause" is not established in the body for all three together; only two are discussed under the "Common root cause" remark. Consider adding a sentence to the Proposition 6 proof or the subsequent text connecting it to the common root cause.

### 2. Contributions List <-> Body

**(1)** "transfer operator framework... six-part spectral theorem": Theorem 1 (L321-338) has parts (a)-(f). PASS.

**(2)** "Theorem~\ref{thm:ly}": Resolves to Theorem 2 (L403). Proved at L417-427. PASS.

**(3)** "Theorem~\ref{thm:2adic}": Resolves to Theorem 3 (L489). Proved at L497-514. PASS.

**(4)** "Proposition~\ref{prop:not-compact}": Resolves to Proposition 6 (L1219). Proved at L1223-1240. PASS.

**(5)** "exhaustive cycle enumeration through k = 36": Section 6 (L554-599) presents this. PASS.

**(6)** "identification of ghost cycles as 2-adic periodic orbits... persistence theorem": Section 7 covers this; Theorem 5 (L691-729) is the persistence theorem. PASS.

**(7)** "census of 88+ materializing ghost types... through L = 12, organized into families by excess": Section 8 (L793-929) presents the census organized by excess. The "18 denominator values" claim at L101 matches the census table (L807-827) which lists exactly 18 rows/denominator values. PASS.

**(8)** "density >= 4% unconditionally and spectral radius >= 2^{-16/15}": Density at L943/L1000; spectral radius at L881/L1029. PASS.

**(9)** "four replacement conjectures": Conjectures 1-4 in Sections 7 and 9. PASS.

**(10)** "unconditional proof (Theorem~\ref{thm:conc})... establishing Conjecture~\ref{conj:negative-rationality} for this family and the universal case-(a) property for concentrated patterns as a byproduct": Theorem 6 (L1044-1073) proves negative rationality for concentrated patterns and case-(a) as a byproduct. The phrasing "establishing Conjecture~\ref{conj:negative-rationality} for this family" is accurate -- it establishes the conjecture for the concentrated subfamily, not the full conjecture. PASS.

### 3. Outline <-> Section Structure

The outline (L141-152) lists:

| Outline claim | Actual section |
|---|---|
| "Section 2 defines the objects of study" | Section 2 "Definitions and Setup" (L155) |
| "Section 3 develops the transfer operator... spectral theorem" | Section 3 "The Transfer Operator on Z_2^{odd}" (L225) |
| "Section 4 proves the Lasota-Yorke obstruction" | Section 4 "The Lasota-Yorke Obstruction" (L388) |
| "Section 5 proves the 2-adic unboundedness obstruction" | Section 5 "The 2-Adic Unboundedness Obstruction" (L478) |
| "Section 6 enumerates the exceptional set through k=36" | Section 6 "Exhaustive Cycle Enumeration" (L554) |
| "Section 7 establishes ghost cycles as 2-adic periodic orbits..." | Section 7 "Ghost Cycles as 2-Adic Periodic Orbits" (L601) |
| "Section 8 presents the census" | Section 8 "Census of Ghost Types" (L793) |
| "Section 9 gives the density and spectral radius results together with replacement conjectures, and an unconditional proof... (Theorem~\ref{thm:conc})" | Section 9 "Density and Spectral Radius" (L932), contains Theorem 6 |
| "Section 10 presents eigenvalue spectra" | Section 10 "Eigenvalue Spectra" (L1099) |
| "Section 11 describes computational methodology" | Section 11 "Computational Methodology" (L1137) |
| "Section 12 discusses the results" | Section 12 "Discussion" (L1197) |

**Moderate** (L151, L1219): The outline says "Section 12 discusses the results and directions for future work." However, Section 12 (Discussion) also contains **Proposition 6** (Archimedean Non-Compactness), which is a substantive new result listed as contribution (4) in the contributions list. The outline does not mention that Section 12 contains a new proposition. A referee may question why a key result appears in the Discussion section rather than in the main body.

All other sections match. PASS for remaining items.

### 4. Theorem/Proof Completeness

**Theorem 1 (Spectral properties), L321-375:**
- Part (a): Deferred to Proposition 2. PASS.
- Part (b): Deferred to Proposition 3. PASS.
- Part (c): The eigenvalue claim is proved; simplicity is stated as "verified computationally" (L345-347). **Minor** (L330-331, L345-347): The statement says "simplicity is verified computationally... through k = 36" -- this is acknowledged as computational, not a general proof. Acceptable, but a referee may ask for clarification that simplicity is a computational observation, not a theorem.
- Part (d): "immediate from (b)" -- correct since sigma(L) is contained in the closed disk of radius rho(L). PASS.
- Part (e): The proof at L351-374 argues both directions of the spectral equality. The "sup_k rho_k = limsup rho_k" step uses a forward reference to Theorem 5 (persistence), which is noted as non-circular (L372-373). PASS.
- Part (f): "verified by dense eigenvalue computation" -- computational only. This is stated as such. PASS.

**Theorem 2 (Non-preservation of Lip_1), L403-427:**
Proof establishes both parts (a) and (b). Part (b) constructs explicit pairs showing the Lipschitz seminorm diverges. PASS.

**Theorem 3 (2-adic unboundedness), L489-514:**
The proof shows max_j v(j) >= k by finding j with 3j+2 = 0 mod 2^{k-1}. The upper bound on max_j v(j) is not explicitly proved (only "k + O(1)" is claimed and the upper bound is left implicit). **Minor** (L505-509): The proof shows max_j v(j) >= k, and the claim is "= k + O(1)." The upper bound (max_j v(j) <= k + O(1)) is not explicitly proved in the theorem proof; it is supported computationally (L543-546) but the theoretical proof only establishes the lower bound. The theorem's conclusion (unboundedness) follows from the lower bound alone, so this is not a logical gap, but the "= k + O(1)" claim is not fully proved.

**Theorem 4 (Cycle equation), L606-622:**
The proof derives the cycle equation by iterating L steps. The precision claim "modulo 2^{k+V}" at L622 requires some care: the proof argues that each step holds modulo 2^{k+v_i} and the total precision accumulates. PASS.

**Theorem 5 (Persistence), L691-729:**
Multi-part proof establishing (i)-(iii). All parts are explicitly argued.
**Minor** (L712-715): The periodicity claim "D^{-1} mod 2^{k+p} = D^{-1} mod 2^k (mod 2^k)" is stated but the explanation relies on "2^p = 1 mod |D| implies D^{-1} has a p-periodic 2-adic expansion." This is correct but the connection between multiplicative order of 2 modulo |D| and the period of the 2-adic expansion of D^{-1} could be made more explicit. The sentence at L714-715 is the argument, but a referee might want a one-line clarification that ord_2(|D|) = p means 2^p - 1 is divisible by |D|, so the 2-adic digits of 1/D repeat with period p.

**Theorem 6 (Negative Rationality for Concentrated Patterns), L1044-1073:**
The proof derives the closed form, verifies orbit closure, checks positivity, and verifies case-(a) conditions. All parts of the statement are established.
**Moderate** (L1069-1072): The oddness argument for R_i has a subtle step. For i < L, the proof claims v_2(first term) = L - i + 1 >= 2. The first term is 2^{L-i+1}(2^e - 1) * 3^{i-1}. Since 2^e - 1 is odd and 3^{i-1} is odd, v_2(first term) = L - i + 1. For i <= L-1, L - i + 1 >= 2. The second term 3^L - 2^{L+e} has v_2 = 0 (since 3^L is odd and 2^{L+e} is even, their difference is odd). So the sum of an even number (v_2 >= 2) and an odd number is indeed odd. For i = L: v_2(first term) = 1, second term is odd, so sum = even + odd = odd... wait, 2 * (odd) + odd = odd. Line 1072 says "2 * (odd) + odd = odd" -- that's correct. But the first term at i = L has v_2 = L - L + 1 = 1, so the first term is 2 * (odd product). The formula gives R_L = 2 * (2^e - 1) * 3^{L-1} + (3^L - 2^{L+e}). The second term 3^L - 2^{L+e} is odd (odd minus even). So R_L = 2 * odd + odd = even + odd = odd. PASS -- the argument is correct.

**Proposition 4 (Baker-Wustholz bounds), L757-762:**
No proof is given for Proposition 4. It is attributed to Baker-Wustholz (1993) and Laurent (2008). The statement is presented as a consequence of their results. PASS (standard attribution of external result).

**Proposition 5 (Detection of bounded-length ghosts), L764-784:**
Proof provided at L773-784. PASS.

**Proposition 6 (Archimedean Non-Compactness), L1219-1240:**
Proof by non-equicontinuity, constructing appropriate test functions via Tietze extension. The gap bound ">= 5/6 for N >= 2" is stated; let me verify: for N=2, 1 - (7/3)*4^{-2} = 1 - 7/48 = 41/48 ~ 0.854 > 5/6 ~ 0.833. PASS -- the bound is correct.

### 5. Theorem Numbering and Cross-References

**setcounter trace:**

| Line | Counter | Set to | Next item |
|---|---|---|---|
| L157 | definition | 0 | Definition 1 |
| L199 | proposition | 0 | Proposition 1 |
| L246 | lemma | 0 | Lemma 1 |
| L281 | proposition | 1 | Proposition 2 |
| L320 | theorem | 0 | Theorem 1 |
| L402 | theorem | 1 | Theorem 2 |
| L429 | corollary | 0 | Corollary 1 |
| L488 | theorem | 2 | Theorem 3 |
| L516 | corollary | 1 | Corollary 2 |
| L605 | theorem | 3 | Theorem 4 |
| L630 | definition | 5 | Definition 6 |
| L657 | conjecture | 0 | Conjecture 1 |
| L690 | theorem | 4 | Theorem 5 |
| L756 | proposition | 3 | Proposition 4 |
| L968 | conjecture | 1 | Conjecture 2 |
| L1043 | theorem | 5 | Theorem 6 |
| L1218 | proposition | 5 | Proposition 6 |

All numbering is internally consistent. The setcounter calls correctly produce the expected numbers.

**Cross-reference check:**

- "Lemma 1" at L289: refers to preimage structure lemma (L247). PASS.
- "Propositions~\ref{prop:operator-norm}--\ref{prop:spectral-radius-bound}" at L340: resolves to Propositions 2-3. PASS.
- "Theorem~\ref{thm:spectral}(e)" at L316: forward reference to Theorem 1(e), which is proved later in the same theorem's proof block. Noted as "whose proof is independent of this proposition." PASS.
- "Theorem~\ref{thm:persistence}" at L371, L373: forward reference to Theorem 5 (L691). Noted as non-circular. PASS.
- "Propositions 4--5" at L132, L787, L1264: refers to Baker-Wustholz (Proposition 4, L757) and detection (Proposition 5, L764). These are numeric references (not \ref), which is inconsistent with the rest of the paper that uses \ref. **Minor** (L132, L787, L1264): Three instances of hard-coded "Propositions 4--5" or "Propositions 4 and 5" rather than using \ref. These will not auto-update if numbering changes.

**Missing reference target:** Propositions 4 and 5 do not have labels that match any \ref in the text -- they use \label{prop:baker} and \label{prop:exclusion} respectively, but these labels are never referenced via \ref. The paper refers to them only by number ("Propositions 4--5"). **Minor** (L757, L764): Labels prop:baker and prop:exclusion are defined but never referenced with \ref.

### 6. Theorem Attributions

**Theorem 4** (L606): "Cycle equation; after Steiner 1977, Wirsching 1998." The Related Work (L126) says "The cycle equation (our Theorem~\ref{thm:cycle-eq}) appears in Steiner (1977)." This is an appropriate re-derivation with attribution using "after." PASS.

**Proposition 4** (L757): "Effective lower bound on |D|; Baker-Wustholz 1993, Laurent 2008." The proposition states a specific bound. The attribution to Baker-Wustholz (1993) and Laurent (2008) is appropriate -- these are standard results on linear forms in logarithms. The specific form of the bound (with the constant 25) may be the paper's own simplified version of the general Baker-type bound. **Minor** (L760): The exact form of the inequality "$|2^V - 3^L| > max(2^V, 3^L) * exp(-25 (log V)^2)$" should clarify whether this is the exact statement from Baker-Wustholz/Laurent or the paper's reformulation. The bracket title says "Baker-Wustholz 1993, Laurent 2008" which could imply direct quotation.

### 7. Reference Integrity

**Citations in text vs References section:**

All cited works have corresponding entries:
- Amice (1964): cited L485, in refs L1312. PASS.
- Assani (2024): cited L135, in refs L1314. PASS.
- Baker and Wustholz (1993): cited L130, in refs L1316. PASS.
- Kontorovich and Lagarias (2010): cited L132, in refs L1318. PASS.
- Lagarias (1985): cited L120, in refs L1320. PASS.
- Lagarias (2021): cited L120, in refs L1322. PASS.
- Lagarias and Weiss (1992): cited L123/L214, in refs L1324. PASS.
- Laurent (2008): cited L131, in refs L1326. PASS.
- Matthews and Watts (1985): cited L121, in refs L1328. PASS.
- Mori (2024): cited L136, in refs L1330. PASS.
- Neklyudov (2024): cited L136, in refs L1332. PASS.
- Serre (1962): cited L485, in refs L1334. PASS.
- Siegel (2026a): cited L127, in refs L1336. PASS.
- Siegel (2025b): cited L129, in refs L1338. PASS.
- Simons and de Weger (2005): cited L1090, in refs L1340. PASS.
- Steiner (1977): cited L126, in refs L1342. PASS.
- Tao (2022): cited L124, in refs L1344. PASS.
- Wirsching (1998): cited L122, in refs L1346. PASS.

No uncited references; no missing references.

**Bibliographic completeness:**
- Lagarias (1985) at L1320: missing first name initial "J. C." -- only "J." is given. The same abbreviation "J." is used consistently for Lagarias. **Minor** -- "J." is an acceptable abbreviation but the Kontorovich and Lagarias entry (L1318) uses "Lagarias, J. C." with the middle initial. Inconsistent treatment: L1320, L1322, L1324 use "Lagarias, J." while L1318 uses "Lagarias, J. C." -- should be uniform.

**Alphabetical order:**
The references are in correct alphabetical order by first author last name. Within Siegel: "Siegel, M. (2026a)" before "Siegel, M. (2025b)." **Minor** (L1336-1338): The year-letter suffixes are chronologically inconsistent: "2025b" denotes a work from 2025 while "2026a" denotes a work from 2026. Standard practice assigns suffix letters within the same year. These should be Siegel (2025) and Siegel (2026) without letter suffixes, since they are from different years. Furthermore, the chronological ordering should place 2025 before 2026 in the reference list.

### 8. Notation Conflicts

**$L$:** Used for cycle length and $\mathcal{L}$ for the transfer operator. Disambiguated explicitly at L632. PASS.

**$k$:** Used consistently as "level" (resolution parameter). Also appears as an index in the Mahler matrix discussion (L548: "offset(j)"), but $k$ there retains its level meaning. PASS.

**$p$:** Used for the multiplicative order ord_2(|D|) throughout Sections 7-9. Also used in "p-adic" ($p$-adic) in a different sense. These are standard and distinguishable. PASS.

**$e$:** Used for "excess" $e = V - L$ throughout Sections 7-9. The term "Euler's number" does not appear; $\exp$ is used for the exponential function (L760). No conflict. PASS.

**$E$:** Used for the exceptional set (Definition 5, L193) and also used in Corollary 2 (L519) as a generic Banach space: "any 2-adic Banach space $E \hookrightarrow C(...)$". **Moderate** (L519): The variable $E$ is overloaded -- it is the exceptional set (Definition 5) and also a generic Banach space in Corollary 2. These appear in different sections (Section 2 vs Section 5), not in the same paragraph, but a reader following both threads may be confused. Consider using a different letter (e.g., $\mathcal{E}$ or $X$) for the Banach space in Corollary 2.

**$N$:** Used for $N = 2^{k-1}$ (number of odd residues, L166) and also as a subscript index in the Theorem 2 proof ($x_N$, $y_N$ at L418). The subscript usage is clearly distinct. PASS.

**$r$:** Used for "number of residue classes" in ghost census tables (L802-803, L891-896) and for the radius in Proposition 6 proof ("Fix $r \geq 1$", L1224). Different sections. PASS.

### 9. Proof Prose Quality

**"Part (d) is immediate from (b)"** (L349): This is correct -- sigma(L) in {|z| <= rho(L)} and rho(L) <= 1/2 implies sigma(L) in {|z| <= 1/2}. PASS.

**"Part (a) is immediate"** (L417): Referring to the fact that a constant function has zero Lipschitz seminorm. Genuinely immediate. PASS.

**"the result immediate"** (L1273): Referring to positivity of R_i when both terms are positive and D < 0. Genuinely immediate. PASS.

**"clearly visible"** (L961-962): In a figure caption describing the periodic structure visible in a timeline plot. Acceptable in a caption context -- this is a visual observation, not a mathematical claim. PASS.

**Remark making strong claim without support** (L1288): "By analogy with Iwasawa theory, the infinitude of E corresponds to mu != 0." This is a one-sentence remark drawing an analogy without any mathematical development. **Minor** (L1288): The Iwasawa analogy is asserted without elaboration. A referee may ask for more substance or removal.

### 10. Figure Consistency

**Figure 1** (L598): Referenced at L596 ("Figure~1"). Markdown image syntax with caption. Caption describes chord diagrams at k = 9, 10, 12, 13. The caption mentions "cyan: L = 7, orange: L = 6" at k = 12, consistent with the census (D = -1675 has L = 7, D = -601 has L = 6, both first appearing at k = 12). PASS.

**Figure 2** (L655): Referenced at L653 ("Figure~2"). Markdown image syntax with caption. Caption describes digit stabilization for D = -601 ghost (L = 6, V = 7). Consistent with the census table (L810). PASS.

**Figure 3** (L955-964): Referenced at L953 ("Figure~\ref{fig:ghost_timeline}"). LaTeX figure environment with \includegraphics. Caption describes ghost timeline.

**Moderate** (L598, L655 vs L955-964): Mixed figure mechanisms -- Figures 1 and 2 use pandoc/markdown image syntax while Figure 3 uses LaTeX \begin{figure}/\includegraphics. This inconsistency may cause formatting issues depending on the compilation pipeline. For arXiv submission (which expects LaTeX), all figures should use LaTeX figure environments.

**Figure numbering**: The markdown images (Figures 1 and 2) do not use \label, so the hard-coded "Figure~1" and "Figure~2" references will not auto-update. The LaTeX figure (Figure 3) uses \label{fig:ghost_timeline} and \ref. **Minor** (L596, L653): Hard-coded figure numbers "Figure~1" and "Figure~2" instead of \ref.

### 11. Common Referee Objections

**Computational simplicity claims:** Theorem 1(c) (L329-331) claims lambda = 1/4 is an eigenvalue with "simplicity is verified computationally." The text explicitly qualifies this as computational verification through k = 36. No claim of general proof is made. PASS -- properly qualified.

**Circular proofs:** Theorem 1(e) proof (L370-373) uses a forward reference to Theorem 5 (persistence). The text explicitly addresses this: "This forward reference is non-circular, as Theorem~\ref{thm:persistence} is independent of Theorem~\ref{thm:spectral}." I have verified that Theorem 5's proof (L699-729) does not reference Theorem 1 or its consequences. PASS.

**Unproved "obviously"/"clearly"/"trivially":** Only one instance found -- "clearly visible" in a figure caption (L961). Not a mathematical claim. PASS.

**Undefined terms at first use:**
- "case-(a)" and "case-(b)" are used in the abstract (L22-23) and introduction (L80-82) before being formally defined at Definition 6 (L631). The introduction provides a parenthetical gloss: "case-(a) ghosts (those whose rational orbit matches the prescribed valuation pattern exactly; defined in Section 7)" (L81-82). **Minor** (L22-23, L80-82): Terms used before formal definition, but the parenthetical and forward reference mitigate this.
- "ghost cycles" is used starting from the abstract and introduction before any formal definition. The term is only informally characterized ("extra modular cycles beyond the fixed point {1}") and formally introduced at Definition 6 (L631) as "ghost type." **Minor** (L19, L78): "Ghost cycles" is the paper's central concept but does not receive a standalone definition -- "ghost type" is defined, and "ghost cycle" is used informally throughout.

**Overloaded variables in the same sentence:** The $E$ overload noted in Section 8 above occurs in different sections, not the same sentence. No same-sentence overloads found. PASS.

**"simple eigenvalue" claim:** At L330-331 (Theorem 1(c)), the statement says simplicity is "verified computationally (no other cycle with prod 2^{-v_i} = 1/4 materializes through k = 36)." This is properly qualified. PASS.

### Summary

**0 critical**, **4 moderate**, **9 minor** issues found.

**Moderate issues:**
1. (L14-17, L530-541) Abstract claims all three obstructions share a common root cause, but the body's "Common root cause" remark only discusses two of three.
2. (L151, L1219) Proposition 6 (a key contribution) appears in Section 12 (Discussion) rather than the main body; the outline does not flag this.
3. (L519) Variable $E$ is overloaded between the exceptional set (Definition 5) and a generic Banach space (Corollary 2).
4. (L598, L655 vs L955-964) Mixed figure mechanisms (markdown images vs LaTeX figure environments) will likely cause issues in arXiv LaTeX compilation.

**Minor issues:**
1. (L330-331) Theorem 1(c) simplicity is computational -- already qualified, but worth ensuring the referee reads it that way.
2. (L505-509) Theorem 3 proves max_j v(j) >= k but claims "= k + O(1)"; the upper bound is only verified computationally.
3. (L132, L787, L1264) Hard-coded "Propositions 4--5" instead of using \ref.
4. (L757, L764) Labels prop:baker and prop:exclusion are defined but never referenced via \ref.
5. (L760) The exact form of the Baker-Wustholz bound should clarify whether it is a direct quotation or reformulation.
6. (L1320-1324 vs L1318) Inconsistent use of middle initial for Lagarias ("J." vs "J. C.").
7. (L1336-1338) Siegel citation year-letter suffixes are chronologically inconsistent; entries from different years should not use letter suffixes.
8. (L1288) Iwasawa analogy is asserted in one sentence without development.
9. (L596, L653) Hard-coded figure numbers instead of \ref; "ghost cycles" used before formal definition.

**Bottom-line recommendation:** The paper is in good shape for submission. No critical issues were found. The four moderate issues should be addressed before submission: (1) extend the "common root cause" discussion to cover all three obstructions, (2) consider moving Proposition 6 into the main body or noting its presence in the outline, (3) rename the Banach space variable in Corollary 2, and (4) standardize figure mechanisms to LaTeX. The minor issues are cosmetic and can be addressed at the author's discretion.
