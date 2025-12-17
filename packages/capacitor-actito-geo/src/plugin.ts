import type { PluginListenerHandle } from '@capacitor/core';
import { registerPlugin } from '@capacitor/core';

import type { PermissionRationale } from './actito-geo';
import type { PermissionGroup, PermissionStatus } from './enums';
import type { ActitoRegion } from './models/actito-region';

export const NativePlugin = registerPlugin<ActitoGeoPlugin>('ActitoGeoPlugin', {
  web: () => import('./web').then((m) => new m.ActitoGeoPluginWeb()),
});

export interface ActitoGeoPlugin {
  //
  // Methods
  //

  hasLocationServicesEnabled(): Promise<{ result: boolean }>;

  hasBluetoothEnabled(): Promise<{ result: boolean }>;

  getMonitoredRegions(): Promise<{ result: ActitoRegion[] }>;

  getEnteredRegions(): Promise<{ result: ActitoRegion[] }>;

  enableLocationUpdates(): Promise<void>;

  disableLocationUpdates(): Promise<void>;

  //
  // Permission utilities
  //

  checkPermissionStatus(options: { permission: PermissionGroup }): Promise<{ result: PermissionStatus }>;

  shouldShowPermissionRationale(options: { permission: PermissionGroup }): Promise<{ result: boolean }>;

  presentPermissionRationale(options: { permission: PermissionGroup; rationale: PermissionRationale }): Promise<void>;

  requestPermission(options: { permission: PermissionGroup }): Promise<{ result: PermissionStatus }>;

  openAppSettings(): Promise<void>;

  //
  // Event bridge
  //

  addListener(eventName: string, listenerFunc: (data: any) => void): Promise<PluginListenerHandle>;
}
