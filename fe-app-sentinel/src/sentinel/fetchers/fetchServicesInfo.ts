import { sentinelShellMethods } from '../methods';
import { store } from '../services';

export async function fetchServicesInfo() {
  const [sentinel, singbox] = await Promise.all([
    sentinelShellMethods.getStatus(),
    sentinelShellMethods.getSingBoxStatus(),
  ]);

  if (!sentinel.success || !singbox.success) {
    store.set({
      servicesInfoWidget: {
        loading: false,
        failed: true,
        data: { singbox: 0, sentinel: 0 },
      },
    });
  }

  if (sentinel.success && singbox.success) {
    store.set({
      servicesInfoWidget: {
        loading: false,
        failed: false,
        data: { singbox: singbox.data.running, sentinel: sentinel.data.enabled },
      },
    });
  }
}
