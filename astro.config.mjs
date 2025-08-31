// @ts-check
import { defineConfig } from 'astro/config';

import { siteConfig } from './src/config';

const { siteUrl } = siteConfig;

// https://astro.build/config
export default defineConfig({
  site: 'https://nono-k.github.io',
  base: 'book-of-realtime-graphics-math',
  vite: {
    css: {
      preprocessorOptions: {
        scss: {
          additionalData: '@use "src/styles/mixin.scss";',
        },
      },
    },
  },
});
