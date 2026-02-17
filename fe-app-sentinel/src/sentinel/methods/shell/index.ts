import { callBaseMethod } from './callBaseMethod';
import { ClashAPI, Sentinel } from '../../types';

export const SentinelShellMethods = {
  checkDNSAvailable: async () =>
    callBaseMethod<Sentinel.DnsCheckResult>(
      Sentinel.AvailableMethods.CHECK_DNS_AVAILABLE,
    ),
  checkFakeIP: async () =>
    callBaseMethod<Sentinel.FakeIPCheckResult>(
      Sentinel.AvailableMethods.CHECK_FAKEIP,
    ),
  checkNftRules: async () =>
    callBaseMethod<Sentinel.NftRulesCheckResult>(
      Sentinel.AvailableMethods.CHECK_NFT_RULES,
    ),
  getStatus: async () =>
    callBaseMethod<Sentinel.GetStatus>(Sentinel.AvailableMethods.GET_STATUS),
  checkSingBox: async () =>
    callBaseMethod<Sentinel.SingBoxCheckResult>(
      Sentinel.AvailableMethods.CHECK_SING_BOX,
    ),
  getSingBoxStatus: async () =>
    callBaseMethod<Sentinel.GetSingBoxStatus>(
      Sentinel.AvailableMethods.GET_SING_BOX_STATUS,
    ),
  getClashApiProxies: async () =>
    callBaseMethod<ClashAPI.Proxies>(Sentinel.AvailableMethods.CLASH_API, [
      Sentinel.AvailableClashAPIMethods.GET_PROXIES,
    ]),
  getClashApiProxyLatency: async (tag: string) =>
    callBaseMethod<Sentinel.GetClashApiProxyLatency>(
      Sentinel.AvailableMethods.CLASH_API,
      [Sentinel.AvailableClashAPIMethods.GET_PROXY_LATENCY, tag, '5000'],
    ),
  getClashApiGroupLatency: async (tag: string) =>
    callBaseMethod<Sentinel.GetClashApiGroupLatency>(
      Sentinel.AvailableMethods.CLASH_API,
      [Sentinel.AvailableClashAPIMethods.GET_GROUP_LATENCY, tag, '10000'],
    ),
  setClashApiGroupProxy: async (group: string, proxy: string) =>
    callBaseMethod<unknown>(Sentinel.AvailableMethods.CLASH_API, [
      Sentinel.AvailableClashAPIMethods.SET_GROUP_PROXY,
      group,
      proxy,
    ]),
  restart: async () =>
    callBaseMethod<unknown>(
      Sentinel.AvailableMethods.RESTART,
      [],
      '/etc/init.d/sentinel',
    ),
  start: async () =>
    callBaseMethod<unknown>(
      Sentinel.AvailableMethods.START,
      [],
      '/etc/init.d/sentinel',
    ),
  stop: async () =>
    callBaseMethod<unknown>(
      Sentinel.AvailableMethods.STOP,
      [],
      '/etc/init.d/sentinel',
    ),
  enable: async () =>
    callBaseMethod<unknown>(
      Sentinel.AvailableMethods.ENABLE,
      [],
      '/etc/init.d/sentinel',
    ),
  disable: async () =>
    callBaseMethod<unknown>(
      Sentinel.AvailableMethods.DISABLE,
      [],
      '/etc/init.d/sentinel',
    ),
  globalCheck: async () =>
    callBaseMethod<unknown>(Sentinel.AvailableMethods.GLOBAL_CHECK),
  showSingBoxConfig: async () =>
    callBaseMethod<unknown>(Sentinel.AvailableMethods.SHOW_SING_BOX_CONFIG),
  checkLogs: async () =>
    callBaseMethod<unknown>(Sentinel.AvailableMethods.CHECK_LOGS),
  clearLogs: async () =>
    callBaseMethod<unknown>(Sentinel.AvailableMethods.CLEAR_LOGS),
  getSystemInfo: async () =>
    callBaseMethod<Sentinel.GetSystemInfo>(
      Sentinel.AvailableMethods.GET_SYSTEM_INFO,
    ),
};
