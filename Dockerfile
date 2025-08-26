# Stage 1: Build the Angular application
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
COPY .npmrc ./

# Install all dependencies (including devDependencies for build)
RUN npm ci --silent

# Copy source code
COPY . .

# Build the application
RUN npm run build:prod

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Install curl for health checks
RUN apk --no-cache add curl

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built application from builder stage
COPY --from=builder /app/dist/gestion-even-stat /usr/share/nginx/html

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Start Nginx (run as root - standard for nginx in containers)
CMD ["nginx", "-g", "daemon off;"]
