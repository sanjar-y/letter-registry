# Build stage
FROM node:20-slim AS build

WORKDIR /app

# Install dependencies from the lockfile (clean, reproducible)
COPY package.json package-lock.json ./
RUN npm ci

# Copy source code (node_modules is excluded via .dockerignore)
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]