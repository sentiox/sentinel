FROM openwrt/sdk:x86-64-24.10.1

ARG PKG_VERSION
ENV PKG_VERSION=${PKG_VERSION}

# 1. Обновляем и ставим feeds (ОБЯЗАТЕЛЬНО)
RUN ./scripts/feeds update -a && \
    ./scripts/feeds install -a

# 2. Копируем пакеты В ПРАВИЛЬНЫЕ FEEDS
# utilities — для обычных пакетов
# luci — ТОЛЬКО для luci-app
COPY ./sentinel /builder/package/feeds/utilities/sentinel
COPY ./luci-app-sentinel /builder/package/feeds/luci/luci-app-sentinel

# 3. Сборка (ОДНОПОТОЧНО + полный лог)
RUN make defconfig && \
    echo "=== BUILD sentinel ===" && \
    make package/sentinel/compile -j1 V=s && \
    echo "=== BUILD luci-app-sentinel ===" && \
    make package/luci-app-sentinel/compile -j1 V=s
