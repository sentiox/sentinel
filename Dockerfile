FROM openwrt/sdk:x86-64-24.10.1

# Версия пакета (из GitHub Actions)
ARG PKG_VERSION
ENV PKG_VERSION=${PKG_VERSION}

# Обновляем feeds (НЕ интерактивно)
RUN ./scripts/feeds update -a && \
    ./scripts/feeds install -a

# Копируем пакеты В ПРАВИЛЬНЫЕ FEEDS
COPY ./sentinel /builder/package/feeds/utilities/sentinel
COPY ./luci-app-sentinel /builder/package/feeds/luci/luci-app-sentinel

# Генерация .config БЕЗ TTY (ВАЖНО!)
RUN make defconfig && \
    yes "" | make oldconfig

# Сборка пакетов (однопоточно для стабильности)
RUN echo "=== BUILD sentinel ===" && \
    make package/sentinel/compile -j1 V=s && \
    echo "=== BUILD luci-app-sentinel ===" && \
    make package/luci-app-sentinel/compile -j1 V=s
