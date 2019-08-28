FROM ubuntu:19.04

ARG S6_OVERLAY_VERSION=1.21.7.0
# Install S6 Overlay
RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y  wget tzdata cron \
    && cd /tmp \
    && wget https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz \
    && tar xzf s6-overlay-amd64.tar.gz -C / \
    \
    && rm s6-overlay-amd64.tar.gz \
    && apt remove --purge --auto-remove wget tzdata -y \
    \
    ; apt clean \
    ; apt autoclean \
    ; rm /var/lib/apt/lists/*.* \
    ; rm /var/lib/apt/lists/partial/*.* \
    ; true


# Add S6 Services
ADD conf/ /

# Fix Permissions
RUN set -x \
    && chmod +x /usr/bin/apt-clean \
    && chmod +x /usr/bin/service-handler \
    && chmod +x /etc/cont-init.d/ -R \
    && chmod +x /etc/s6/services/ -R 

ENTRYPOINT ["/init"]