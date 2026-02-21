# GridOS backend container (FastAPI, monorepo-aware)
# Builds and runs the backend from GridOS-backend/ without editing app code.

FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PORT=8000 \
    APP_MODULE=main:app \
    APP_DIR=GridOS-backend

WORKDIR /app

# Install app dependencies
COPY ${APP_DIR}/requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && pip install -r /app/requirements.txt

# Copy backend source only
COPY ${APP_DIR}/ /app/

EXPOSE 8000

# Uses platform-provided PORT when available (Render/Railway/Fly)
CMD ["sh", "-c", "uvicorn ${APP_MODULE} --host 0.0.0.0 --port ${PORT}"]
