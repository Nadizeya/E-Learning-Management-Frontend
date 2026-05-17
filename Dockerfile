# =======================
# Build Stage
# =======================
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build arguments for environment variables
ARG VITE_API_BASE_URL
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

# Inject variable into Vite during build
RUN echo "VITE_API_BASE_URL=$VITE_API_BASE_URL" && \
    VITE_API_BASE_URL=$VITE_API_BASE_URL npm run build

# =======================
# Production Stage
# =======================
FROM nginx:alpine

# Copy built assets from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Cloud Run sets PORT environment variable
# Startup script adjusts nginx config
COPY start-nginx.sh /start-nginx.sh
RUN chmod +x /start-nginx.sh

EXPOSE 8080

CMD ["/start-nginx.sh"]
