# Stage 1: Build aplikasi React
FROM node:18-alpine AS builder
WORKDIR /app

# Tambahkan baris ini untuk mengatasi error OpenSSL
ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy dependency files
COPY package*.json ./
RUN npm install

# Copy source code dan build
COPY . .
RUN npm run build

# Stage 2: Sajikan dengan Nginx
FROM nginx:alpine
# Copy hasil build dari stage sebelumnya ke folder default Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
