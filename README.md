# Infrastructure for the Agentic Web
## Gap Analysis and Architecture from the Agentverse Platform

**Authors**: Robin Dey and Panyanon Viradecha (OpenHub Research, Chiang Mai, Thailand)  
**Contact**: robin@openhubresearch.org  
**Target**: arXiv cs.AI  
**Date**: April 2026  
**Status**: ✅ Ready to submit

---

## Abstract

The emergence of autonomous AI agents as first-class participants in digital infrastructure marks a fundamental inflection point in the evolution of the Web. While significant research effort has been directed at the behaviour and reasoning of individual agents, comparatively little attention has been paid to the *infrastructure* those agents require to operate reliably at scale.

This paper presents a systematic analysis of **Agentverse** — the agent cloud platform developed by Fetch.ai and operated by the Artificial Superintelligence (ASI) Alliance (Fetch.ai, SingularityNET, and CUDOS) — as a case study in agent-native infrastructure.

Three principal contributions:

1. **Gap Taxonomy** — An empirical audit of 204 documented API endpoints yielding a structured taxonomy of **62 distinct missing infrastructure capabilities** across 8 categories
2. **Seven-Layer Agent Cloud Stack** — A principled reference architecture for a fully realised agent-native cloud platform by 2030
3. **Five Critical Evolution Paths** — Concrete transitions from current state to 2030

---

## Key Findings

| Category | Gaps | Key Missing Capability |
|----------|------|----------------------|
| A. Memory & State | 7 | Vector store, knowledge graph, episodic memory, MCP memory servers |
| B. Observability | 8 | Distributed tracing, cost tracking, streaming logs |
| C. Security & Governance | 8 | Capability-based permissions, sandbox isolation, policy engine |
| D. Networking & Communication | 8 | Native A2A, pub/sub event bus, streaming, group coordination |
| E. Dev Lifecycle | 8 | Multi-file projects, versioning, staging, local emulator |
| F. Data & Integration | 7 | Hosted DB, object storage, MCP Server Hub |
| G. Economic Primitives | 8 | Multi-dimensional reputation, SLA enforcement, KYA registry |
| H. Scale & Enterprise | 8 | Auto-scaling, multi-region, SSO, compliance certs |
| **Total** | **62** | |

### API Performance Benchmarks (live measurements, April 2026)

| Operation | Mean (ms) | p95 (ms) |
|-----------|-----------|----------|
| Almanac: exact-address lookup | 190 | 208 |
| Almanac: recent-agents feed | 164 | 173 |
| Agent search (keyword) | 176 | 196 |
| Agent search (open) | 170 | 193 |
| Hosting: list agents | 169 | 185 |
| Hosting: fetch logs | 243 | 276 |
| Hosting: agent profile | 209 | 348 |
| V2 Almanac resolve | 162 | 180 |

Search registry coverage: 1,140 "weather" agents, 3,039 "trading" agents, 1,135 "finance" agents; broad categories (data, image, news, assistant) each exceed the API's hard 10,000-result ceiling.

---

## The Seven-Layer Agent Cloud Stack

```
Layer 6: Economy       — Marketplace, reputation, KYA, economic primitives
Layer 5: Observability — Tracing, cost dashboards, guardrail evaluation
Layer 4: Services      — AgentDB, AgentStore, AgentCache, AgentMCP Hub
Layer 3: Communication — Multi-protocol gateway (Chat + A2A + MCP), event bus
Layer 2: Memory        — Episodic, Semantic, Procedural, Working, Shared (MCP)
Layer 1: Runtime       — Wasm sandbox, capability-based security, auto-scaling
Layer 0: Substrate     — ASI Chain, DIDs, Verifiable Credentials, TEEs
```

(Rendered as a colour-coded TikZ figure in the paper.)

---

## Five Critical Evolution Paths

1. **ctx.storage → Agent Memory Cloud** (episodic + semantic + procedural + working, all via MCP)
2. **Almanac → Semantic Agent DNS** (trust-weighted, capability-matched discovery)
3. **Chat Protocol → Agent Lingua Franca** (multi-protocol gateway: Chat + A2A + MCP)
4. **Single-instance → Agent Kubernetes** (auto-scaling, multi-region, health probes)
5. **Token payments → Agent Economic Primitives** (reputation, SLAs, lending, insurance)

---

## Repository Structure

```
.
├── paper/
│   ├── agentverse-paper.tex    # Full paper (LaTeX, JMLR preprint style, 28 pages)
│   ├── agentverse-paper.bib    # Bibliography (fact-checked, 32 cited / 35 defined)
│   ├── agentverse-paper.pdf    # Compiled PDF
│   └── jmlr2e.sty              # JMLR style file
├── arxiv-submission/           # arXiv upload bundle (tex + bib + sty)
│   ├── agentverse-paper.tex
│   ├── agentverse-paper.bib
│   ├── agentverse-paper.pdf    # Reference copy — do not upload to arXiv
│   └── jmlr2e.sty
├── Makefile                    # Build system
└── README.md
```

