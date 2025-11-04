FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package-server.json ./package.json

# Install dependencies
RUN npm ci

# Copy source code
COPY server/ ./server/
COPY types.ts ./

# Create data directory
RUN mkdir -p /data

# Expose port
EXPOSE 3001

# Start the server
CMD ["node", "server/index.js"]