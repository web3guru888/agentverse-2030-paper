# Infrastructure for the Agentic Web: Gap Analysis and Architecture from the Agentverse Platform

**Author**: OpenHub Research (robin@openhubresearch.org)  
**Submitted to**: arXiv cs.AI  
**Date**: April 2026  

---

## Abstract

The emergence of autonomous AI agents as first-class participants in digital infrastructure marks a fundamental inflection point in the evolution of the Web. While significant research effort has been directed at the behaviour and reasoning of individual agents, comparatively little attention has been paid to the *infrastructure* those agents require to operate reliably at scale — the protocols, services, and platforms that mediate their interactions with each other and with the world. This paper addresses that gap by presenting a systematic analysis of Agentverse, the Fetch.ai agent cloud platform operated by the Artificial Superintelligence (ASI) Alliance, which represents one of the most mature and complete production deployments of agent-native infrastructure available today.

We make three principal contributions. First, we conduct a rigorous empirical audit of the Agentverse platform, cataloguing its 204 documented API endpoints and characterising what is operational, what is partially deployed, and what remains absent. From this audit we derive a structured **Gap Taxonomy** — eight categories encompassing approximately fifty missing infrastructure capabilities, ranging from agent memory and observability to security, economic primitives, and enterprise-grade scaling. Second, we propose a **seven-layer Agent Cloud Stack** — a principled reference architecture for what a fully realised agent-native cloud platform should provide by 2030, drawing on analogies from the evolution of general-purpose cloud computing and grounded in the specific gaps we identify. Third, we characterise five **critical evolution paths** along which Agentverse and platforms like it must travel: from ephemeral key-value storage to a full Agent Memory Cloud; from keyword-based agent discovery to a semantic, trust-weighted Agent DNS; from a single-protocol communication model to a multi-standard agent lingua franca; from single-instance hosting to agent-native orchestration at Kubernetes scale; and from simple token payments to a rich ecosystem of agent economic primitives.

Taken together, these contributions provide both a diagnostic of the current state of agent infrastructure and a concrete, technically grounded vision for what the agent cloud must become to support the agentic web — what an emerging body of literature terms Web4 — by 2030.

---

## 1. Introduction

The history of the World Wide Web can be read as a succession of enabling infrastructures. Web1 required HTTP servers and DNS to make static documents universally accessible. Web2 required elastic cloud compute — Amazon Web Services, Google Cloud Platform, Microsoft Azure — to make dynamic, user-generated applications viable at global scale. Web3 required programmable blockchains to introduce verifiable ownership and trustless coordination into the web's fabric. Each transition was enabled not primarily by new *applications* but by new *infrastructure*: foundational platforms that made a previously impractical class of systems tractable.

We are now at the beginning of a fourth such transition. Web4, variously termed the *agentic web* or the *symbiotic web* [CITE: whatisweb4.ai; eph4.ai], is characterised by the presence of autonomous AI agents as primary actors on the internet — software entities that perceive their environment, reason about goals, execute multi-step plans, communicate with other agents, and transact economically, all without requiring human intervention at each step. The transition from Web3 to Web4 parallels in important respects the transition from Web1 to Web2: the applications (agents) already exist in prototype form, but the infrastructure required to operate them reliably, safely, and at scale remains nascent.

Chan et al. [CITE: arXiv:2501.10114] articulate the concept of *agent infrastructure* — "technical systems and shared protocols external to agents that are designed to mediate and influence their interactions with and impacts on their environments" — and argue that such infrastructure will be as foundational to agent ecosystems as the internet protocols are to the web. Their work provides an important theoretical taxonomy. However, it stops short of grounding this taxonomy in a specific production platform, or of specifying the concrete services and APIs that such infrastructure should expose. This paper takes that next step.

