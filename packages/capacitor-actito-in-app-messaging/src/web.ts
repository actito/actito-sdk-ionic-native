import { WebPlugin } from '@capacitor/core';

import type { ActitoInAppMessagingPlugin } from './plugin';

export class ActitoInAppMessagingPluginWeb extends WebPlugin implements ActitoInAppMessagingPlugin {
  hasMessagesSuppressed(): Promise<{ result: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  setMessagesSuppressed(_options: { suppressed: boolean; evaluateContext?: boolean }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
