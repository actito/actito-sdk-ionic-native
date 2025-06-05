import { WebPlugin } from '@capacitor/core';

import type { PermissionRationale } from './actito-geo';
import type { PermissionGroup, PermissionStatus } from './enums';
import type { ActitoRegion } from './models/actito-region';
import type { ActitoGeoPlugin } from './plugin';

export class ActitoGeoPluginWeb extends WebPlugin implements ActitoGeoPlugin {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  hasLocationServicesEnabled(): Promise<{ result: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  hasBluetoothEnabled(): Promise<{ result: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  getMonitoredRegions(): Promise<{ result: ActitoRegion[] }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  getEnteredRegions(): Promise<{ result: ActitoRegion[] }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  enableLocationUpdates(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  disableLocationUpdates(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  checkPermissionStatus(_options: { permission: PermissionGroup }): Promise<{ result: PermissionStatus }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  shouldShowPermissionRationale(_options: { permission: PermissionGroup }): Promise<{ result: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  presentPermissionRationale(_options: { permission: PermissionGroup; rationale: PermissionRationale }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  requestPermission(_options: { permission: PermissionGroup }): Promise<{ result: PermissionStatus }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  openAppSettings(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
