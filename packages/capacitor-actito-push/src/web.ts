import { WebPlugin } from '@capacitor/core';

import type { PushPermissionRationale } from './actito-push';
import type { PushPermissionStatus } from './enums';
import type { ActitoPushSubscription } from './models/actito-push-subscription';
import type { ActitoTransport } from './models/actito-transport';
import type { ActitoPushPlugin } from './plugin';

export class ActitoPushPluginWeb extends WebPlugin implements ActitoPushPlugin {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  setAuthorizationOptions(_options: { options: string[] }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  setCategoryOptions(_options: { options: string[] }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  setPresentationOptions(_options: { options: string[] }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  hasRemoteNotificationsEnabled(): Promise<{ result: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  getTransport(): Promise<{ result: ActitoTransport | null }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  getSubscription(): Promise<{ result: ActitoPushSubscription | null }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  allowedUI(): Promise<{ result: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  enableRemoteNotifications(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  disableRemoteNotifications(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  checkPermissionStatus(): Promise<{ result: PushPermissionStatus }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  shouldShowPermissionRationale(): Promise<{ result: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  presentPermissionRationale(_options: { rationale: PushPermissionRationale }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  requestPermission(): Promise<{ result: PushPermissionStatus }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  openAppSettings(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
