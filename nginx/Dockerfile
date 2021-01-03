FROM nginx:stable-alpine-perl

RUN apk add --no-cache nginx-mod-http-perl

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80/tcp
EXPOSE 443/tcp

CMD ["/bin/sh", "-c", "exec nginx -g 'daemon off;';"]
