import type { PluginListenerHandle } from '@capacitor/core';
import { registerPlugin } from '@capacitor/core';

export const NativePlugin = registerPlugin<ActitoInAppMessagingPlugin>('ActitoInAppMessagingPlugin', {
  web: () => import('./web').then((m) => new m.ActitoInAppMessagingPluginWeb()),
});

export interface ActitoInAppMessagingPlugin {
  //
  // Methods
  //

  hasMessagesSuppressed(): Promise<{ result: boolean }>;

  setMessagesSuppressed(options: { suppressed: boolean; evaluateContext?: boolean }): Promise<void>;

  //
  // Event bridge
  //

  addListener(eventName: string, listenerFunc: (data: any) => void): Promise<PluginListenerHandle>;
}
