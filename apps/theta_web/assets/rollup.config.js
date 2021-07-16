import resolve from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import {babel} from '@rollup/plugin-babel';
import { terser } from "rollup-plugin-terser";
import precss from 'precss';
import postcss from 'rollup-plugin-postcss';
import copy from 'rollup-plugin-copy';

export default [
    {
        input: 'js/front.js',
        output: {
            dir: '../priv/static',
            name: 'bundle_name',
            entryFileNames: "js/[name].js",
            format: 'iife',
        },
        plugins: [
            // babel({babelHelpers: 'bundled'}),
            postcss({
                // extract: true,
                extract: 'css/front.css',
                minimize: true,
                plugins: [
                    precss(),
                ]
            }),
            copy({
                targets: [
                    { src: 'static', dest: '../priv' }
                ]
            }),
            terser()
        ],
    },
    {
        input: 'js/app.js',
        output: {
            dir: '../priv/static',
            name: 'bundle_name',
            entryFileNames: "js/[name].js",
            format: 'iife',
        },
        plugins: [
            resolve({
                browser: true
            }),
            commonjs(),
            babel({babelHelpers: 'bundled'}),
            postcss({
                // extract: true,
                extract: 'css/app.css',
                minimize: true,
                plugins: [
                    precss(),
                ]
            }),
            terser({
                format: {
                    comments: /^1/,
                },
            })
        ],
    },
    {
        input: 'js/editor.js',
        output: {
            dir: '../priv/static',
            name: 'editor',
            entryFileNames: "js/[name].js",
            format: 'iife',
        },
        plugins: [
            resolve({
                browser: true
            }),
            commonjs(),
            babel({babelHelpers: 'bundled'}),
            postcss({
                // extract: true,
                extract: 'css/editor.css',
                minimize: true,
                plugins: [
                    precss(),
                ]
            }),
            terser()
        ],
    }
];