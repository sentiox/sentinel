import { executeShellCommand } from '../../../helpers';
import { Sentinel } from '../../types';

export async function callBaseMethod<T>(
  method: Sentinel.AvailableMethods,
  args: string[] = [],
  command: string = '/usr/bin/sentinel',
): Promise<Sentinel.MethodResponse<T>> {
  const response = await executeShellCommand({
    command,
    args: [method as string, ...args],
    timeout: 15000,
  });

  if (response.stdout) {
    try {
      return {
        success: true,
        data: JSON.parse(response.stdout) as T,
      };
    } catch (_e) {
      return {
        success: true,
        data: response.stdout as T,
      };
    }
  }

  return {
    success: false,
    error: '',
  };
}
