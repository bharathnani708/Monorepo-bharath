FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
#RUN npm ci --omit=dev
RUN npm install --omit=dev --no-audit --no-fund
COPY src ./src
EXPOSE 8080
CMD ["npm", "start"]


#FROM node:22-alpine AS base
#WORKDIR /app
#COPY package*.json ./
#RUN npm ci --omit=dev
#COPY src ./src
#EXPOSE 8080
#CMD ["npm", "start"]
