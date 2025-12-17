import { registerPlugin } from '@capacitor/core';
import type { ActitoNotification } from 'capacitor-actito';

import type { ActitoUserInboxItem } from './models/actito-user-inbox-item';
import type { ActitoUserInboxResponse } from './models/actito-user-inbox-response';

export const NativePlugin = registerPlugin<ActitoUserInboxPlugin>('ActitoUserInboxPlugin', {
  web: () => import('./web').then((m) => new m.ActitoUserInboxPluginWeb()),
});

export interface ActitoUserInboxPlugin {
  //
  // Methods
  //

  parseResponseFromJson(options: { json: Record<string, any> }): Promise<{ result: ActitoUserInboxResponse }>;

  parseResponseFromString(options: { json: string }): Promise<{ result: ActitoUserInboxResponse }>;

  open(options: { item: ActitoUserInboxItem }): Promise<{ result: ActitoNotification }>;

  markAsRead(options: { item: ActitoUserInboxItem }): Promise<void>;

  remove(options: { item: ActitoUserInboxItem }): Promise<void>;
}
