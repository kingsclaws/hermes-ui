# syntax=docker/dockerfile:1.7
# Hermes Workspace (WebUI) — based on official Dockerfile

FROM node:22-alpine AS builder
WORKDIR /app

ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

RUN git clone --depth=1 https://github.com/outsourc-e/hermes-workspace.git . && \
    npm install -g pnpm && \
    pnpm install --no-frozen-lockfile && \
    pnpm build

# --- Production stage ---
FROM node:22-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

RUN addgroup -S hermes && adduser -S hermes -G hermes

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/server-entry.js ./

ENV HERMES_API_URL=http://hermes:8642
ENV PORT=3000

EXPOSE 3000

USER hermes

CMD ["node", "server-entry.js"]
