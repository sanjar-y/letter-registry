# Build stage
FROM node:20-slim AS build

WORKDIR /app

# Prisma needs OpenSSL
RUN apt-get update -y && apt-get install -y --no-install-recommends openssl \
    && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./
RUN npm ci

# Copy source code and prisma schema
COPY . .

# Generate Prisma Client and build TypeScript
RUN npx prisma generate
RUN npm run build

# Production stage
FROM node:20-slim

WORKDIR /app

RUN apt-get update -y && apt-get install -y --no-install-recommends openssl \
    && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./

# Keep the full node_modules from the build stage: the prisma CLI
# (needed for `migrate deploy`) is a devDependency, and the generated
# client lives inside node_modules/.prisma
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/prisma ./prisma

EXPOSE 5000

ENV NODE_ENV=production
ENV PORT=5000

CMD ["sh", "-c", "npx prisma migrate deploy && node dist/server.js"]