import { WebPlugin } from '@capacitor/core';

import type { ActitoAsset } from './models/actito-asset';
import type { ActitoAssetsPlugin } from './plugin';

export class ActitoAssetsPluginWeb extends WebPlugin implements ActitoAssetsPlugin {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async fetch(_options: { group: string }): Promise<{ result: ActitoAsset[] }> {
    throw this.unimplemented('Not implemented on web.');
  }
}
