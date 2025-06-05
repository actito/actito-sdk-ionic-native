import { WebPlugin } from '@capacitor/core';

import type { ActitoScannable } from './models/actito-scannable';
import type { ActitoScannablesPlugin } from './plugin';

export class ActitoScannablesPluginWeb extends WebPlugin implements ActitoScannablesPlugin {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  canStartNfcScannableSession(): Promise<{ result: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  startScannableSession(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  startNfcScannableSession(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  startQrCodeScannableSession(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  fetch(_options: { tag: string }): Promise<{ result: ActitoScannable }> {
    throw this.unimplemented('Not implemented on web.');
  }
}
