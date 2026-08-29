FROM nginx:alpine

LABEL org.opencontainers.image.title="CP04 - Containers na Nuvem"
LABEL org.opencontainers.image.description="Portal acadêmico sobre cgroups e namespaces"
LABEL org.opencontainers.image.authors="Guilherme Silva dos Santos"

COPY site/index.html /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/ >/dev/null || exit 1
