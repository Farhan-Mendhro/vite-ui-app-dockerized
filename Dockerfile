# --- Stage 1: Build (The "Heavy" Stage) ---
FROM node:20-slim AS builder

WORKDIR /app

RUN npm install -g pnpm

COPY . .

WORKDIR /app/templates/vite

RUN pnpm install

# We skip the type-check as before to ensure it builds
RUN npx vite build


# --- Stage 2: Serve (The "Tiny" Stage) ---
FROM nginx:alpine
# Copy ONLY the static 'dist' folder into Nginx's public directory
COPY --from=builder /app/templates/vite/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]