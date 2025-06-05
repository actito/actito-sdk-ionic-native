import type { PluginListenerHandle } from '@capacitor/core';
import { registerPlugin } from '@capacitor/core';
import type { ActitoNotification, ActitoNotificationAction } from 'capacitor-actito';

export const NativePlugin = registerPlugin<ActitoPushUIPlugin>('ActitoPushUIPlugin', {
  web: () => import('./web').then((m) => new m.ActitoPushUIPluginWeb()),
});

export interface ActitoPushUIPlugin {
  //
  // Methods
  //

  presentNotification(options: { notification: ActitoNotification }): Promise<void>;

  presentAction(options: { notification: ActitoNotification; action: ActitoNotificationAction }): Promise<void>;

  //
  // Event bridge
  //

  addListener(eventName: string, listenerFunc: (data: any) => void): Promise<PluginListenerHandle>;
}
