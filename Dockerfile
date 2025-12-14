FROM itdoginfo/openwrt-sdk:24.10.1

ARG PKG_VERSION
ENV PKG_VERSION=${PKG_VERSION}

COPY ./sentinel /builder/package/feeds/utilites/sentinel
COPY ./luci-app-sentinel /builder/package/feeds/luci/luci-app-sentinel

RUN make defconfig && \
    make package/sentinel/compile && \
    make package/luci-app-sentinel/compile V=s -j4
