import { WebPlugin } from '@capacitor/core';

import type { ActitoApplication } from './models/actito-application';
import type { ActitoDevice } from './models/actito-device';
import type { ActitoDoNotDisturb } from './models/actito-do-not-disturb';
import type { ActitoDynamicLink } from './models/actito-dynamic-link';
import type { ActitoNotification } from './models/actito-notification';
import type { ActitoPlugin } from './plugin';

export class ActitoPluginWeb extends WebPlugin implements ActitoPlugin {
  //
  // Core
  //

  isConfigured(): Promise<{ result: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }

  isReady(): Promise<{ result: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }

  launch(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  unlaunch(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  getApplication(): Promise<{ result: ActitoApplication | null }> {
    throw this.unimplemented('Not implemented on web.');
  }

  fetchApplication(): Promise<{ result: ActitoApplication }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  fetchNotification(_options: { id: string }): Promise<{ result: ActitoNotification }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  fetchDynamicLink(_options: { url: string }): Promise<{ result: ActitoDynamicLink }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  canEvaluateDeferredLink(): Promise<{ result: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  evaluateDeferredLink(): Promise<{ result: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }

  //
  // Device module
  //

  getCurrentDevice(): Promise<{ result: ActitoDevice | null }> {
    throw this.unimplemented('Not implemented on web.');
  }

  getPreferredLanguage(): Promise<{ result: string | null }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  updatePreferredLanguage(_options: { language: string | null }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  register(_options: { userId: string | null; userName: string | null }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  updateUser(_options: { userId: string | null; userName: string | null }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  fetchTags(): Promise<{ result: string[] }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  addTag(_options: { tag: string }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  addTags(_options: { tags: string[] }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  removeTag(_options: { tag: string }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  removeTags(_options: { tags: string[] }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  clearTags(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  fetchDoNotDisturb(): Promise<{ result: ActitoDoNotDisturb | null }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  updateDoNotDisturb(_options: { dnd: ActitoDoNotDisturb }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  clearDoNotDisturb(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  fetchUserData(): Promise<{ result: Record<string, any> }> {
    throw this.unimplemented('Not implemented on web.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  updateUserData(_options: { userData: Record<string, any> }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  //
  // Events
  //

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  logCustom(_options: { event: string; data?: Record<string, any> }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
