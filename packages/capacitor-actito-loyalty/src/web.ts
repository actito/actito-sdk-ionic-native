import { WebPlugin } from '@capacitor/core';

import type { ActitoPass } from './models/actito-pass';
import type { ActitoLoyaltyPlugin } from './plugin';

export class ActitoLoyaltyPluginWeb extends WebPlugin implements ActitoLoyaltyPlugin {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  fetchPassBySerial(_options: { serial: string }): Promise<{ result: ActitoPass }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  fetchPassByBarcode(_options: { barcode: string }): Promise<{ result: ActitoPass }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  present(_options: { pass: ActitoPass }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