---

## Building the PDF

Requires a standard TeX Live installation with the `tikz` package:

```bash
make pdf        # Build the PDF
make arxiv      # Build + package for arXiv upload (creates .tar.gz)
make clean      # Remove build artefacts
```

Or manually:

```bash
cd paper
pdflatex agentverse-paper.tex
bibtex agentverse-paper
pdflatex agentverse-paper.tex
pdflatex agentverse-paper.tex
```

---

## Fact-Check and Revision History

All claims verified against primary sources. Key corrections applied over successive revision passes:

| Issue | Original | Corrected |
|-------|----------|-----------|
| Gap count | 52 | **62** (recounted across all 8 gap tables) |
| ASI Alliance composition | "Fetch.ai, SingularityNET, Ocean Protocol" | Fetch.ai + SingularityNET + CUDOS (Ocean departed Oct 2025) |
| Agentverse agent count | "340 agents" | 36,000+ (Almanac, Q1 2026) |
| ASI:One model name | "asi1-mini" (7 specialised models) | Unified `asi1` model + `asi1-mini` variant |
| Hussein et al. lead author | "Ahmed Refaey Hussein" | **Gamal Refai-Ahmed** (per arXiv HTML) |
| MCP version | "v2.1" / "v1.27" | Date-based spec: **2025-11-25** |
| AWS Bedrock AgentCore GA | "March 2026" | **October 13, 2025** |
| PDF length | 26 pages | **28 pages** (after adding §3.5 benchmarks) |
| Figure 1 | ASCII art in lstlisting | **TikZ colour-coded stack diagram** |
| Platform comparison table | Cramped 6-column tabular | **TikZ colour-coded grid** (5-level scale) |

---

## arXiv Submission Instructions

1. Go to [arxiv.org/submit](https://arxiv.org/submit)
2. Select **cs.AI** as primary subject
3. Cross-list: **cs.DC** (Distributed Computing) and **cs.NI** (Networking and Internet Architecture)
4. Upload the three source files from `arxiv-submission/` — **tex + bib + sty only** (not the PDF; arXiv compiles its own)
5. License: **CC BY 4.0**

**Plain-text abstract for the arXiv submission form:**

> The emergence of autonomous AI agents as first-class participants in digital infrastructure marks a fundamental inflection point in the evolution of the Web. This paper presents a systematic analysis of Agentverse, the agent cloud platform developed by Fetch.ai and operated by the Artificial Superintelligence (ASI) Alliance, as a case study in agent-native infrastructure. We make three principal contributions. First, we conduct a rigorous empirical audit of the Agentverse platform's 204 documented API endpoints, deriving a structured Gap Taxonomy of 62 distinct missing infrastructure capabilities across eight categories: agent memory, observability, security, communication, development lifecycle, data services, economic primitives, and enterprise scale. Second, we propose a seven-layer Agent Cloud Stack — a principled reference architecture for what a fully realised agent-native cloud platform should provide by 2030, grounded in specific identified gaps and analogies from the evolution of general-purpose cloud computing. Third, we characterise five critical evolution paths: from ephemeral key-value storage to a full Agent Memory Cloud; from keyword-based agent discovery to a semantic, trust-weighted Agent DNS; from a single-protocol communication model to a multi-standard agent lingua franca; from single-instance hosting to agent-native orchestration at Kubernetes scale; and from simple token payments to a rich ecosystem of agent economic primitives. We supplement the qualitative audit with live API performance benchmarks (n=10, April 2026) and search-corpus coverage measurements. Together these contributions provide both a diagnostic of the current state of agent infrastructure and a technically grounded vision for the agent cloud by 2030.

---

## Citation

```bibtex
@misc{dey2026agenticweb,
  author       = {Robin Dey and Panyanon Viradecha},
  title        = {Infrastructure for the Agentic Web: Gap Analysis and Architecture
                  from the Agentverse Platform},
  year         = {2026},
  month        = {April},
  howpublished = {arXiv preprint cs.AI},
  url          = {https://github.com/web3guru888/agentverse-2030-paper}
}
```

---

## Related Work

- **Chan et al. (2025)** — "Infrastructure for AI Agents", TMLR, arXiv:2501.10114
- **Hussein et al. (2025)** — "When Intelligence Overloads Infrastructure", arXiv:2511.07265
- **Hadfield & Koh (2025)** — "An Economy of AI Agents", arXiv:2509.01063
- **Zep AI (2025)** — "Zep: A Temporal Knowledge Graph Architecture", arXiv:2501.13956
- **Garzon et al. (2025)** — "AI Agents with DIDs and VCs", arXiv:2511.02841 (accepted ICAART 2026)
- **A2A Protocol v1.0** — Linux Foundation, April 2026, 150+ organizations
- **MCP Specification 2025-11-25** — Anthropic

---

## License

- Paper text: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- Code (if any): [MIT License](LICENSE-CODE)

---

*OpenHub Research · Chiang Mai, Thailand · robin@openhubresearch.org*
