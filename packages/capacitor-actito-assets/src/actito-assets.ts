import type { ActitoAsset } from './models/actito-asset';
import { NativePlugin } from './plugin';

export class ActitoAssets {
  /**
   * Fetches a list of {@link ActitoAsset} for a specified group.
   *
   * @param {string} group - The name of the group whose assets are to be fetched.
   * @returns {Promise<ActitoAsset[]>} - A promise that resolves to a list of
   * {@link ActitoAsset} belonging to the specified group.
   */
  public static async fetch(group: string): Promise<ActitoAsset[]> {
    const { result } = await NativePlugin.fetch({ group });
    return result;
  }
}
