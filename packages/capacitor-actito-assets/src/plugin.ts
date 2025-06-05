import { registerPlugin } from '@capacitor/core';

import type { ActitoAsset } from './models/actito-asset';

export const NativePlugin = registerPlugin<ActitoAssetsPlugin>('ActitoAssetsPlugin', {
  web: () => import('./web').then((m) => new m.ActitoAssetsPluginWeb()),
});

export interface ActitoAssetsPlugin {
  fetch(options: { group: string }): Promise<{ result: ActitoAsset[] }>;
}
