import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.actito.sample.app',
  appName: 'sample',
  webDir: 'build',
  android: {
    adjustMarginsForEdgeToEdge: 'force',
  },
};

export default config;
