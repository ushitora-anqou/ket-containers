FROM alpine:3 AS src

ENV DEBIAN_FRONTEND=noninteractive

RUN apk update && \
    apk add git && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/ushitora-anqou/yorksap-frontend-wip3.git src && \
    cd src && \
    git checkout c138b564ba7a7debf4f6536cdb6f3e60b65c2078

# ref. Next.js Official Build Guide: https://github.com/vercel/next.js/tree/df14fdfa259eaf1062f0b97942a1645ee9671487/examples/with-docker
FROM node:20-alpine AS base
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY --from=src /src/package.json /src/yarn.lock* /src/package-lock.json* /src/pnpm-lock.yaml* ./
# remove backend for dev
RUN rm -rf app/hoge app/api
RUN npm ci
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY --from=src /src/ ./

RUN env NEXT_PUBLIC_RECAPTCHA_CLIENT_KEY=6LfKCp8pAAAAAI4uNeDVVWKgqr9Tmca8PN5eguCt npm run build

FROM base AS runner
WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
RUN mkdir .next
RUN chown nextjs:nodejs .next
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"
CMD ["node", "server.js"]
