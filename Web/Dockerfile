FROM node:26-alpine AS builder

WORKDIR /app

COPY ./Web/package*.json ./
RUN npm ci

COPY ./Web .
RUN npm run build


FROM nginx:1.29.8-alpine AS final

COPY ./.docker/nginx/templates /etc/nginx/templates
COPY --from=builder /app/dist /var/www/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]