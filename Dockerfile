FROM openwrt/sdk:x86-64-24.10.1

ARG PKG_VERSION
ENV PKG_VERSION=${PKG_VERSION}

RUN ./scripts/feeds update -a && \
    ./scripts/feeds install -a

COPY ./sentinel /builder/package/feeds/utilities/sentinel
COPY ./luci-app-sentinel /builder/package/feeds/luci/luci-app-sentinel

RUN make package/sentinel/compile -j1 V=s && \
    make package/luci-app-sentinel/compile -j1 V=s
