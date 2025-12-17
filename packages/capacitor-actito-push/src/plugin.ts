import type { PluginListenerHandle } from '@capacitor/core';
import { registerPlugin } from '@capacitor/core';

import type { PushPermissionRationale } from './actito-push';
import type { PushPermissionStatus } from './enums';
import type { ActitoPushSubscription } from './models/actito-push-subscription';
import type { ActitoTransport } from './models/actito-transport';

export const NativePlugin = registerPlugin<ActitoPushPlugin>('ActitoPushPlugin', {
  web: () => import('./web').then((m) => new m.ActitoPushPluginWeb()),
});

export interface ActitoPushPlugin {
  //
  // Methods
  //

  setAuthorizationOptions(options: { options: string[] }): Promise<void>;

  setCategoryOptions(options: { options: string[] }): Promise<void>;

  setPresentationOptions(options: { options: string[] }): Promise<void>;

  hasRemoteNotificationsEnabled(): Promise<{ result: boolean }>;

  getTransport(): Promise<{ result: ActitoTransport | null }>;

  getSubscription(): Promise<{ result: ActitoPushSubscription | null }>;

  allowedUI(): Promise<{ result: boolean }>;

  enableRemoteNotifications(): Promise<void>;

  disableRemoteNotifications(): Promise<void>;

  //
  // Permission utilities
  //

  checkPermissionStatus(): Promise<{ result: PushPermissionStatus }>;

  shouldShowPermissionRationale(): Promise<{ result: boolean }>;

  presentPermissionRationale(options: { rationale: PushPermissionRationale }): Promise<void>;

  requestPermission(): Promise<{ result: PushPermissionStatus }>;

  openAppSettings(): Promise<void>;

  //
  // Event bridge
  //

  addListener(eventName: string, listenerFunc: (data: any) => void): Promise<PluginListenerHandle>;
}
