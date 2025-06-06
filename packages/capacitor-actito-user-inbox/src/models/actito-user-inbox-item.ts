import type { ActitoNotification } from 'capacitor-actito';

export interface ActitoUserInboxItem {
  readonly id: string;
  readonly notification: ActitoNotification;
  readonly time: string;
  readonly opened: boolean;
  readonly expires?: string;
}
