# Concept: AI-Assisted Document Analysis & Management

**Objective:** Automatic content analysis of a historically grown document store — local folders, network shares, or cloud storage — extraction of standardized metadata using the Open Knowledge Framework (OKF), and construction of an AI rule system for fully automatic filing, retrieval, and lifecycle management of documents.

## 1. Problem Statement & Challenge

Classic Document Management Systems (DMS) or simple automation tools often fail when migrating or structuring existing document collections. Simply reading folder names is not sufficient to capture the implicit, human sorting logic built up over years.

**Core problems at a glance:**

- **Implicit context:** Documents reside in specific folders without the folder name necessarily appearing in the document text (e.g., car insurance policies in a folder called "Private/Auto").
- **Inconsistent naming:** Legacy data rarely follows a uniform naming scheme.
- **Scattered storage:** Documents may live across local drives, NAS shares, cloud storage, or email attachments — with no unified view.
- **Future-proofing:** New documents must be filed in the correct location automatically, based on the learned structure, without manual intervention.
- **Findability:** Without full-text search and metadata, finding a specific document means remembering where you put it years ago.
- **Retention & compliance:** Without lifecycle rules, obsolete documents accumulate indefinitely, and legally required retention periods go untracked.
- **Open-source requirement:** The solution should be modular, extensible, and independent of proprietary monoliths — ideally with support for local Large Language Models (LLMs).

## 2. Solution Strategy: The OKF Principle

The strategy is based on the semantic data format of Google's **Open Knowledge Framework (OKF)**. Rather than adopting any specific vendor infrastructure, only the standardized, open JSON metadata schemas are used. This ensures maximum portability across all storage backends and future extensibility.

**The three-phase architecture model:**

Implementation proceeds incrementally across three clearly separated phases:

- **Phase 1: The Content Analyzer (learning the current state):** A script traverses any mounted path recursively — local folders, UNC network shares (`\\server\share`), mapped drives, or cloud-synced directories. Each document is read via OCR/parser (e.g., `pypdf` or `Marker`). An LLM extracts the content in structured OKF format and links it to the current file path.

- **Phase 2: The Knowledge Matrix (data foundation):** Results flow into a structured database (e.g., PostgreSQL with JSONB or SQLite). This produces the assignment matrix ("Which content characteristics imply which target folder?") as well as the full-text search index and tag taxonomy.

- **Phase 3: The Sorter (live operation):** A file system watcher monitors one or more inbox folders. New documents are analyzed, matched against the knowledge matrix, and moved to the target location. Confidence scores below a threshold are flagged for human review rather than auto-filed.

## 3. DMS Feature Set

### 3.1 Automatic Classification & Filing

The AI assigns every document a type, correspondent, and target path based on learned patterns from the existing folder structure. The confidence score controls whether filing is fully automatic or requires confirmation.

### 3.2 Full-Text Search & Metadata Search

All document content and extracted OKF metadata (type, correspondent, date, tags, amounts) are indexed for instant search — across all connected storage locations simultaneously.

### 3.3 Tagging & Taxonomy

The AI suggests tags during ingestion; users can accept, edit, or add tags. Tags are stored in the knowledge matrix and improve future classification.

### 3.4 Document Versioning

When a document with an identical or near-identical name and content fingerprint is filed, it is recognized as a new version rather than a duplicate. Previous versions are retained and accessible.

### 3.5 Retention & Lifecycle Management

Retention rules are defined per document type (e.g., "tax invoices: 10 years", "general correspondence: 3 years"). The system tracks document age against retention periods and flags or auto-archives documents accordingly.

### 3.6 Duplicate Detection

Content-based fingerprinting identifies true duplicates regardless of filename, storage location, or format variant (e.g., a PDF re-scanned from paper). Duplicates are reported and can be consolidated automatically or manually.

### 3.7 Audit Trail

Every automated action (filing, moving, tagging, version creation) is logged with timestamp, source, target, confidence score, and the rule or AI decision that triggered it. The log is immutable and queryable.

### 3.8 Human-in-the-Loop Review Queue

Documents below the confidence threshold, or matching ambiguous patterns, land in a review queue. The user sees the AI's suggested filing, can accept or correct it, and the correction feeds back into the knowledge matrix.

