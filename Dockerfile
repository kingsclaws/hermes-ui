# syntax=docker/dockerfile:1.7
# Hermes Workspace (WebUI) — lightweight Node.js image

FROM node:24
RUN corepack enable && corepack prepare pnpm@9 --activate

WORKDIR /app
RUN git clone --depth=1 https://github.com/outsourc-e/hermes-workspace.git .
RUN pnpm install --frozen-lockfile 2>/dev/null || pnpm install

ENV NODE_ENV=development
ENV PORT=3000
ENV HERMES_API_URL=http://hermes:8642

EXPOSE 3000

CMD ["pnpm", "dev"]
