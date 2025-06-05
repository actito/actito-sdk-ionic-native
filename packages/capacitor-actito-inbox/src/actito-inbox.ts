import type { PluginListenerHandle } from '@capacitor/core';
import type { ActitoNotification } from 'capacitor-actito';

import type { ActitoInboxItem } from './models/actito-inbox-item';
import { NativePlugin } from './plugin';

export class ActitoInbox {
  //
  // Methods
  //

  /**
   * @returns {Promise<ActitoInboxItem[]>} - A promise that resolves to a
   * list of all {@link ActitoInboxItem}, sorted by the timestamp.
   */
  public static async getItems(): Promise<ActitoInboxItem[]> {
    const { result } = await NativePlugin.getItems();
    return result;
  }

  /**
   * @returns {Promise<number>} - A promise that resolves to the current badge
   * count, representing the number of unread inbox items.
   */
  public static async getBadge(): Promise<number> {
    const { result } = await NativePlugin.getBadge();
    return result;
  }

  /**
   * Refreshes the inbox data, ensuring the items and badge count reflect the
   * latest server state.
   *
   * @returns {Promise<void>} - A promise that resolves when the inbox data has
   * been successfully refreshed.
   */
  public static async refresh(): Promise<void> {
    await NativePlugin.refresh();
  }

  /**
   * Opens a specified inbox item, marking it as read and returning the
   * associated notification.
   *
   * @param {ActitoInboxItem} item - The {@link ActitoInboxItem} to open.
   * @return {Promise<ActitoNotification>} - The {@link ActitoNotification}
   * associated with the inbox item.
   */
  public static async open(item: ActitoInboxItem): Promise<ActitoNotification> {
    const { result } = await NativePlugin.open({ item });
    return result;
  }

  /**
   * Marks the specified inbox item as read.
   *
   * @param {ActitoInboxItem} item - The {@link ActitoInboxItem} to mark
   * as read.
   * @returns {Promise<void>} - A promise that resolves when the inbox item has
   * been successfully marked as read.
   */
  public static async markAsRead(item: ActitoInboxItem): Promise<void> {
    await NativePlugin.markAsRead({ item });
  }

  /**
   * Marks all inbox items as read.
   *
   * @returns {Promise<void>} - A promise that resolves when all inbox items
   * have been successfully marked as read.
   */
  public static async markAllAsRead(): Promise<void> {
    await NativePlugin.markAllAsRead();
  }

  /**
   * Permanently removes the specified inbox item from the inbox.
   *
   * @param {ActitoInboxItem} item - The {@link ActitoInboxItem} to remove.
   * @returns {Promise<void>} - A promise that resolves when the inbox item has
   * been successfully removed.
   */
  public static async remove(item: ActitoInboxItem): Promise<void> {
    await NativePlugin.remove({ item });
  }

  /**
   * Clears all inbox items, permanently deleting them from the inbox.
   *
   * @returns {Promise<void>} - A promise that resolves when all inbox items
   * have been successfully cleared.
   */
  public static async clear(): Promise<void> {
    await NativePlugin.clear();
  }

  //
  // Events
  //

  /**
   * Called when the inbox is successfully updated.
   *
   * @param callback - A callback that will be invoked with the result of the
   * onInboxUpdated event. It will provide an updated list of
   * {@link ActitoInboxItem}.
   * @returns {Promise<PluginListenerHandle>} - A promise that resolves to a
   * {@link PluginListenerHandle} for the onInboxUpdated event.
   */
  public static async onInboxUpdated(callback: (items: ActitoInboxItem[]) => void): Promise<PluginListenerHandle> {
    return await NativePlugin.addListener('inbox_updated', ({ items }) => callback(items));
  }

  /**
   * Called when the unread message count badge is updated.
   *
   * @param callback - A callback that will be invoked with the
   * result of the onBadgeUpdated event. It will provide an updated badge count,
   * representing current the number of unread inbox items.
   * @returns {Promise<PluginListenerHandle>} - A promise that resolves to a
   * {@link PluginListenerHandle} for the onBadgeUpdated event.
   */
  public static async onBadgeUpdated(callback: (badge: number) => void): Promise<PluginListenerHandle> {
    return await NativePlugin.addListener('badge_updated', ({ badge }) => callback(badge));
  }
}
