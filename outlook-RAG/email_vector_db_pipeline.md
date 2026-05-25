# Email Export & Vector Database Pipeline for Outlook Mails

## Overview![[BMAD_OpenClaw_Autonomous_Implementation_Spec]]

This guide covers how to export Outlook PST emails and use them as input for a vector database, enabling semantic search and RAG (Retrieval-Augmented Generation) pipelines.

---

## Step 1: Extract Emails from PST

### Open Source

- **libpst / readpst** (Linux/Mac, or via WSL on Windows) — converts PST to individual `.eml` or `.mbox` files
- **pypff** (Python library) — reads PST/OST files programmatically, good for automation
  - GitHub: https://github.com/libyal/libpff

### Commercial

- **Aspose.Email** — very capable Python library for PST parsing, has a free tier
  - https://products.aspose.com/email/python-net/

---

## Step 2: Parse & Preprocess Emails

- **Python's `email` module** — built-in, parses `.eml` files into structured data (sender, date, subject, body)
- **mailparser** — extracts clean text from raw emails
- Strip HTML, signatures, and quoted reply chains to get clean text chunks

### Example (Python)

```python
import pypff
import email

# Open PST file
pst = pypff.file()
pst.open("path/to/your.pst")

root = pst.get_root_folder()

def extract_messages(folder):
    for msg in folder.sub_messages:
        print(msg.subject, msg.sender_name, msg.plain_text_body)
    for subfolder in folder.sub_folders:
        extract_messages(subfolder)

extract_messages(root)
```

---

## Step 3: Embed & Store in a Vector Database

### Open Source Embedding Models

| Model                                    | Notes                            |
| ---------------------------------------- | -------------------------------- |
| `sentence-transformers/all-MiniLM-L6-v2` | Fast, good quality, runs locally |
| `nomic-embed-text`                       | Better for longer documents      |
| `intfloat/e5-large`                      | High quality, slightly slower    |

### Open Source Vector Databases

| Database     | Notes                                                   |
| ------------ | ------------------------------------------------------- |
| **ChromaDB** | Easiest to get started, runs fully locally              |
| **Qdrant**   | More production-ready, runs locally or as a service     |
| **Weaviate** | Feature-rich, supports hybrid (keyword + vector) search |
| **FAISS**    | Lightweight, no server needed, pure similarity search   |
| **Milvus**   | Scalable, good for large datasets                       |

### Example (Python — embed and store in ChromaDB)

```python
from sentence_transformers import SentenceTransformer
import chromadb

model = SentenceTransformer("all-MiniLM-L6-v2")
client = chromadb.Client()
collection = client.create_collection("emails")

emails = [
    {"id": "1", "subject": "Meeting tomorrow", "body": "Let's meet at 10am..."},
    # ... more emails
]

for email in emails:
    text = f"Subject: {email['subject']}\n\n{email['body']}"
    embedding = model.encode(text).tolist()
    collection.add(
        documents=[text],
        embeddings=[embedding],
        ids=[email["id"]]
    )
```

---

## Step 4: RAG Pipeline

### Recommended Frameworks

- **LlamaIndex** — has native email/PST loaders, connects directly to vector DBs, excellent for this use case
  - https://docs.llamaindex.ai
  - Has a built-in `OutlookLocalMailReader` loader — check docs first before building a custom pipeline
- **LangChain** — very popular, lots of integrations, large community
  - https://python.langchain.com

### LLM Options for RAG

| Option                | Notes                                    |
| --------------------- | ---------------------------------------- |
| **Ollama** (local)    | Run LLMs locally, privacy-friendly, free |
| **OpenAI GPT-4**      | Cloud, high quality, costs money         |
| **Anthropic Claude**  | Cloud, high quality, costs money         |
| **Mistral / LLaMA 3** | Open source, can run locally via Ollama  |

### Example (LlamaIndex RAG)

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.readers.mail import OutlookLocalMailReader

# Load emails from PST
reader = OutlookLocalMailReader()
documents = reader.load_data(pst_path="path/to/your.pst")

# Build index
index = VectorStoreIndex.from_documents(documents)

# Query
query_engine = index.as_query_engine()
response = query_engine.query("Find emails about the project budget")
print(response)
```

---

## Step 5: Search from Within Outlook

This is the most complex part. Three approaches:

### Option A: Outlook Web Add-in (Recommended)

- Build a task pane add-in using HTML/JS/React
- The add-in calls a local REST API (e.g. FastAPI) that queries your vector DB
- Works in Outlook 2019+
- Documentation: https://learn.microsoft.com/en-us/office/dev/add-ins/outlook/

### Option B: COM Add-in

- More powerful, deeper Outlook integration
- Built with .NET (C#) or VBA
- Can interact directly with Outlook objects
- More complex to develop and maintain

### Option C: Separate Local Web App (Simplest)

- Build a simple UI with **Streamlit** or **Gradio**
- Run it locally and keep it open alongside Outlook
- No Outlook integration needed — search results show email metadata to help you find the mail manually

### Example (Streamlit search UI)

```python
import streamlit as st
import chromadb
from sentence_transformers import SentenceTransformer

model = SentenceTransformer("all-MiniLM-L6-v2")
client = chromadb.Client()
collection = client.get_collection("emails")

st.title("Email Search")
query = st.text_input("Search your emails...")

if query:
    embedding = model.encode(query).tolist()
    results = collection.query(query_embeddings=[embedding], n_results=5)
    for doc in results["documents"][0]:
        st.write(doc)
        st.divider()
```

---

## Commercial All-in-One Tools

| Tool                           | Notes                                                                                |
| ------------------------------ | ------------------------------------------------------------------------------------ |
| **Microsoft Copilot for M365** | Does exactly this, but requires M365 subscription and stores data in Microsoft cloud |
| **Glean**                      | Enterprise search with email integration                                             |
| **Guru**                       | Knowledge management with AI search                                                  |
| **Notion AI**                  | Not email-specific but similar RAG concept                                           |

---

## Recommended Open Source Stack

For getting started quickly with full local/private setup:

```
pypff
  → Python email parser
    → sentence-transformers (all-MiniLM-L6-v2)
      → ChromaDB
        → LlamaIndex (RAG)
          → Streamlit (search UI)
```

### Install dependencies

```bash
pip install pypff sentence-transformers chromadb llama-index streamlit
```

---

## Privacy Considerations

- All tools in the recommended stack run **fully locally** — no data leaves your machine
- If using cloud LLMs (OpenAI, Anthropic), email content will be sent to their APIs — consider using local LLMs (Ollama) if emails are confidential
- OST files are account-locked; always work with exported PST files

---

## Useful Links

- libpff/pypff: https://github.com/libyal/libpff
- ChromaDB: https://docs.trychroma.com
- Qdrant: https://qdrant.tech/documentation
- LlamaIndex: https://docs.llamaindex.ai
- LangChain: https://python.langchain.com
- sentence-transformers: https://www.sbert.net
- Ollama (local LLMs): https://ollama.com
- Streamlit: https://streamlit.io
- Outlook Add-ins: https://learn.microsoft.com/en-us/office/dev/add-ins/outlook/
