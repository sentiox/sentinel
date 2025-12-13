import { sentinel } from '../../types';

export async function getConfigSections(): Promise<sentinel.ConfigSection[]> {
  return uci.load('sentinel').then(() => uci.sections('sentinel'));
}
