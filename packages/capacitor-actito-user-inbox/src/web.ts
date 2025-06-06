import { WebPlugin } from '@capacitor/core';
import type { ActitoNotification } from 'capacitor-actito';

import type { ActitoUserInboxItem } from './models/actito-user-inbox-item';
import type { ActitoUserInboxResponse } from './models/actito-user-inbox-response';
import type { ActitoUserInboxPlugin } from './plugin';

export class ActitoUserInboxPluginWeb extends WebPlugin implements ActitoUserInboxPlugin {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async parseResponseFromJson(_options: { json: Record<string, any> }): Promise<{ result: ActitoUserInboxResponse }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  parseResponseFromString(_options: { json: string }): Promise<{ result: ActitoUserInboxResponse }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  open(_options: { item: ActitoUserInboxItem }): Promise<{ result: ActitoNotification }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  markAsRead(_options: { item: ActitoUserInboxItem }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  remove(_options: { item: ActitoUserInboxItem }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
