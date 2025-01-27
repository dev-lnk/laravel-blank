FROM nginx:1.27.3-alpine AS dev

ARG project_dir

COPY . /var/www/app
COPY ./docker/dockerfiles/nginx/config/nginx-php.conf /etc/nginx/nginx.conf

RUN sed -i "s|PROJECT_DIR|$project_dir/public|g" /etc/nginx/nginx.conf

EXPOSE 80