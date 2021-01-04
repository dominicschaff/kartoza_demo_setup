FROM nginx:stable-alpine-perl AS base

RUN apk add --no-cache nginx-mod-http-perl

COPY nginx-dev.conf /etc/nginx/nginx.conf
ENV SITE_HOST localhost

EXPOSE 80/tcp
EXPOSE 443/tcp

CMD ["/bin/sh", "-c", "exec nginx -g 'daemon off;';"]


FROM base AS prod

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["/bin/sh", "-c", "exec nginx -g 'daemon off;';"]