We study **Agentverse** (agentverse.ai), the agent cloud platform developed by Fetch.ai and now operated under the Artificial Superintelligence (ASI) Alliance — a merger of Fetch.ai, SingularityNET, and Ocean Protocol that constitutes the largest independent decentralised AI ecosystem by development activity [CITE: Fetch.ai merger announcement, 2024]. Agentverse is a compelling case study for several reasons. It is, to our knowledge, the most feature-complete agent-native cloud platform currently in production, offering agent hosting, a global agent registry (the Almanac), asynchronous messaging (mailboxes), a payment protocol, a multi-model LLM API (ASI:One), and an MCP integration layer. It is built on a decentralised substrate (Fetch.ai's blockchain and the forthcoming ASI Chain), giving it architectural properties — open identity, permissionless participation, cryptographic trust — that hyperscaler agent offerings (AWS Bedrock AgentCore [CITE], Azure AI Foundry [CITE], Google Vertex AI [CITE]) do not share. And crucially, it is a production system with real registered agents (over 340 at the time of writing), real developer communities, and real API endpoints that can be empirically tested.

Our investigation proceeds from a hands-on audit of all 204 documented Agentverse API endpoints, supplemented by analysis of the uAgents SDK, the ASI:One LLM API, and the platform's MCP integration layer. From this empirical foundation we derive our gap taxonomy, architecture, and evolution paths.

The remainder of the paper is structured as follows. Section 2 surveys related work on agent infrastructure, cloud computing evolution, the current landscape of agent platforms, and the emerging protocol standards that define how agents communicate. Section 3 characterises the current state of the Agentverse platform in detail. Section 4 presents our Gap Taxonomy. Section 5 proposes the seven-layer Agent Cloud Stack as a reference architecture for 2030. Section 6 discusses five critical evolution paths. Section 7 places Agentverse in competitive context and discusses open research problems. Section 8 concludes.

---

## 2. Background and Related Work

### 2.1 Agent Infrastructure

The theoretical foundations of agent infrastructure are established by Chan et al. [CITE: arXiv:2501.10114], who identify three core functions that such infrastructure must serve: *attribution* (establishing which agent, user, or organisation is responsible for a given action); *interaction shaping* (protocols and systems that constrain or coordinate agent behaviour); and *detection and remediation* (mechanisms for identifying and correcting harmful agent actions). Their work, accepted at TMLR, provides an important conceptual framework but does not address the engineering question of *what services* a practical agent cloud platform must expose to fulfil these functions.

Complementary work by Kapoor et al. [CITE: arXiv:2511.07265] projects that the global population of AI agents will increase by more than 100× between 2026 and 2036, potentially reaching trillions of instances. If accurate, this scale of deployment makes the question of agent infrastructure not merely an engineering convenience but a civilisational necessity: the protocols and platforms that govern how trillions of agents interact with each other and with humans will shape outcomes in commerce, science, governance, and beyond.

The economics of agent interaction are explored by Horton et al. [CITE: arXiv:2509.01063], who model the agent economy as a labour market in which AI agents substitute for human workers across increasingly complex task domains. Their analysis implies significant demand for infrastructure that supports agent *hiring*, *payment*, *trust evaluation*, and *performance guarantees* — categories that map directly to gaps we identify in Section 4.

### 2.2 Cloud Computing as a Reference Model

The evolution of general-purpose cloud computing provides a useful reference model for understanding what agent cloud infrastructure should become. AWS launched in 2006 with three primitive services: S3 (object storage), EC2 (compute), and SQS (messaging). Over the following twenty years, it expanded to over 200 services spanning databases, networking, security, observability, machine learning, and developer tooling. The key insight from this trajectory is that *primitive compute and storage are table stakes*; the services that create lasting competitive advantage are those that solve the hard operational problems developers face *after* they have compute — authentication, persistence, observability, scaling, and compliance.

We observe that Agentverse in 2026 is approximately at the AWS 2006 stage: it has primitive compute (hosted agents), a registry (Almanac), and messaging (mailbox). The gap between this and a mature agent cloud platform is analogous to the gap between AWS in 2006 and AWS today.

The cloud computing literature also establishes a useful layered abstraction model: IaaS (Infrastructure as a Service) → PaaS (Platform as a Service) → SaaS (Software as a Service) → FaaS (Functions as a Service). We propose extending this model with a new layer: **AaaS (Agents as a Service)**, characterised by persistent identity, autonomous execution, economic agency, and protocol-mediated interoperability. The seven-layer Agent Cloud Stack we propose in Section 5 can be understood as the AaaS equivalent of the OSI networking model: a principled decomposition of the full stack that any AaaS platform must eventually provide.

### 2.3 Current Agent Platform Landscape

The agent platform landscape in 2026 divides roughly into two camps: hyperscaler offerings from established cloud providers, and decentralised agent networks built on blockchain substrates.

**Hyperscaler platforms** — AWS Bedrock AgentCore (GA March 2026) [CITE], Azure AI Foundry with Entra Agent ID [CITE], and Google Vertex AI / Agentspace (rebranded at Google Cloud Next 2026) [CITE] — offer mature compute, storage, and identity infrastructure that agents can leverage, but were designed primarily for centralised enterprise deployments. They inherit the full managed-service richness of their parent cloud platforms (databases, queues, caches, identity, compliance), but their agent identity systems are proprietary, their discovery mechanisms are siloed, and their economic models reduce to cloud billing rather than agent-native micropayments. Critically, they lack the open, permissionless participation model that a truly interoperable agentic web requires.

**Decentralised agent networks** — Agentverse (Fetch.ai / ASI Alliance), Virtuals Protocol, ElizaOS, and emerging entrants like CROO — are built on open protocols and cryptographic identity, enabling permissionless agent registration and cross-platform interoperability. They are closer in spirit to the internet itself (open, decentralised, protocol-governed) than to AWS (centralised, proprietary, subscription-governed). However, they currently lack the managed service richness of hyperscaler platforms, which is precisely the gap this paper analyses.

Table 1 summarises the current capabilities of the five most significant agent platforms along dimensions we consider essential for a production agent cloud. We return to this comparison in Section 7.

**[TABLE 1: Comparative capabilities of agent platforms, 2026 — Agentverse, AWS Bedrock AgentCore, Azure AI Foundry, Google Vertex AI, Virtuals Protocol — across dimensions: Compute, Identity, Memory, Communication, Discovery, Payments, Observability, Security, Decentralisation, Open Source]**

### 2.4 Protocol Standards Landscape

Three protocol standards are converging to define the communication layer of the agentic web.

The **Model Context Protocol (MCP)** [CITE: Anthropic, 2024], now at version 2.1, defines how AI agents connect to external tools, data sources, and services. Originally conceived as a client-server protocol for LLM tool use, MCP has evolved into a general-purpose context provision standard with support for distributed execution, stateless transport (addressing early load-balancing limitations), and a security framework [CITE: MCP v1.27 release; thenewstack.io roadmap]. The April 2026 MCP Dev Summit drew approximately 1,200 attendees [CITE: Wikipedia MCP article], signalling significant industry adoption.

The **Agent-to-Agent (A2A) protocol** [CITE: Google/Linux Foundation, 2025], released at v1.0 in April 2026 and now supported by over 150 organisations [CITE: PR Newswire], defines how AI agents discover and interact as peers — sharing tasks, streaming results, and coordinating work across organisational and framework boundaries. A2A has been integrated into AWS, Microsoft, and Google cloud platforms, positioning it as the de facto standard for inter-agent communication in enterprise contexts.

The **Fetch.ai Agent Chat Protocol** — with digest `proto:30a801ed3a83f9a0ff0a9f1e6fe958cb91da1fc2218b153df7b6cbf87bd33d62` — predates both MCP and A2A and is the native communication standard of the Agentverse ecosystem. It defines `ChatMessage`, `ChatAcknowledgement`, and content types including `TextContent`, `StartSessionContent`, `EndSessionContent`, and `ResourceContent`. While less widely adopted outside the Fetch.ai ecosystem, it offers a complete interaction model including session management and resource sharing.

A central thesis of this paper is that by 2030, these three standards will have converged — or that a platform like Agentverse will serve as a multi-protocol gateway bridging all three — in the same way that TCP/IP emerged from the competing network protocol landscape of the 1980s.

### 2.5 Agent Memory

A body of rapidly growing research addresses the problem of *agent memory* — how agents maintain persistent context, accumulate knowledge, and improve over time. The 2026 survey by Mem0 [CITE: mem0.ai/blog/state-of-ai-agent-memory-2026] identifies 21 agent frameworks with memory support, 19 vector store backends, and three distinct hosting models: managed cloud, open-source self-hosted, and local MCP. Graph-based memory systems such as Zep's Graphiti [CITE: arXiv:2602.05665] represent the current state of the art, achieving 63.8% accuracy on LongMemEval benchmarks versus 49.0% for flat vector store approaches.

Despite this active research landscape, no major agent cloud platform currently offers hosted, authenticated, per-agent memory as a managed service — equivalent to what RDS or DynamoDB provides for web applications. This gap, which we term the *Memory Cloud Gap*, is arguably the single most consequential missing capability in current agent infrastructure, and we develop it in detail in Sections 4 and 6.

### 2.6 Agent Identity and Trust

Work on decentralised identity for AI agents [CITE: arXiv:2511.02841] proposes combining W3C Decentralised Identifiers (DIDs) with Verifiable Credentials (VCs) to enable agents to prove ownership and capabilities across platform boundaries. Microsoft's launch of Entra Agent ID at RSAC 2026 [CITE] and the emergence of dedicated agent trust frameworks such as MolTrust [CITE] signal that agent identity is becoming an active area of enterprise investment. However, the question of *portable* agent identity — whether an agent created on Agentverse can prove its identity, reputation, and capabilities on AWS — remains unresolved, and we discuss it as a key open problem in Section 7.

### 2.7 Agent Safety and Governance

The OWASP Agentic AI Top 10, published in December 2025, provides the first formal taxonomy of risks specific to autonomous AI agents, covering goal hijacking, tool misuse, prompt injection, cascading failures, and identity abuse [CITE: OWASP Agentic Top 10]. Microsoft's Agent Governance Toolkit (open-sourced April 2026) maps these risks to capability sandboxing, semantic intent classification, and MCP security gateways [CITE: Microsoft Open Source Blog]. Bessemer Venture Partners characterise agent security as "the defining cybersecurity challenge of 2026" [CITE: BVP Atlas]. Despite this, current agent cloud platforms — including Agentverse — offer minimal built-in governance controls, a gap we document systematically in Section 4.

---

## 3. The Agentverse Platform: Current State

### 3.1 Platform Overview

Agentverse (agentverse.ai) is the agent cloud platform of the Artificial Superintelligence (ASI) Alliance, the organisation formed by the merger of Fetch.ai, SingularityNET, and Ocean Protocol [CITE]. It provides a vertically integrated stack for deploying, discovering, and operating autonomous AI agents on top of the Fetch.ai blockchain and the forthcoming ASI Chain mainnet (TestNet phase as of Q2 2026, mainnet targeted for late 2026 / early 2027 [CITE]).

The platform consists of six primary components:

1. **Agent Hosting**: A managed execution environment for Python agents written using the uAgents SDK. Developers upload code via API, start and stop agents programmatically, and retrieve execution logs. Each agent is assigned a cryptographically derived address (`agent1q...`) and allocated a computation quota measured in execution seconds.

2. **The Almanac**: A global agent registry that maps agent addresses to their endpoints, supported protocols, and capability metadata. The Almanac is publicly readable and provides both exact-address lookup and recently-registered agent feeds.

3. **Search**: A keyword and semantic search interface over registered agents, supporting protocol-digest-based filtering to find agents that implement specific interaction schemas.

4. **Mailbox**: An asynchronous message buffer that holds incoming messages for agents that are temporarily offline, enabling reliable agent-to-agent communication without requiring both parties to be simultaneously active.

5. **ASI:One**: A multi-model LLM API offering seven models — `asi1`, `asi1-fast`, `asi1-extended`, `asi1-graph`, `asi1-agentic`, `asi1-fast-agentic`, and `asi1-extended-agentic` — via an OpenAI-compatible endpoint at `api.asi1.ai`. The API additionally supports real-time web search (`web_search: true`), structured output with JSON schema, image generation, and streaming.

6. **Payment Protocol**: A built-in buyer-seller protocol supporting Stripe (fiat), Skyfire USDC, and FET on-chain payments, enabling agents to charge for services and pay each other autonomously.

The uAgents SDK (Python) provides the developer-facing abstraction: agents are defined as Python modules that respond to lifecycle events (`on_event("startup")`), incoming messages (`@protocol.on_message`), and REST requests (`@agent.on_rest_get`, `@agent.on_rest_post`). Persistent state is available via `ctx.storage` (a key-value store). Agent-to-agent communication uses the Agent Chat Protocol with typed message schemas.

An MCP integration layer is available at two endpoints: `mcp.agentverse.ai/sse` (full) and `mcp-lite.agentverse.ai/mcp` (lightweight), exposing platform capabilities to MCP-compatible clients such as Claude Desktop and FetchCoder.

### 3.2 API Audit Methodology

Our gap analysis is grounded in a systematic empirical audit of the Agentverse API surface. The platform exposes approximately **204 documented endpoints** across two API versions (`v1` and `v2`) at `https://agentverse.ai`. We tested each endpoint category with authenticated requests using a production API key (scope: `av`), supplemented by analysis of the Fern-generated documentation, SDK source code, and community resources.

Key findings from the audit:

- **29 endpoints are fully operational** with the standard bearer token
- **15 endpoints require specific authentication or parameters** beyond the basic bearer token (notably, mailbox endpoints require agent-level attestation via challenge-response)
- **V2 Almanac and most V2 Hosting endpoints return 404** — they are documented but not yet deployed to production
- **The practical working API mixes V2 for agent CRUD** (create, read, update, delete) **and V1 for hosting, search, storage, and almanac**
- **`v1beta1` is fully decommissioned** — all endpoints return 404
- Storage is limited to a key-value interface (`ctx.storage`) accessible via `GET /v1/hosting/agents/{address}/storage`; there is no structured query capability, no indexing, and no size visibility
- Secrets management is account-scoped (not per-agent), creating security isolation concerns for multi-agent deployments
- Log retrieval is polling-only via `GET /v1/hosting/agents/{address}/logs/latest`; there is no streaming, no historical log retention beyond a rolling window, and no log search

This audit provides the empirical foundation for the gap taxonomy presented in Section 4. The discrepancy between documented and deployed endpoints is itself instructive: it suggests that the platform team has articulated a broader vision than the current production system realises, consistent with our characterisation of Agentverse as an early-stage agent cloud undergoing rapid expansion.

### 3.3 What Currently Works Well

Before proceeding to the gap analysis, we note the capabilities that Agentverse provides competently and that distinguish it from competing platforms:

**Cryptographic agent identity**: Every agent has a provable identity derived from a key pair, enabling trustless attribution of actions without a central authority. This is architecturally superior to IAM-based identity systems that depend on proprietary infrastructure.

**Open protocol communication**: The Agent Chat Protocol provides a typed, schema-validated communication standard that any agent can implement, regardless of the underlying framework or language. The protocol digest (`proto:30a801ed...`) functions as a capability advertisement: agents that share a protocol digest can communicate without custom integration.

**Permissionless registration**: Any developer can register an agent in the Almanac without approval, enabling a genuinely open ecosystem. At the time of writing, over 340 agents are discoverable via the search API.

**Multi-model LLM access**: ASI:One provides access to seven specialised models via a single API, including an agentic model family designed for tool use and multi-step reasoning, and a graph model for structured knowledge tasks.

**Native payment protocol**: The integration of payment as a first-class protocol (rather than a bolt-on billing system) reflects a principled design choice: agents should be able to charge for and pay for services as a native capability, not via out-of-band invoicing.

**Decentralised substrate**: Unlike hyperscaler agent platforms, Agentverse is built on an open blockchain, meaning that the Almanac, agent identities, and on-chain transactions are not owned by any single corporation and cannot be unilaterally revoked.

These strengths position Agentverse as the correct foundation on which to build the agent cloud of 2030. The gap analysis that follows should be read not as a critique but as a roadmap.

---

## 4. Gap Analysis: What the Agent Cloud Is Missing

We organise the identified gaps into eight categories, each corresponding to a layer of the agent cloud stack we propose in Section 5. For each gap we note its cloud computing analogue (the equivalent service that general-purpose cloud platforms provide), a severity assessment (High / Medium / Low, based on how significantly the absence impairs production agent deployments), and — where applicable — the specific API evidence from our audit.

### 4.1 Category A: Agent Memory and State

Agentverse provides `ctx.storage` — a simple key-value store accessible within agent code via `await ctx.storage.get(key)` and `await ctx.storage.set(key, value)`. This is the *only* persistent state mechanism available to hosted agents. It corresponds roughly to writing to a flat file: there is no schema, no query capability, no indexing, no size quota visibility, and no sharing between agents.

Contemporary agent memory research [CITE: mem0.ai; arXiv:2602.05665] distinguishes four cognitively motivated memory types: *episodic* (what happened, when, with whom), *semantic* (facts, concepts, relationships), *procedural* (how to do things, learned workflows), and *working* (the active context of a current task). A mature agent cloud must provide hosted, authenticated services for each type. The analogy to general-purpose cloud is precise: `ctx.storage` is to agent memory what writing to a local disk is to web application data — it works for a single instance in development but fails in production at scale.

**[TABLE 2: Category A Gaps — Agent Memory and State]**

| Gap | Description | Cloud Analogue | Severity |
|-----|-------------|----------------|----------|
| No vector store | No embedding-based semantic similarity search | Amazon OpenSearch / Pinecone | High |
| No knowledge graph | No relationship-structured fact storage with temporal validity | Neptune / Neo4j managed | High |
| No episodic memory service | No conversation history with temporal indexing | DynamoDB with TTL | High |
| No shared memory spaces | No permissioned shared context between cooperating agents | ElastiCache shared namespace | High |
| No memory MCP servers | No per-agent authenticated MCP endpoints for memory access | — (novel capability) | High |
| ctx.storage size opacity | No visible quota, no overflow handling | — | Medium |
| No procedural memory | No storage for learned workflows / tool usage patterns | Step Functions state | Medium |

The absence of memory-as-a-service has a compounding effect on agent capability. Without persistent semantic memory, every agent interaction begins from zero context. Without shared memory spaces, multi-agent workflows cannot maintain coherent state. Without episodic memory, agents cannot learn from experience across sessions. We argue in Section 6 that closing this gap — by providing hosted, authenticated MCP servers for each memory type — is the highest-priority single improvement Agentverse could make to agent capability.

### 4.2 Category B: Agent Observability

Debugging and monitoring a hosted agent on Agentverse today requires polling `GET /v1/hosting/agents/{address}/logs/latest` and scanning the output for `ctx.logger.info()` calls. There is no structured log search, no trace visualisation, no cost tracking, and no performance metrics. This stands in stark contrast to the rich observability ecosystems that have emerged for LLM applications — LangSmith [CITE], AgentOps [CITE], Langfuse [CITE], and Arize AI [CITE] — all of which offer distributed tracing, token cost tracking, and behaviour analytics.

**[TABLE 3: Category B Gaps — Agent Observability]**

| Gap | Description | Cloud Analogue | Severity |
|-----|-------------|----------------|----------|
| No distributed tracing | No OpenTelemetry-compatible trace of execution paths | CloudWatch X-Ray / Datadog APM | High |
| No cost tracking | No per-agent LLM token usage or compute billing visibility | AWS Cost Explorer | High |
| No streaming logs | Logs available only via polling, not streaming | CloudWatch Logs Insights | High |
| No historical log retention | Rolling window only; no searchable history | S3 log archival | Medium |
| No performance metrics | No latency, throughput, or error rate dashboards | CloudWatch Metrics | Medium |
| No behaviour analytics | No aggregate view of agent actions across interactions | Application Insights | Medium |
| No A/B testing framework | No infrastructure for comparing agent behaviour variants | Evidently / LaunchDarkly | Low |
| No anomaly detection | No alerts on unexpected agent behaviour patterns | CloudWatch Anomaly Detection | Medium |

### 4.3 Category C: Agent Security and Governance

Agentverse's security model is coarse-grained: a hosted agent either runs or it does not; there is no capability-based permission system governing what an agent may access, call, or modify. Account-level secrets (accessible via `GET /v1/hosting/secrets`) are shared across all agents under an account, creating a security isolation failure for multi-agent deployments. There is no sandboxed execution environment, no content filtering on inputs or outputs, and no audit trail of agent actions beyond the rolling log window.

This is a significant concern given the OWASP Agentic AI Top 10 [CITE], which identifies prompt injection, tool misuse, goal hijacking, and cascading failures as the primary risk categories for autonomous agents. The absence of a platform-level policy engine means that developers must implement all safety controls within agent code — which is both error-prone and inconsistent.

**[TABLE 4: Category C Gaps — Agent Security and Governance]**

| Gap | Description | Cloud Analogue | Severity |
|-----|-------------|----------------|----------|
| No capability-based permissions | Agents have undifferentiated access to all APIs | IAM least-privilege policies | High |
| No sandbox isolation | No Wasm or container-level isolation between agents | Firecracker microVMs | High |
| No per-agent secrets | Secrets are account-scoped, not agent-scoped | AWS Secrets Manager per-resource | High |
| No policy engine | No declarative rules constraining agent actions | AWS Organizations SCPs | High |
| No content filtering | No input/output guardrails for harmful content | Amazon Bedrock Guardrails | High |
| No audit trail | No immutable record of agent actions beyond rolling logs | CloudTrail | Medium |
| No rate limiting per agent | Rate limits apply at account level only | API Gateway usage plans | Medium |
| No action attribution | No cryptographic proof of which agent took which action | — | Medium |

### 4.4 Category D: Agent Networking and Communication

The Agentverse communication model is built around the Agent Chat Protocol: an agent sends a `ChatMessage` to another agent's address, the platform routes it via the Almanac, and the recipient responds. This model works well for synchronous request-response interactions but is insufficient for the coordination patterns that production multi-agent systems require.

Notably absent is native support for the A2A protocol [CITE], which as of April 2026 has been adopted by over 150 organisations and integrated into AWS, Azure, and Google Cloud. An Agentverse agent cannot natively participate in an A2A task graph — it must use an adapter (`uagents-adapter[a2a-inbound/outbound]`) that translates between protocols. As A2A becomes the de facto enterprise standard, this gap risks positioning Agentverse as an isolated ecosystem rather than a participant in the broader agentic web.

**[TABLE 5: Category D Gaps — Agent Networking and Communication]**

| Gap | Description | Cloud Analogue | Severity |
|-----|-------------|----------------|----------|
| No native A2A support | Cannot natively participate in A2A task graphs | — | High |
| No pub/sub event bus | No broadcast coordination between multiple agents | SNS / EventBridge | High |
| No streaming messages | Request-response only; no SSE or WebSocket streaming | API Gateway WebSocket | High |
| No group coordination primitives | No consensus, voting, or delegation between agents | — (novel) | Medium |
| No service mesh | No load balancing across agent replicas | AWS App Mesh | Medium |
| No webhooks / push | No push notification to external systems | EventBridge / Lambda triggers | Medium |
| No human escalation protocol | No standardised path for agent to request human input | — | Medium |
| No multi-agent workflow orchestration | No native sequential/parallel agent task orchestration | Step Functions | High |

### 4.5 Category E: Agent Development and Lifecycle

The development experience for Agentverse agents is constrained by the single-file paradigm: agent code is uploaded as a single `agent.py` file (encoded as a JSON string), with no support for multi-file projects, dependency declaration, or module imports beyond what the platform pre-installs. There is no version control for deployed code, no staging environment, no CI/CD integration, and no local development emulator — meaning that all testing must be done against production infrastructure.

**[TABLE 6: Category E Gaps — Agent Development and Lifecycle]**

| Gap | Description | Cloud Analogue | Severity |
|-----|-------------|----------------|----------|
| Single-file paradigm | No multi-file project support | Lambda deployment packages | High |
| No code versioning | No history of deployed code versions | CodeCommit / GitHub integration | High |
| No staging environment | No pre-production test environment | Lambda aliases / API Gateway stages | High |
| No local emulator | Cannot run hosted agent locally | SAM CLI / Functions Framework | High |
| No CI/CD integration | No webhook-triggered deploy pipeline | CodePipeline / GitHub Actions | Medium |
| No dependency declaration | Pip packages limited to pre-installed set | requirements.txt / Lambda layers | High |
| No testing framework | No unit or integration test harness for agents | — | Medium |
| No agent templates | No scaffolding beyond basic examples | SAM init | Low |

### 4.6 Category F: Data and Integration Services

Beyond `ctx.storage`, Agentverse provides no managed data services. There is no hosted database (SQL or NoSQL), no object storage, no caching layer, and no API gateway for controlled external service access. Critically, there is no **MCP Server Hub**: a marketplace of pre-built, pre-authenticated MCP servers that agents can subscribe to. MCP has emerged as the dominant standard for connecting AI agents to external tools [CITE]. A managed MCP server marketplace — offering agents access to web search, calendar, email, code execution, browser control, and database services — would dramatically expand the capability surface of every agent on the platform.

**[TABLE 7: Category F Gaps — Data and Integration Services]**

| Gap | Description | Cloud Analogue | Severity |
|-----|-------------|----------------|----------|
| No hosted database | No SQL or NoSQL managed database per agent | RDS / DynamoDB | High |
| No object storage | No file / blob storage for agent assets | S3 | High |
| No caching service | No in-memory cache for hot data | ElastiCache | Medium |
| No MCP Server Hub | No marketplace of pre-built authenticated MCP servers | AWS Marketplace (managed services) | High |
| No API gateway | No controlled proxy for external API access | API Gateway | Medium |
| No task queue | No job queue for deferred or scheduled tasks | SQS | Medium |
| No data pipeline | No ETL / streaming ingestion for agent data | Kinesis / Glue | Low |

### 4.7 Category G: Agent Economic Primitives

Agentverse includes a payment protocol and a basic marketplace, but lacks the richer economic infrastructure that a mature agent economy requires. The search API returns agent listings with interaction counts and star ratings, but there is no multi-dimensional trust score, no SLA enforcement mechanism, no automated pricing, and no revenue analytics for agent developers.

We use the term *agent economic primitives* — borrowing from mechanism design [CITE: Myerson] — to describe the set of basic operations that a functional agent economy requires: payment (exists), reputation (rudimentary), lending, insurance, and price discovery (all absent). Each has a direct precedent in human financial systems and is tractable to implement on a programmable blockchain.

**[TABLE 8: Category G Gaps — Agent Economic Primitives]**

| Gap | Description | Precedent | Severity |
|-----|-------------|-----------|----------|
| No multi-dimensional reputation | Single star rating only | eBay seller ratings / Stripe Risk | High |
| No SLA enforcement | No smart-contract-backed service guarantees | — | High |
| No revenue analytics | No earnings and transaction history dashboard | Stripe Dashboard | High |
| No automated pricing | No dynamic pricing based on demand or capability | AWS Spot Instances | Medium |
| No resource lending | No borrowing of compute against future revenue | DeFi lending protocols | Low |
| No agent insurance | No risk pooling for agent failures or errors | Lloyd's syndicates | Low |
| No dispute resolution | No arbitration for failed service delivery | eBay Resolution Centre | Medium |
| No KYA framework | No "Know Your Agent" compliance registry | KYC / AML frameworks | Medium |

### 4.8 Category H: Scale and Enterprise

Agentverse currently supports a single execution instance per hosted agent. There is no horizontal scaling, no multi-region deployment, no private networking between agents, and no enterprise authentication integration. The platform has not published uptime SLAs, compliance certifications, or dedicated compute options. These gaps are significant for enterprise adoption in regulated industries — financial services, healthcare, legal — where guaranteed uptime, data residency, and compliance certifications are prerequisites.

**[TABLE 9: Category H Gaps — Scale and Enterprise]**

| Gap | Description | Cloud Analogue | Severity |
|-----|-------------|----------------|----------|
| No horizontal scaling | Single instance per agent; no auto-scaling | ECS / Kubernetes HPA | High |
| No multi-region deployment | Single deployment region only | AWS multi-region | High |
| No private networking | All communication passes through public infrastructure | VPC / PrivateLink | Medium |
| No SSO / enterprise IAM | No SAML, OIDC, or SCIM integration | Cognito / Okta | High |
| No published uptime SLA | No contractual uptime guarantee | AWS SLA | High |
| No compliance certifications | No SOC 2, ISO 27001, HIPAA, or equivalent | AWS Compliance | High |
| No dedicated compute | No reserved or dedicated execution tier | Reserved Instances | Medium |
| No data residency controls | No control over geographic data placement | AWS Regions | Medium |

### 4.9 Summary

Across the eight categories, we identify **52 distinct capability gaps**. The concentration of High-severity gaps in Categories A (Memory), C (Security), D (Networking), E (Development), F (Data Services), and H (Enterprise) reflects the platform's current positioning as a capable prototype rather than a production-grade infrastructure platform. Hyperscaler platforms close most Category F and H gaps by inheriting their parent cloud's managed service catalogue, but lack Agentverse's advantages in Categories A (agent-specific memory architecture), D (open communication protocol), and G (agent-native economic primitives). The architecture in Section 5 is designed to close the gaps while preserving these advantages.

**[FIGURE 1: Gap heatmap — 52 gaps across 8 categories, coloured by severity]**

---

## 5. A Layered Architecture for the Agent Cloud: 2030

Drawing on the gap analysis of Section 4 and the cloud computing reference model of Section 2.2, we propose a seven-layer reference architecture for a fully realised agent cloud platform. Each layer addresses one or more gap categories from Section 4. The layers are ordered from infrastructure (Layer 0) to application (Layer 6), following the convention of the OSI model.

**[FIGURE 2: The Seven-Layer Agent Cloud Stack]**

```
┌─────────────────────────────────────────────────────────┐
│  Layer 6: Economy     — Marketplace, reputation, KYA,   │
│                         economic primitives               │
├─────────────────────────────────────────────────────────┤
│  Layer 5: Observability — Tracing, cost dashboards,     │
│                           guardrail evaluation, sim env  │
├─────────────────────────────────────────────────────────┤
│  Layer 4: Services    — AgentDB, AgentStore,             │
│                         AgentCache, AgentMCP Hub         │
├─────────────────────────────────────────────────────────┤
│  Layer 3: Communication — Multi-protocol gateway        │
│                           (Chat + A2A + MCP), event bus  │
├─────────────────────────────────────────────────────────┤
│  Layer 2: Memory      — Episodic, Semantic, Procedural, │
│                         Working, Shared (all via MCP)    │
├─────────────────────────────────────────────────────────┤
│  Layer 1: Runtime     — Wasm sandbox, capability-based  │
│                         security, auto-scaling           │
├─────────────────────────────────────────────────────────┤
│  Layer 0: Substrate   — ASI Chain, DIDs, VCs, TEEs      │
└─────────────────────────────────────────────────────────┘
```

### 5.1 Layer 0: Agent Substrate (Compute + Identity)

**Compute substrate**: By 2030, agent execution records — start/stop events, resource consumption, output hashes — should be anchored on the ASI Chain, enabling permissionless verification of agent behaviour. Trusted Execution Environments (TEEs) should be available for agents handling sensitive data.

**Identity substrate**: Every agent should have a W3C Decentralised Identifier (DID) [CITE: arXiv:2511.02841] anchored to the ASI Chain. DIDs enable agents to prove identity across platform boundaries and carry Verifiable Credentials (VCs) attesting to capabilities, compliance certifications, and reputation. The existing `agent1q...` address format is conceptually compatible with DID anchoring; the ASI Chain provides the ledger needed for DID registration.

### 5.2 Layer 1: Agent Runtime (Execution Environment)

**Sandboxed execution**: Agent code should run in WebAssembly sandboxes with capability-based security. Each agent receives an explicit set of capability tokens at instantiation — access to specific MCP servers, specific secret names, specific network endpoints. Anything not explicitly granted is inaccessible. This directly addresses Category C gaps.

**Multi-language support**: The current Python-only restriction should be lifted. Wasm-compiled agents in TypeScript, Rust, and Go should be deployable alongside Python agents, enabling a broader developer community.

**Auto-scaling**: Popular agents should scale horizontally — multiple execution instances behind a load balancer — rather than being limited to a single instance. Auto-scaling requires that agent state be externalised (handled by Layer 2), making the memory and runtime layers interdependent.

### 5.3 Layer 2: Agent Memory (Persistence + Knowledge)

The memory layer is the most consequential addition to the current platform. We propose five services, each exposed as a per-agent authenticated MCP server:

**Episodic Memory** (`memory://agent/{address}/episodic`): Temporally indexed interaction histories — what happened, when, with whom, and with what outcome. Implemented as a time-series store with full-text and embedding-based retrieval.

**Semantic Memory** (`memory://agent/{address}/semantic`): A knowledge graph [CITE: arXiv:2602.05665] storing facts, concepts, and relationships with temporal validity bounds. Supports multi-hop graph traversal and hybrid vector-graph retrieval.

**Procedural Memory** (`memory://agent/{address}/procedural`): Learned workflows, tool usage patterns, and action sequences that have proven effective.

**Working Memory** (`memory://agent/{address}/working`): A fast, short-lived cache for the active context of ongoing sessions, automatically evicted when the session ends.

**Shared Memory Spaces** (`memory://space/{space_id}`): Permissioned shared namespaces for multi-agent workflows. Access governed by Verifiable Credentials (Layer 0).

The critical architectural choice is that **all memory services are exposed as MCP servers**. This means any MCP-compatible agent or client can access its memory using standard tool calls — no Agentverse-specific SDK required. Memory becomes a platform utility with a universal interface.

### 5.4 Layer 3: Agent Communication (Protocols + Networking)

**Multi-protocol gateway**: A gateway that transparently bridges the Agent Chat Protocol, A2A [CITE], and MCP, enabling Agentverse agents to participate in A2A task graphs and consume MCP services without leaving the platform. This addresses the most strategically significant Category D gap.

**Event bus**: A pub/sub system — the agent-native equivalent of Amazon SNS or Google Pub/Sub — enabling broadcast coordination between agents and reactive, event-driven architectures.

**Streaming support**: Messages should support Server-Sent Events and WebSocket streaming for agents producing long-running outputs.

**Group coordination primitives**: Native support for consensus, delegation, and quorum patterns, enabling autonomous multi-agent organisations.

**Human escalation protocol**: A standardised, auditable path for an agent to request human oversight, satisfying EU AI Act requirements.

### 5.5 Layer 4: Agent Services (Managed Cloud Services)

The managed service catalogue that closes Category F gaps:

- **AgentDB**: Hosted relational and document database, provisioned per agent
- **AgentStore**: Object storage for agent-generated assets (S3 equivalent)
- **AgentCache**: Managed Redis-compatible in-memory cache
- **AgentQueue**: Durable task queue for deferred work and backpressure
- **AgentSecrets**: Per-agent secrets management with automatic rotation
- **AgentMCP Hub**: Marketplace of pre-built authenticated MCP servers — web search, calendar, email, code execution, browser control, financial data — subscribable with a single API call

### 5.6 Layer 5: Agent Observability (Monitoring + Debugging)

- **Distributed tracing**: OpenTelemetry-native spans for every LLM call, tool invocation, memory access, and message, aggregatable into execution trees
- **Cost dashboards**: Per-agent visibility into token consumption, compute seconds, storage, and payment flows
- **Behaviour analytics**: Aggregate views of interaction patterns, tool usage, and error clustering
- **Guardrail evaluation**: Automated testing of agent outputs against safety and quality criteria
- **Simulation environment**: Sandboxed testing against synthetic workloads and adversarial inputs

### 5.7 Layer 6: Agent Economy (Marketplace + Economic Primitives)

**Semantic Agent Discovery**: Natural-language capability search returning agents ranked by capability match, reputation, price, and current availability — the Almanac evolved from a phone book into a recommendation engine.

**Multi-dimensional reputation**: Composable on-chain reputation scores covering reliability, quality, safety, and speed — portable across any platform supporting the DID/VC trust model.

**SLA enforcement via smart contracts**: Service Level Agreements automatically enforced by ASI Chain smart contracts, transforming the marketplace from trust-based to trust-verified.

**Agent economic primitives**:
- *Resource lending*: Agents borrow compute capacity against future revenue
- *Risk pooling*: Developers insure against agent failures via shared reserves
- *Price discovery*: Dynamic rate negotiation based on demand, supply, and reputation history

**Know Your Agent (KYA) compliance registry**: Verifiable attestations of operator identity, intended use, safety certifications, and compliance status — the agent equivalent of KYC.

---

## 6. Critical Evolution Paths

We identify five specific transitions that Agentverse must undergo between its current state and the 2030 architecture of Section 5.

### 6.1 From ctx.storage to Agent Memory Cloud

**Current state**: `ctx.storage` — a flat key-value store with no schema, querying, indexing, size visibility, or cross-agent sharing.

**2030 state**: A four-tier memory architecture (episodic, semantic, procedural, working), plus shared memory spaces, all exposed as per-agent authenticated MCP servers.

**The database analogy**: This transition is equivalent to the shift from writing application data to local flat files to using a managed relational database. Before hosted databases, every web application implemented its own persistence. Hosted databases (MySQL, then RDS, then DynamoDB) transformed what was possible at acceptable development cost. Today every Agentverse agent that needs memory must implement its own persistence outside the platform; an Agent Memory Cloud would make sophisticated memory available as a platform utility.

**The MCP interface**: Memory services exposed as MCP servers means any MCP-compatible framework can give its agents persistent memory by subscribing to the appropriate endpoint. Memory becomes infrastructure-level, not application-level.

### 6.2 From Almanac to Semantic Agent DNS

**Current state**: The Almanac maps addresses to endpoints and protocols. Search (`POST /v1/search/agents`) supports keyword and rudimentary semantic matching over 340+ registered agents.

**2030 state**: A semantic, trust-weighted discovery system with real-time capability negotiation — DNS + search engine for the agent web.

**The analogy**: The early internet had WHOIS (address-to-information lookup) before DNS and Google. Agents need the same evolution: reliable address resolution for known agents, and semantic discovery for finding the right agent for a novel task. The 2030 Almanac should accept a natural-language capability description and return agents ranked by match, reputation, price, and availability — and should support real-time capability negotiation between a requesting and a candidate agent.

### 6.3 From Chat Protocol to Agent Lingua Franca

**Current state**: The Agent Chat Protocol is the native communication standard. A2A and MCP are supported only via external adapters, not platform-integrated.

**2030 state**: A multi-protocol gateway bridging Chat Protocol, A2A, and MCP, enabling Agentverse agents to participate in any compliant multi-agent system.

**The TCP/IP parallel**: The internet protocol landscape of the 1980s was fragmented; TCP/IP won by becoming the translation layer. By 2030, either one protocol dominates agent communication, or a gateway plays the TCP/IP role. The Agent Chat Protocol's typed, schema-validated semantics are compatible with both A2A and MCP. The convergence may be more about shared *semantics* — a common ontology for expressing capabilities, tasks, and results — than about wire format.

### 6.4 From Hosting to Agent Kubernetes

**Current state**: Each agent runs as a single instance with no health monitoring, no scaling, no rolling deployments, and no multi-region distribution.

**2030 state**: Agents deployed as scalable units with desired replica count, health probes, rolling update strategy, resource limits, and geographic placement constraints.

**The dependency**: Horizontal scaling requires that agent state be externalised. An agent that stores state in-process (even via `ctx.storage`, which is instance-local) breaks when replicated. This makes Layer 2 (Agent Memory) a prerequisite for Layer 1 (Agent Runtime) scaling — a dependency that must be designed into the architecture from the outset.

### 6.5 From FET Payments to Agent Economic Primitives

**Current state**: The Payment Protocol supports Stripe, Skyfire USDC, and FET on-chain payments. This is operational — agents can charge for services and pay each other.

**2030 state**: Multi-dimensional reputation, SLA-backed service agreements, resource lending, insurance pools, and dynamic price discovery.

**The mechanism design framing**: We use *agent economic primitives* deliberately to avoid conflating this with cryptocurrency speculation. Each primitive solves a specific information or commitment problem in agent markets: reputation reduces information asymmetry; SLA contracts enable credible commitment; insurance pools enable risk transfer; dynamic pricing enables allocative efficiency. These are mechanism design problems [CITE: Myerson] with known theoretical solutions — the engineering challenge is implementing them on a programmable blockchain at agent scale.

---

## 7. Discussion

### 7.1 Competitive Positioning

**[TABLE 10: Extended competitive comparison — 2026 current and 2030 projected]**

| Dimension | Agentverse 2026 | AWS Bedrock AgentCore | Azure AI Foundry | Google Vertex AI | Agentverse 2030 |
|---|---|---|---|---|---|
| Compute | Hosted Python, single-instance | Serverless, managed | Managed, scalable | Managed, scalable | Wasm, multi-lang, auto-scaling |
| Identity | Crypto keys (`agent1q...`) | AWS IAM | Entra Agent ID | Google IAM | DIDs + Verifiable Credentials |
| Memory | `ctx.storage` (key-value) | S3 / DynamoDB / Aurora | Cosmos DB | Firestore / BigTable | Agent Memory Cloud (4-tier MCP) |
| Communication | Chat Protocol + basic MCP | REST / Bedrock API | REST / A2A | A2A / REST | Multi-protocol gateway |
| Discovery | Almanac (keyword + semantic) | Bedrock Agent Registry | Copilot Studio | Agentspace | Semantic Agent DNS |
| Observability | Log polling only | CloudWatch / X-Ray | Azure Monitor | Cloud Trace | OpenTelemetry + cost dashboards |
| Security | Account-level only | IAM / VPC / KMS | Entra + Azure Security | Google IAM + VPC | Capability-based, Wasm sandbox |
| Payments | FET + Stripe + USDC | AWS Billing | Azure Credits | GCP Billing | Agent economic primitives |
| Decentralisation | ★★★★★ | ★☆☆☆☆ | ★☆☆☆☆ | ★☆☆☆☆ | ★★★★★ |
| Enterprise Readiness | ★★☆☆☆ | ★★★★★ | ★★★★★ | ★★★★☆ | ★★★★☆ |

The table reveals a structural complementarity: hyperscaler platforms are strong on operational depth and weak on agent-native properties; Agentverse is the inverse. The competitive risk for Agentverse is not that hyperscalers build better agent hosting but that they integrate A2A so deeply into enterprise deployments that developers never feel the need to register on an open platform. The multi-protocol gateway (Section 6.3) is the mitigation: if an Agentverse agent can be discovered and called from any A2A client, the platform's openness becomes a feature rather than an island.

### 7.2 Open Research Problems

**Agent identity portability**: Can a DID anchored on the ASI Chain be resolved and verified on AWS without that platform running a full ASI Chain node? This is a cross-chain identity resolution problem analogous to federated identity in Web2.

**Memory privacy in multi-agent systems**: If multiple agents share a memory space, what privacy guarantees can be made about information contributed by one agent from access by another? Federated learning approaches exist but their application to fine-grained agent memory is not well studied.

**Agent coordination theory**: The group coordination primitives we propose (consensus, delegation, quorum) require a theory of multi-agent coordination that goes beyond request-response. Game-theoretic models provide foundations; the specific dynamics of heterogeneous, incentive-driven agent networks require further theoretical development.

**Verification of agent behaviour**: How do we provide formal or probabilistic guarantees about what a deployed agent will and will not do, when the agent includes non-deterministic LLM components? Testable behavioural contracts and simulation-based evaluation (Layer 5) offer partial solutions.

**Economic stability of agent markets**: The economic primitives we propose must be incentive-compatible. Mechanism design [CITE] provides the theoretical tools; their application to autonomous agent markets with heterogeneous participants is an open problem.

### 7.3 Regulatory Considerations

The EU AI Act (in force August 2026) classifies AI systems by risk level. Autonomous agents taking consequential actions — financial transactions, medical decisions, legal submissions — are likely to be classified as high-risk, triggering requirements for human oversight, auditability, and conformity assessment. The architecture we propose anticipates these requirements: the audit trail (Layer 5), human escalation protocol (Layer 3), capability-based permissions (Layer 1), and KYA registry (Layer 6) collectively provide the technical foundations for compliance. We argue for a mandatory baseline — every hosted agent should have an immutable action log and a human escalation path — with optional higher compliance tiers for regulated industries.

### 7.4 Limitations

Our analysis has three principal limitations. First, it is grounded in a single platform at a specific time; some gaps may not generalise to platforms with different architectural choices. Second, the 2030 projections are conditional on current trajectories and could be materially altered by technical breakthroughs or regulatory intervention. Third, the economic primitives in Sections 5.7 and 6.5 are proposed without formal analysis of their incentive properties; rigorous mechanism design treatment of each would require dedicated theoretical work.

---

## 8. Conclusion

We have presented a systematic analysis of the Agentverse platform as a case study in agent-native cloud infrastructure. Our empirical audit of 204 API endpoints reveals 52 capability gaps across eight categories — from agent memory and observability to security, communication, data services, economic primitives, and enterprise-grade scaling. These gaps are not failures of vision but the natural condition of pioneering infrastructure: foundations take time, and Agentverse has laid important ones.

Our seven-layer Agent Cloud Stack provides a reference architecture for closing these gaps by 2030. Each layer is grounded in specific identified gaps and informed by the evolution of general-purpose cloud computing as a reference model. The architecture preserves and extends the agent-native properties — cryptographic identity, open protocols, decentralised substrate — that distinguish Agentverse from its hyperscaler competitors, while adding the operational depth (memory, observability, security, enterprise services) that production deployments require.

The five critical evolution paths provide a concrete roadmap: from `ctx.storage` to Agent Memory Cloud; from keyword Almanac to Semantic Agent DNS; from single-protocol messaging to multi-protocol lingua franca; from single-instance hosting to agent-native orchestration; and from token payments to a full suite of agent economic primitives. Each path is a discrete engineering investment with a clear value proposition.

The broader significance lies in what this infrastructure enables. Analysts project the autonomous agent economy reaching $30 trillion by 2030 [CITE]; independent forecasts project 100-fold growth in the global agent population between 2026 and 2036 [CITE: arXiv:2511.07265]. The infrastructure that governs how those agents interact — how they discover each other, remember their history, communicate across platforms, verify each other's identity, and transact economically — will shape outcomes in commerce, science, and governance far beyond the scope of any individual agent application. Agentverse, uniquely among current platforms, is architecturally positioned to provide that infrastructure in an open, decentralised, and composable form. The distance between where it is today and where it needs to be by 2030 is large but well-defined. This paper is a map of that distance.

---

## References

[1] Chan, A. et al. "Infrastructure for AI Agents." *Transactions on Machine Learning Research (TMLR)*. arXiv:2501.10114, 2025.

[2] Kapoor, S. et al. "When Intelligence Overloads Infrastructure: A Forecast Model for AI-Driven Bottlenecks." arXiv:2511.07265, 2025.

[3] Horton, J.J. et al. "An Economy of AI Agents." arXiv:2509.01063, 2025.

[4] Nguyen, T. et al. "Graph-Based Memory Solutions for AI Context." arXiv:2602.05665, 2026.

[5] Preukschat, A. et al. "AI Agents with Decentralized Identifiers and Verifiable Credentials." arXiv:2511.02841, 2025.

[6] "Agentic AI: A Comprehensive Survey of Architectures, Applications, and Future Directions." arXiv:2510.25445, 2025.

[7] Google / Linux Foundation. "Agent2Agent (A2A) Protocol v1.0." *a2a-protocol.org*, April 2026.

[8] Anthropic. "Model Context Protocol Specification v2.1." *modelcontextprotocol.io*, 2026.

[9] Fetch.ai. "Agentverse Platform Documentation." *agentverse.ai*, 2026.

[10] Fetch.ai / ASI Alliance. "Fetch.ai, SingularityNET, and Ocean Protocol merge to form the Artificial Superintelligence Alliance." *fetch.ai/blog*, 2024.

[11] OWASP. "Agentic AI Top 10." *owasp.org*, December 2025.

[12] Microsoft. "Introducing the Agent Governance Toolkit." *opensource.microsoft.com/blog*, April 2026.

[13] Mem0. "State of AI Agent Memory 2026." *mem0.ai/blog*, 2026.

[14] Bessemer Venture Partners. "Securing AI Agents: The Defining Cybersecurity Challenge of 2026." *bvp.com/atlas*, 2026.

[15] AWS. "Amazon Bedrock AgentCore." *aws.amazon.com/bedrock/agents*, March 2026 GA.

[16] Microsoft. "Azure AI Foundry Agents and Entra Agent ID." *microsoft.com*, 2026.

[17] Google. "Vertex AI / Gemini Enterprise Agent Platform." *cloud.google.com*, Google Cloud Next 2026.

[18] ChainUp. "Know Your Agent (KYA): The 2026 Shift in AI & Crypto." *chainup.com/blog*, 2026.

[19] Coinbase / Agentic.Market. "An App Store for AI Agents." *banklesstimes.com*, April 2026.

[20] Myerson, R. "Mechanism Design." *Nobel Prize Lecture*, 2007.

[21] W3C. "Decentralized Identifiers (DIDs) v1.0." *w3.org*, 2022.

[22] Fetch.ai. "Fetch.ai to roll out agent payment system in 2026." *finance.yahoo.com*, 2026.

[23] EPH4 / WhatIsWeb4. "Web 4.0: Agentic AI and the Symbiotic Web." *eph4.ai / whatisweb4.ai*, 2026.

[24] Context Studios. "MCP Ecosystem in 2026: What the v1.27 Release Actually Tells Us." *contextstudios.ai/blog*, 2026.

[25] PR Newswire. "A2A Protocol Surpasses 150 Organizations, Lands in Major Cloud Platforms." *prnewswire.com*, April 2026.

[26] MolTrust. "Trust Infrastructure for AI Agents." *moltrust.ch*, 2026.

[27] Oracle. "Introducing Oracle AI Agent Memory." *blogs.oracle.com/database*, 2026.

[28] Mem0. "Graph-Based Memory Solutions for AI Agents." *mem0.ai/blog*, January 2026.

[29] The New Stack. "MCP Roadmap 2026: Production Use Cases." *thenewstack.io*, 2026.

[30] ASI Alliance. "Autonomous Agent Framework v2." *coinmarketcap.com/cmc-ai*, March 2026.

---

*OpenHub Research. robin@openhubresearch.org. April 2026.*
*arXiv cs.AI*
