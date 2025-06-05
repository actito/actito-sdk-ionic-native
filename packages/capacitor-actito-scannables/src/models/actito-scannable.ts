import type { ActitoNotification } from 'capacitor-actito';

export interface ActitoScannable {
  readonly id: string;
  readonly name: string;
  readonly tag: string;
  readonly type: string;
  readonly notification?: ActitoNotification;
}
