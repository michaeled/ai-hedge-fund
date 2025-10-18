# ──────────────────────────────────────────────
# 1️⃣ Base image with Python and Node
# ──────────────────────────────────────────────
FROM python:3.11-slim AS base

RUN apt-get update && apt-get install -y curl build-essential git && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest
RUN pip install poetry

# ──────────────────────────────────────────────
# 2️⃣ Copy everything into /app
# ──────────────────────────────────────────────
WORKDIR /app
COPY . .

# ──────────────────────────────────────────────
# 3️⃣ Install backend dependencies
# ──────────────────────────────────────────────
# Since pyproject.toml is at project root
RUN poetry install --no-interaction --no-root

# ──────────────────────────────────────────────
# 4️⃣ Install frontend dependencies
# ──────────────────────────────────────────────
WORKDIR /app/app/frontend
RUN npm install

# ──────────────────────────────────────────────
# 5️⃣ Expose ports and run servers
# ──────────────────────────────────────────────
WORKDIR /app
EXPOSE 8000 5173

CMD ["bash", "-c", "\
    poetry run uvicorn app.backend.main:app --host 0.0.0.0 --port 8000 & \
    cd app/frontend && npm run dev -- --host 0.0.0.0 --port 5173 \
    "]
