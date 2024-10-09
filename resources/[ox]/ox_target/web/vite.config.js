import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import svgrPlugin from 'vite-plugin-svgr';
import tsconfigPaths from 'vite-tsconfig-paths';
import * as path from 'path';
// https://vitejs.dev/config/
export default defineConfig({
    plugins: [react(), svgrPlugin(), tsconfigPaths()],
    base: './',
    build: {
        outDir: 'build',
    },
    resolve: {
        alias: {
            '@': path.resolve(__dirname, './src'),
        },
    },
    publicDir: 'public',
});
