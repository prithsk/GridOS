# GridOS Infra Baseline

This repository contains infra scaffolding for a hackathon MVP in a monorepo layout.

## Included

- `.env.example` with required variables
- `.gitignore` that blocks `.env` secrets
- `Dockerfile` for backend container deployment
- `docker-compose.yml` for local full-stack bring-up
- `render.yaml`, `railway.json`, `fly.toml` for free-tier deploy targets
- `DEPLOYMENT.md` with local/cloud instructions and fallback rules
- `GridOS-infra/` smoke scripts and demo-readiness checklist

## Infra Rules Implemented

- No secrets committed
- CORS env modeled via `ALLOWED_ORIGINS`
- Deployment paths for free tiers
- Offline-safe fallback expectations documented
- Health endpoint requirement documented
- Safe logging requirements documented

## Quick Start

1. Copy `.env.example` -> `.env`
2. Run backend:
   - `uvicorn main:app --reload --app-dir GridOS-backend`
3. Or run Streamlit path:
   - `streamlit run app.py`
4. Optional full stack:
   - `docker compose up --build`

For full deployment instructions, see `DEPLOYMENT.md`.
