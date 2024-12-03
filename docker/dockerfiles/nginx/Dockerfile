FROM nginx:1.25.4-alpine AS dev

COPY . /var/www/app
COPY ./docker/dockerfiles/nginx/config/nginx-php.conf /etc/nginx/nginx.conf

EXPOSE 80

FROM node:14.21.3-alpine AS npm
WORKDIR /var/www/app
COPY ./package.* ./
RUN npm install
COPY ./deploy /var/www/app
RUN npm run build