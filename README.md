# Infrastructure for the Agentic Web
## Gap Analysis and Architecture from the Agentverse Platform

**Authors**: Robin Dey and Panyanon Viradecha (OpenHub Research, Chiang Mai, Thailand)  
**Contact**: robin@openhubresearch.org  
**Submitted to**: arXiv cs.AI  
**Date**: April 2026  
**Status**: Submission-ready

---

## Abstract

The emergence of autonomous AI agents as first-class participants in digital infrastructure marks a fundamental inflection point in the evolution of the Web. While significant research effort has been directed at the behaviour and reasoning of individual agents, comparatively little attention has been paid to the *infrastructure* those agents require to operate reliably at scale — the protocols, services, and platforms that mediate their interactions with each other and with the world.

This paper presents a systematic analysis of **Agentverse** — the agent cloud platform developed by Fetch.ai and operated by the Artificial Superintelligence (ASI) Alliance (currently comprising Fetch.ai, SingularityNET, and CUDOS) — as a case study in agent-native infrastructure.

Three principal contributions:

1. **Gap Taxonomy** — A rigorous empirical audit of 204 documented API endpoints, yielding a structured taxonomy of **52 missing infrastructure capabilities** across 8 categories
2. **Seven-Layer Agent Cloud Stack** — A principled reference architecture for what a fully realised agent-native cloud platform should provide by 2030
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
| **Total** | **52** | |

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
│   ├── agentverse-paper.tex    # Full paper (LaTeX, JMLR preprint style)
│   ├── agentverse-paper.bib    # Bibliography (fact-checked, 40 entries)
│   ├── agentverse-paper.pdf    # Compiled PDF (26 pages)
│   └── jmlr2e.sty              # JMLR style file
├── arxiv-submission/           # arXiv upload bundle
│   ├── agentverse-paper.tex
│   ├── agentverse-paper.bib
│   └── jmlr2e.sty
├── figures/                    # Placeholder for diagrams (future)
├── Makefile                    # Build system
└── README.md
```

---

## Building the PDF

Requires a standard TeX Live installation:

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

## Fact-Check Status

All 25 claims in the paper have been independently verified against primary sources (2026-04-24).

**Key corrections applied vs. first draft:**

| Issue | Original (Wrong) | Corrected |
|-------|-----------------|-----------|
| ASI Alliance composition | "Fetch.ai, SingularityNET, Ocean Protocol" | Fetch.ai + SingularityNET + CUDOS (Ocean departed Oct 2025) |
| Agentverse agent count | "340 agents" | 36,000+ (Almanac, Q1 2026); 2M+ in broader ecosystem |
| Author — arXiv:2511.07265 | "Kapoor et al." | **Hussein et al.** |
| Author — arXiv:2509.01063 | "Horton et al." | **Hadfield & Koh** |
| Zep paper arXiv # | arXiv:2602.05665 | **arXiv:2501.13956** |
| MCP version | "v2.1" / "v1.27" | Date-based: **2025-11-25** (no semantic versions) |
| AWS Bedrock AgentCore GA | "March 2026" | **October 13, 2025** |
| Entra Agent ID launch | "RSAC 2026" | **May 2025** (expanded at Ignite 2025 + RSAC 2026) |
| Google rebrand | "Agentspace" | **Gemini Enterprise Agent Platform** (Cloud Next April 2026) |

Full fact-check report: `/shared/kb/fetch-agi-reports/agentverse-paper-factcheck.md`

---

## arXiv Submission Instructions

1. Go to [arxiv.org/submit](https://arxiv.org/submit)
2. Select **cs.AI** as primary subject
3. Secondary: **cs.NI** (Networking and Internet Architecture), **cs.DC** (Distributed, Parallel, and Cluster Computing)
4. Upload the `.tar.gz` from `make arxiv`, or upload the three files from `arxiv-submission/` manually
5. License: **CC BY 4.0**

**Abstract for submission** (plain text, no LaTeX):

> The emergence of autonomous AI agents as first-class participants in digital infrastructure marks a fundamental inflection point in the evolution of the Web. This paper presents a systematic analysis of Agentverse, the agent cloud platform developed by Fetch.ai and operated by the Artificial Superintelligence (ASI) Alliance, as a case study in agent-native infrastructure. We make three principal contributions. First, we conduct a rigorous empirical audit of the Agentverse platform's 204 documented API endpoints, deriving a structured Gap Taxonomy of 52 missing infrastructure capabilities across eight categories: agent memory, observability, security, communication, development lifecycle, data services, economic primitives, and enterprise scale. Second, we propose a seven-layer Agent Cloud Stack — a principled reference architecture for what a fully realised agent-native cloud platform should provide by 2030, grounded in specific identified gaps and analogies from the evolution of general-purpose cloud computing. Third, we characterise five critical evolution paths: from ephemeral key-value storage to a full Agent Memory Cloud; from keyword-based agent discovery to a semantic, trust-weighted Agent DNS; from a single-protocol communication model to a multi-standard agent lingua franca; from single-instance hosting to agent-native orchestration at Kubernetes scale; and from simple token payments to a rich ecosystem of agent economic primitives. Together these contributions provide both a diagnostic of the current state of agent infrastructure and a technically grounded vision for the agent cloud by 2030.

---

## Citation

```bibtex
@misc{dey2026agenticweb,
  author    = {Robin Dey and Panyanon Viradecha},
  title     = {Infrastructure for the Agentic Web: Gap Analysis and Architecture
               from the Agentverse Platform},
  year      = {2026},
  month     = {April},
  howpublished = {arXiv preprint, cs.AI},
  url       = {https://github.com/web3guru888/agentverse-2030-paper}
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
