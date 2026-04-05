# syntax=docker/dockerfile:1.7
# Hermes Workspace (WebUI) — lightweight Node.js image

FROM node:24 AS base
RUN corepack enable && corepack prepare pnpm@9 --activate

# ========== Install dependencies ==========
FROM base AS deps
WORKDIR /app
RUN git clone --depth=1 https://github.com/outsourc-e/hermes-workspace.git .
RUN pnpm install --frozen-lockfile 2>/dev/null || pnpm install

# ========== Build ==========
FROM base AS build
WORKDIR /app
COPY --from=deps /app ./
RUN pnpm build 2>/dev/null || echo "No build step, skipping"

# ========== Production ==========
FROM base
WORKDIR /app
COPY --from=build /app ./

# We only need the runtime, not dev deps
RUN pnpm install --prod 2>/dev/null || true

ENV NODE_ENV=production
ENV PORT=3002
ENV HERMES_API_URL=http://hermes:3000

EXPOSE 3002

CMD ["pnpm", "preview"]
