import type { PluginListenerHandle } from '@capacitor/core';
import { registerPlugin } from '@capacitor/core';
import type { ActitoNotification } from 'capacitor-actito';

import type { ActitoInboxItem } from './models/actito-inbox-item';

export const NativePlugin = registerPlugin<ActitoInboxPlugin>('ActitoInboxPlugin', {
  web: () => import('./web').then((m) => new m.ActitoInboxPluginWeb()),
});

export interface ActitoInboxPlugin {
  //
  // Methods
  //

  getItems(): Promise<{ result: ActitoInboxItem[] }>;

  getBadge(): Promise<{ result: number }>;

  refresh(): Promise<void>;

  open(options: { item: ActitoInboxItem }): Promise<{ result: ActitoNotification }>;

  markAsRead(options: { item: ActitoInboxItem }): Promise<void>;

  markAllAsRead(): Promise<void>;

  remove(options: { item: ActitoInboxItem }): Promise<void>;

  clear(): Promise<void>;

  //
  // Event bridge
  //

  addListener(eventName: string, listenerFunc: (data: any) => void): Promise<PluginListenerHandle>;
}
