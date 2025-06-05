import type { PluginListenerHandle } from '@capacitor/core';
import { registerPlugin } from '@capacitor/core';

import type { ActitoApplication } from './models/actito-application';
import type { ActitoDevice } from './models/actito-device';
import type { ActitoDoNotDisturb } from './models/actito-do-not-disturb';
import type { ActitoDynamicLink } from './models/actito-dynamic-link';
import type { ActitoNotification } from './models/actito-notification';

export const _Actito = registerPlugin<ActitoPlugin>('ActitoPlugin', {
  web: () => import('./web').then((m) => new m.ActitoPluginWeb()),
});

export interface ActitoPlugin {
  //
  // Core
  //

  isConfigured(): Promise<{ result: boolean }>;

  isReady(): Promise<{ result: boolean }>;

  launch(): Promise<void>;

  unlaunch(): Promise<void>;

  getApplication(): Promise<{ result: ActitoApplication | null }>;

  fetchApplication(): Promise<{ result: ActitoApplication }>;

  fetchNotification(options: { id: string }): Promise<{ result: ActitoNotification }>;

  fetchDynamicLink(options: { url: string }): Promise<{ result: ActitoDynamicLink }>;

  canEvaluateDeferredLink(): Promise<{ result: boolean }>;

  evaluateDeferredLink(): Promise<{ result: boolean }>;

  //
  // Device module
  //

  getCurrentDevice(): Promise<{ result: ActitoDevice | null }>;

  getPreferredLanguage(): Promise<{ result: string | null }>;

  updatePreferredLanguage(options: { language: string | null }): Promise<void>;

  /**
   * @deprecated Use updateUser() instead.
   */
  register(options: { userId: string | null; userName: string | null }): Promise<void>;

  updateUser(options: { userId: string | null; userName: string | null }): Promise<void>;

  fetchTags(): Promise<{ result: string[] }>;

  addTag(options: { tag: string }): Promise<void>;

  addTags(options: { tags: string[] }): Promise<void>;

  removeTag(options: { tag: string }): Promise<void>;

  removeTags(options: { tags: string[] }): Promise<void>;

  clearTags(): Promise<void>;

  fetchDoNotDisturb(): Promise<{ result: ActitoDoNotDisturb | null }>;

  updateDoNotDisturb(options: { dnd: ActitoDoNotDisturb }): Promise<void>;

  clearDoNotDisturb(): Promise<void>;

  fetchUserData(): Promise<{ result: Record<string, any> }>;

  updateUserData(options: { userData: Record<string, any> }): Promise<void>;

  //
  // Events module
  //

  logCustom(options: { event: string; data?: Record<string, any> }): Promise<void>;

  //
  // Event bridge
  //

  addListener(eventName: string, listenerFunc: (data: any) => void): Promise<PluginListenerHandle>;
}
