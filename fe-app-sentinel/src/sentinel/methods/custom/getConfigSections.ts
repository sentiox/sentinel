import { Sentinel } from '../../types';

export async function getConfigSections(): Promise<Sentinel.ConfigSection[]> {
  return uci.load('sentinel').then(() => uci.sections('sentinel'));
}
