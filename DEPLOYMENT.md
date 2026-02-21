# GridOS Infrastructure Deployment Guide

This guide is infra-focused for a hackathon MVP:
- Deployable
- Demo-stable
- Reproducible
- Free-tier compatible

## Scope Guardrails

- Do not commit secrets.
- Use `.env` locally and platform secret managers in cloud.
- Physics path must continue working even if external APIs fail.

## Required Environment Variables

- `MORPH_API_KEY`
- `MORPH_BASE_URL`
- `ERCOT_API_KEY` (optional)
- `ALLOWED_ORIGINS`
- `NEXT_PUBLIC_API_BASE_URL`

Reference template: `.env.example`.

## Local Run (FastAPI backend)

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r GridOS-backend/requirements.txt
uvicorn main:app --reload --app-dir GridOS-backend
```

Windows PowerShell:

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r GridOS-backend\requirements.txt
uvicorn main:app --reload --app-dir GridOS-backend
```

## Local Run (Streamlit path, if used)

```bash
streamlit run app.py
```

## Option A: Streamlit Cloud (fastest)

1. Set repo entrypoint to `app.py`.
2. Add secrets in Streamlit Cloud secrets manager.
3. Verify fallback behavior by disabling external API access.

## Option B: Vercel + Render/Railway/Fly (recommended split)

### Frontend (Vercel)
- Set `NEXT_PUBLIC_API_BASE_URL` to deployed backend URL.

### Backend (Render/Railway/Fly)
- Build with `Dockerfile` at repo root.
- Set secrets in platform env settings.
- Ensure CORS uses `ALLOWED_ORIGINS`.
- Expose health endpoint (for example `/health`).

Manifest files included:
- `render.yaml`
- `railway.json`
- `fly.toml`
- `docker-compose.yml` (local full-stack orchestration)

## CORS Requirement

Backend must parse `ALLOWED_ORIGINS` and apply strict origin allow-list.

Expected format:
- `http://localhost:3000,https://your-frontend.vercel.app`

## Fallback Strategy (Non-negotiable)

If Morph fails:
- Return fallback evidence object
- Set `morphUsed=false`

If ERCOT data fails:
- Return mock/cached values
- Set `realTimeDataUsed=false`
- Label `dataMode` as `cached` or `mock`

In all fallback cases:
- Physics run must still succeed

## Logging (Safe by Default)

Backend logs should include only:
- `start_time`
- `end_time`
- `mw`
- `hub`
- `morphUsed`
- `realTimeDataUsed`
- `violations`

Never log:
- API keys
- Authorization headers
- raw secret values

## Health Endpoint

Provide a lightweight endpoint:
- `GET /health` -> `{"status":"ok"}`

Should not call external providers.

## Demo Stability Validation

1. Run 50 MW Solar North
2. Run 200 MW Solar West
3. Run 800 MW Data Center Houston
4. Disable internet and confirm:
   - fallback mode is used
   - physics still completes
   - chat/tool responses label `dataMode`

## Smoke Test Commands

PowerShell:

```powershell
.\GridOS-infra\scripts\smoke.ps1 -BaseUrl http://localhost:8000
```

Bash:

```bash
bash GridOS-infra/scripts/smoke.sh http://localhost:8000
```

## Docker Compose (Local Full Stack)

```bash
docker compose up --build
```

This starts:
- backend on `http://localhost:8000`
- frontend on `http://localhost:3000`

## Definition of Done

- Clone -> run in under 5 minutes
- Public deployment URL available
- `.env.example` present
- `.gitignore` excludes `.env`
- Backend container builds
- External API outages do not break demo
