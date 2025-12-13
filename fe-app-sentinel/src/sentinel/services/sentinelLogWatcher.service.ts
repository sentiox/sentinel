import { logger } from './logger.service';

export type LogFetcher = () => Promise<string> | string;

export interface sentinelLogWatcherOptions {
  intervalMs?: number;
  onNewLog?: (line: string) => void;
}

export class sentinelLogWatcher {
  private static instance: sentinelLogWatcher;
  private fetcher?: LogFetcher;
  private onNewLog?: (line: string) => void;
  private intervalMs = 5000;
  private lastLines = new Set<string>();
  private timer?: ReturnType<typeof setInterval>;
  private running = false;
  private paused = false;

  private constructor() {
    if (typeof document !== 'undefined') {
      document.addEventListener('visibilitychange', () => {
        if (document.hidden) this.pause();
        else this.resume();
      });
    }
  }

  static getInstance(): sentinelLogWatcher {
    if (!sentinelLogWatcher.instance) {
      sentinelLogWatcher.instance = new sentinelLogWatcher();
    }
    return sentinelLogWatcher.instance;
  }

  init(fetcher: LogFetcher, options?: sentinelLogWatcherOptions): void {
    this.fetcher = fetcher;
    this.onNewLog = options?.onNewLog;
    this.intervalMs = options?.intervalMs ?? 5000;
    logger.info(
      '[sentinelLogWatcher]',
      `initialized (interval: ${this.intervalMs}ms)`,
    );
  }

  async checkOnce(): Promise<void> {
    if (!this.fetcher) {
      logger.warn('[sentinelLogWatcher]', 'fetcher not found');
      return;
    }

    if (this.paused) {
      logger.debug('[sentinelLogWatcher]', 'skipped check — tab not visible');
      return;
    }

    try {
      const raw = await this.fetcher();
      const lines = raw.split('\n').filter(Boolean);

      for (const line of lines) {
        if (!this.lastLines.has(line)) {
          this.lastLines.add(line);
          this.onNewLog?.(line);
        }
      }

      if (this.lastLines.size > 500) {
        const arr = Array.from(this.lastLines);
        this.lastLines = new Set(arr.slice(-500));
      }
    } catch (err) {
      logger.error('[sentinelLogWatcher]', 'failed to read logs:', err);
    }
  }

  start(): void {
    if (this.running) return;
    if (!this.fetcher) {
      logger.warn('[sentinelLogWatcher]', 'attempted to start without fetcher');
      return;
    }

    this.running = true;
    this.timer = setInterval(() => this.checkOnce(), this.intervalMs);
    logger.info(
      '[sentinelLogWatcher]',
      `started (interval: ${this.intervalMs}ms)`,
    );
  }

  stop(): void {
    if (!this.running) return;
    this.running = false;
    if (this.timer) clearInterval(this.timer);
    logger.info('[sentinelLogWatcher]', 'stopped');
  }

  pause(): void {
    if (!this.running || this.paused) return;
    this.paused = true;
    logger.info('[sentinelLogWatcher]', 'paused (tab not visible)');
  }

  resume(): void {
    if (!this.running || !this.paused) return;
    this.paused = false;
    logger.info('[sentinelLogWatcher]', 'resumed (tab active)');
    this.checkOnce(); // сразу проверить, не появились ли новые логи
  }

  reset(): void {
    this.lastLines.clear();
    logger.info('[sentinelLogWatcher]', 'log history reset');
  }
}
