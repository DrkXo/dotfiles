FROM node:20-bookworm-slim

# Install Chrome dependencies once, at build time
RUN apt-get update && apt-get install -y \
    wget gnupg ca-certificates \
    fonts-liberation libnss3 libatk-bridge2.0-0 \
    libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 \
    libgbm1 libgtk-3-0 libasound2 \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy and install dependencies (cached by Docker layer)
COPY package*.json ./
RUN npm install

# Install Chrome (cached in the image)
RUN npx puppeteer browsers install chrome

# Copy app source
COPY . .

EXPOSE 3000
CMD ["node", "server.js"]
