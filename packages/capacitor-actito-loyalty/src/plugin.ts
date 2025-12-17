import { registerPlugin } from '@capacitor/core';

import type { ActitoPass } from './models/actito-pass';

export const NativePlugin = registerPlugin<ActitoLoyaltyPlugin>('ActitoLoyaltyPlugin', {
  web: () => import('./web').then((m) => new m.ActitoLoyaltyPluginWeb()),
});

export interface ActitoLoyaltyPlugin {
  //
  // Methods
  //

  fetchPassBySerial(options: { serial: string }): Promise<{ result: ActitoPass }>;

  fetchPassByBarcode(options: { barcode: string }): Promise<{ result: ActitoPass }>;

  present(options: { pass: ActitoPass }): Promise<void>;
}
