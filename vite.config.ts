import path from 'path';
import { defineConfig, loadEnv } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig(({ mode }) => {
    const env = loadEnv(mode, '.', '');
    return {
      server: {
        port: 5000,
        host: '0.0.0.0',
        allowedHosts: true,
      },
      plugins: [react()],
      resolve: {
        alias: {
          '@': path.resolve(__dirname, './src'),
        },
        extensions: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json']
      },
      build: {
        target: 'esnext',
        minify: 'esbuild',
        sourcemap: mode !== 'production',
        rollupOptions: {
          output: {
            manualChunks: {
              'react-vendor': ['react', 'react-dom', 'react-router-dom'],
              'ui-vendor': ['lucide-react', '@radix-ui/react-accordion', '@radix-ui/react-checkbox', '@radix-ui/react-dialog', '@radix-ui/react-progress', '@radix-ui/react-slot'],
              'utils': ['clsx', 'class-variance-authority', 'tailwind-merge']
            },
            chunkFileNames: 'assets/[name]-[hash].js',
            entryFileNames: 'assets/[name]-[hash].js',
            assetFileNames: 'assets/[name]-[hash].[ext]'
          }
        },
        chunkSizeWarningLimit: 1000
      },
      test: {
        globals: true,
        environment: 'jsdom',
        setupFiles: ['./src/__tests__/setup.ts'],
      }
    };
  });
