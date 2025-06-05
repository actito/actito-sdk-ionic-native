import type { PluginListenerHandle } from '@capacitor/core';
import { registerPlugin } from '@capacitor/core';

import type { ActitoScannable } from './models/actito-scannable';

export const NativePlugin = registerPlugin<ActitoScannablesPlugin>('ActitoScannablesPlugin', {
  web: () => import('./web').then((m) => new m.ActitoScannablesPluginWeb()),
});

export interface ActitoScannablesPlugin {
  //
  // Methods
  //

  canStartNfcScannableSession(): Promise<{ result: boolean }>;

  startScannableSession(): Promise<void>;

  startNfcScannableSession(): Promise<void>;

  startQrCodeScannableSession(): Promise<void>;

  fetch(options: { tag: string }): Promise<{ result: ActitoScannable }>;

  //
  // Event bridge
  //

  addListener(eventName: string, listenerFunc: (data: any) => void): Promise<PluginListenerHandle>;
}
