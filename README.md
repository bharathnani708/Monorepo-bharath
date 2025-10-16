
# 🧩 Monorepo CI/CD workflow

This repository is a **multi-service monorepo** containing three independent backend applications — each written in a different language — that are automatically built, tested, analyzed with SonarQube, and containerized through **GitHub Actions CI**.

---

## 🏗️ Project Overview

| Service | Language | Description | Docker Image |
|----------|-----------|--------------|---------------|
| **API Gateway** (`apps/api-gateway-node`) | Node.js | Routes client requests, handles authentication, and aggregates data from downstream services. | `ghcr.io/<your-username>/api-gateway-node` |
| **Payments Service** (`apps/payments-python`) | Python | Handles payment processing, transactions, and related workflows. | `ghcr.io/<your-username>/payments-python` |
| **Orders Service** (`apps/orders-java`) | Java | Manages order lifecycle, fulfillment, and tracking. | `ghcr.io/<your-username>/orders-java` |
| **Shared Libraries** (`libs/`) | — | Common logic, models, or utilities shared across services. | — |

Each service is isolated with its own dependencies and Dockerfile.

---

## ⚙️ CI Workflow (`.github/workflows/ci.yaml`)

The repository uses a single **CI pipeline** to handle all builds.  
It is designed for efficiency — only the applications that have changed are built and tested.


### 🔁 Trigger Events
- `push` → runs full build & image push for changed apps
- `pull_request` → runs lint, tests, and SonarQube scan
- `workflow_dispatch` → manual run

###  Pipeline Stages

1. **Detect Changes**  
   Uses [`dorny/paths-filter`](https://github.com/dorny/paths-filter) to detect which app folders changed.  
   Only those apps’ pipelines are executed (saves time & cost).

2. **Setup Environment**  
   - Prepares runner cache directories  
   - Installs correct language runtimes:
     - Node.js via `actions/setup-node`
     - Python via `actions/setup-python`
     - Java via `actions/setup-java` + Apache Maven

3. **Install & Test**  
   - Installs dependencies (`npm install`, `pip install`, or `mvn package`)  
   - Runs lint and unit tests for each service

4. **Code Quality (SonarQube Scan)**  
   - Runs static code analysis using **SonarQube CLI**  
   - Evaluates bugs, code smells, coverage, and maintainability metrics  
   - Fails pipeline if the **Quality Gate** is not met

5. **Docker Build & Push**
   - Builds Docker images for each updated service  
   - Pushes them to **GitHub Container Registry (GHCR)
     
---

## 🧩 How Change Detection Works

Each push triggers the `detect-changes` job:
```yaml
filters:
  api: ['apps/api-gateway-node/**', 'libs/**']
  pay: ['apps/payments-python/**', 'libs/**']
  ord: ['apps/orders-java/**', 'libs/**']
```

## Key Features
   - Polyglot Monorepo (Node + Python + Java)
   - Smart change detection — builds only what changed
   - Full SonarQube integration for code quality
   - GHCR integration for container delivery
   - Self-hosted runner–friendly (macOS/Linux)
   - Extendable for PR checks or CD workflows

---

## 🚀 Next Steps: Continuous Deployment (CD)

While this repository currently implements a full **Continuous Integration (CI)** workflow — including build, test, linting, SonarQube analysis, and container publishing —  
the next logical step is to extend it into **Continuous Deployment (CD)**.

The `deploy/` directory already contains the foundation for deployment automation.  
In the upcoming phase, the goal is to:
- ✅ Use the images published to **GitHub Container Registry (GHCR)** as deployable artifacts.
- ⚙️ Apply Kubernetes manifests (from the `deploy/` folder) for each microservice.
- 🧩 Automate environment-specific rollouts (e.g., `dev`, `staging`, `prod`).
- 🔁 Integrate with **GitHub Actions** for end-to-end CI/CD.
- 🧠 Optionally include Helm or Kustomize for templating and GitOps compatibility.

A sample CD flow will look like this:

Commit → CI (Build + Test + Sonar) → GHCR → CD (Kubernetes Apply)

Once implemented, each successful CI pipeline will automatically:
1. Pull the latest image from GHCR.  
2. Update the deployment manifests with the new image tag.  
3. Roll out updates to the respective Kubernetes namespace.

---

> 🛠️ *Work in progress:* The `deploy/` folder will soon be enhanced with reusable manifests, secrets management, and environment-specific configurations.


🧾 Author & Credits
   - Maintainer: Bharath Nadigoti
   - Tech Stack: Node.js · Python · Java · Docker · GitHub Actions · SonarQube · GHCR
   - Purpose: Demonstration of CI pipelines in a multi-language monorepo with efficient builds and code quality automation.
