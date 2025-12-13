import { callBaseMethod } from './callBaseMethod';
import { ClashAPI, sentinel } from '../../types';

export const sentinelShellMethods = {
  checkDNSAvailable: async () =>
    callBaseMethod<sentinel.DnsCheckResult>(
      sentinel.AvailableMethods.CHECK_DNS_AVAILABLE,
    ),
  checkFakeIP: async () =>
    callBaseMethod<sentinel.FakeIPCheckResult>(
      sentinel.AvailableMethods.CHECK_FAKEIP,
    ),
  checkNftRules: async () =>
    callBaseMethod<sentinel.NftRulesCheckResult>(
      sentinel.AvailableMethods.CHECK_NFT_RULES,
    ),
  getStatus: async () =>
    callBaseMethod<sentinel.GetStatus>(sentinel.AvailableMethods.GET_STATUS),
  checkSingBox: async () =>
    callBaseMethod<sentinel.SingBoxCheckResult>(
      sentinel.AvailableMethods.CHECK_SING_BOX,
    ),
  getSingBoxStatus: async () =>
    callBaseMethod<sentinel.GetSingBoxStatus>(
      sentinel.AvailableMethods.GET_SING_BOX_STATUS,
    ),
  getClashApiProxies: async () =>
    callBaseMethod<ClashAPI.Proxies>(sentinel.AvailableMethods.CLASH_API, [
      sentinel.AvailableClashAPIMethods.GET_PROXIES,
    ]),
  getClashApiProxyLatency: async (tag: string) =>
    callBaseMethod<sentinel.GetClashApiProxyLatency>(
      sentinel.AvailableMethods.CLASH_API,
      [sentinel.AvailableClashAPIMethods.GET_PROXY_LATENCY, tag, '5000'],
    ),
  getClashApiGroupLatency: async (tag: string) =>
    callBaseMethod<sentinel.GetClashApiGroupLatency>(
      sentinel.AvailableMethods.CLASH_API,
      [sentinel.AvailableClashAPIMethods.GET_GROUP_LATENCY, tag, '10000'],
    ),
  setClashApiGroupProxy: async (group: string, proxy: string) =>
    callBaseMethod<unknown>(sentinel.AvailableMethods.CLASH_API, [
      sentinel.AvailableClashAPIMethods.SET_GROUP_PROXY,
      group,
      proxy,
    ]),
  restart: async () =>
    callBaseMethod<unknown>(
      sentinel.AvailableMethods.RESTART,
      [],
      '/etc/init.d/sentinel',
    ),
  start: async () =>
    callBaseMethod<unknown>(
      sentinel.AvailableMethods.START,
      [],
      '/etc/init.d/sentinel',
    ),
  stop: async () =>
    callBaseMethod<unknown>(
      sentinel.AvailableMethods.STOP,
      [],
      '/etc/init.d/sentinel',
    ),
  enable: async () =>
    callBaseMethod<unknown>(
      sentinel.AvailableMethods.ENABLE,
      [],
      '/etc/init.d/sentinel',
    ),
  disable: async () =>
    callBaseMethod<unknown>(
      sentinel.AvailableMethods.DISABLE,
      [],
      '/etc/init.d/sentinel',
    ),
  globalCheck: async () =>
    callBaseMethod<unknown>(sentinel.AvailableMethods.GLOBAL_CHECK),
  showSingBoxConfig: async () =>
    callBaseMethod<unknown>(sentinel.AvailableMethods.SHOW_SING_BOX_CONFIG),
  checkLogs: async () =>
    callBaseMethod<unknown>(sentinel.AvailableMethods.CHECK_LOGS),
  getSystemInfo: async () =>
    callBaseMethod<sentinel.GetSystemInfo>(
      sentinel.AvailableMethods.GET_SYSTEM_INFO,
    ),
};
