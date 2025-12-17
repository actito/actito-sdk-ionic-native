import { WebPlugin } from '@capacitor/core';
import type { ActitoNotification } from 'capacitor-actito';

import type { ActitoInboxItem } from './models/actito-inbox-item';
import type { ActitoInboxPlugin } from './plugin';

export class ActitoInboxPluginWeb extends WebPlugin implements ActitoInboxPlugin {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  getItems(): Promise<{ result: ActitoInboxItem[] }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  getBadge(): Promise<{ result: number }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  refresh(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  open(_options: { item: ActitoInboxItem }): Promise<{ result: ActitoNotification }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  markAsRead(_options: { item: ActitoInboxItem }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  markAllAsRead(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  remove(_options: { item: ActitoInboxItem }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  clear(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
