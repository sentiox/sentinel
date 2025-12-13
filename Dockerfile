FROM openwrt/sdk:x86-64-24.10.1

ARG PKG_VERSION
ENV PKG_VERSION=${PKG_VERSION}

# Обновляем feeds (luci уже есть в SDK, но обновим)
RUN ./scripts/feeds update -a && ./scripts/feeds install -a

# Копируем пакеты В ПРАВИЛЬНЫЙ FEED
COPY ./sentinel /builder/package/feeds/utilities/sentinel
COPY ./luci-app-sentinel /builder/package/feeds/luci/luci-app-sentinel

# Сборка
RUN make defconfig && \
    make package/sentinel/compile -j$(nproc) V=s && \
    make package/luci-app-sentinel/compile -j$(nproc) V=s
