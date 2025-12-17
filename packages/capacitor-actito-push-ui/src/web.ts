import { WebPlugin } from '@capacitor/core';
import type { ActitoNotification, ActitoNotificationAction } from 'capacitor-actito';

import type { ActitoPushUIPlugin } from './plugin';

export class ActitoPushUIPluginWeb extends WebPlugin implements ActitoPushUIPlugin {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  presentNotification(_options: { notification: ActitoNotification }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  presentAction(_options: { notification: ActitoNotification; action: ActitoNotificationAction }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
