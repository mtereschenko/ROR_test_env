# Base image declaration
FROM nginx:1.20.2-alpine as base_image

# Production image declaration
FROM base_image as production
ARG HOST_UID=1000
ARG HOST_GID=1000

FROM base_image as development

COPY ./environment/containers/nginx/config/nginx-dev.conf /etc/nginx/conf.d/default.conf
RUN sed -i -r "s/doamin.localhost;/${PROJECT_NAME}.localhost;/g" /etc/nginx/conf.d/default.conf \
    && chmod 644 /etc/nginx/conf.d/default.conf
