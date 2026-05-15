---
name: langchain
description: LangChain framework for building LLM-powered applications
---

### Core Concepts
- **Chains**: Link multiple LLM calls/utilities sequentially (LLMChain, SimpleSequentialChain)
- **Agents**: Autonomous loop that decides actions using tools (ReAct, OpenAI Functions, Tool Calling)
- **RAG**: Retrieval Augmented Generation - index documents, retrieve chunks, generate answers
- **LangGraph**: Graph-based state machine for complex agent workflows (cycles, branching)
- **Prompt Templates**: Parameterized strings with dynamic variable injection
- **Memory**: Conversation buffer, summary memory, vector store memory, entity memory

### Common Patterns
- `ChatPromptTemplate.from_messages([system, human])` for structured prompts
- `create_retrieval_chain(retriever, document_chain)` for RAG pipelines
- `create_openai_tools_agent(llm, tools, prompt)` for tool-calling agents
- `StateGraph` with nodes/edges for LangGraph workflows
- Streaming via `.stream()` or `.astream()` on chains/runnables
- Model I/O: `BaseMessage` types (HumanMessage, AIMessage, SystemMessage)

### Best Practices
- Use LCEL (LangChain Expression Language) `|` composition over legacy Chain classes
- Implement `RunnablePassthrough` for data flow transparency
- Enable LangSmith tracing in production for observability
- Prefer `ChatOpenAI` over legacy `OpenAI` for chat models
- Batch vector store operations to avoid rate limits
