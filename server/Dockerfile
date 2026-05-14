# Build stage
FROM node:18-alpine AS build
WORKDIR /app

RUN apk add --no-cache openssl ca-certificates libc6-compat

COPY package*.json ./
RUN npm ci

COPY . .

RUN npx prisma generate
RUN npm run build

# Production stage
FROM node:18-alpine
WORKDIR /app

RUN apk add --no-cache openssl ca-certificates libc6-compat

COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=build /app/dist ./dist
COPY --from=build /app/prisma ./prisma
COPY --from=build /app/node_modules/.prisma ./node_modules/.prisma

EXPOSE 5000
ENV NODE_ENV=production
ENV PORT=5000

CMD ["sh", "-c", "npx prisma migrate deploy && npm run start"]
