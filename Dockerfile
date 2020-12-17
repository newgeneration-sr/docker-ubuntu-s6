FROM ubuntu:20.04

ENV S6_OVERLAY_VERSION=v2.1.0.2
# Install S6 Overlay
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y cron curl \
    && cd /tmp \
    && curl -s -L https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64-installer --output ./s6-overlay-amd64-installer  \
    && chmod +x ./s6-overlay-amd64-installer

RUN cd /tmp && ./s6-overlay-amd64-installer / \
    && rm s6-overlay-amd64-installer \
    && apt remove --purge --auto-remove -y \
    apt clean; \
    apt autoclean; \
    rm /var/lib/apt/lists/*.* ; \
    rm /var/lib/apt/lists/partial/*.* ; \
    true


# Add S6 Services
ADD conf/ /

# Fix Permissions
RUN set -x \
    && chmod +x /usr/bin/apt-clean \
    && chmod +x /usr/bin/service-handler \
    && chmod +x /etc/cont-init.d/ -R \
    && chmod +x /etc/s6/services/ -R 

ENTRYPOINT ["/init"]
