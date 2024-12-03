import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import checker from "vite-plugin-checker";

export default defineConfig({
    server: {
        host: '0.0.0.0',
        hmr: {
            host: 'localhost',
        }
    },
    plugins: [
        laravel({
            input: [
                'resources/css/app.css',
                'resources/ts/app.ts',
            ],
            refresh: true,
        }),
        checker({ typescript: true })
    ],
});