### 3.9 Multi-Source Ingestion

Beyond folder watching, documents can be ingested from:
- Email attachments (via IMAP/mailbox integration)
- Scanned paper (via local scanner or watched hot folder)
- Manual upload via a simple web UI or CLI

### 3.10 Review & Release Workflows

Documents follow defined approval chains before becoming active: draft → review → approved → published. Each step has assigned roles, deadlines, and automatic notifications. A document cannot be considered the authoritative version until it has completed its release workflow.

### 3.11 Acknowledgement & Read Confirmation

For policies, instructions, or compliance-relevant documents, recipients can be required to confirm they have read and understood the document. Confirmations are tracked and visible in the audit trail.

### 3.12 Validity & Scheduled Review Dates

Every document carries a validity period and a scheduled review date — independent of its retention period. The system notifies document owners proactively before a document lapses, so nothing quietly goes stale without anyone noticing.

### 3.13 Access Control & Visibility Rules

Documents are visible and editable only to defined roles or organizational units — not as generic file permissions, but semantically: "this procedure applies to the Berlin team," "this contract is visible to Finance only." Visibility rules travel with the document, not with the folder.

### 3.14 Export & Interoperability

Documents and their metadata can be exported in open formats (PDF/A for archiving, JSON/CSV for metadata). The knowledge matrix and tag taxonomy are fully exportable, avoiding lock-in.

## 4. Technical Starting Point (Open-Source Stack)

To implement the project efficiently without building from scratch, a modular open-source stack of established Python libraries is used:

### 4.1 Data Validation & Schema (Pydantic)

The OKF schema is defined as a native Python class using `Pydantic`, guaranteeing type safety and a clean structure.

```python
from pydantic import BaseModel, Field
from typing import List

class OKFEntity(BaseModel):
    key: str = Field(description="E.g. invoice amount, issue date")
    value: str = Field(description="The extracted value")

class OKFDocumentSchema(BaseModel):
    document_type: str = Field(description="E.g. Invoice, Contract, Letter")
    correspondent: str = Field(description="Sender/company, e.g. Amazon")
    confidence_score: float = Field(description="Confidence of assignment (0.0-1.0)")
    entities: List[OKFEntity]
    suggested_tags: List[str]
    retention_years: int = Field(description="Suggested retention period in years")
```

### 4.2 Structured AI Output (Instructor + LLM)

The `Instructor` library forces the LLM (whether cloud API or local via Ollama / Llama 3) to respond exactly in the defined Pydantic format.

```python
import instructor
from openai import OpenAI

# Initialization (works equivalently with a local Ollama endpoint)
client = instructor.from_openai(OpenAI())

okf_data = client.chat.completions.create(
    model="gpt-4o-mini",
    response_model=OKFDocumentSchema,
    messages=[{"role": "user", "content": f"Analyze: {document_text}"}]
)
```

### 4.3 Knowledge Matrix Structure (Example)

The extracted OKF data is correlated with the physical path and stored in the database:

| File ID | Document Type (OKF) | Correspondent | Current Path | Extracted Tags | Retention |
|---------|---------------------|---------------|--------------|----------------|-----------|
| doc_789 | Invoice | Amazon Web Services | /Company/Expenses/2026/IT | Cloud, Server, AWS | 10 years |
| doc_012 | Insurance_Policy | Allianz | /Private/Insurance/Auto | Liability, Car, 2026 | 5 years |

## 5. Recommended Development Approach

- **Step 1: Validate locally.** Create a local script that reads 5–10 test PDFs from a local folder and saves the JSON metadata in OKF format locally.

- **Step 2: Broaden storage support.** Extend path handling to cover UNC shares and cloud-synced directories (OneDrive, Dropbox, Google Drive local sync) — anything the OS exposes as a file path works without special adapters.

- **Step 3: Add DMS features incrementally.** Introduce full-text indexing, duplicate detection, and the review queue before enabling auto-filing in production.

- **Step 4: Orchestrate.** For event handling in live operation, use an open-source workflow tool like `n8n` (Community Edition) to integrate the Python code as a microservice and wire up multi-source ingestion.
