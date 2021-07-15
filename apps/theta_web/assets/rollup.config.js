import {babel} from '@rollup/plugin-babel';
// import autoprefixer from 'autoprefixer'
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
            babel({babelHelpers: 'bundled'}),
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
            })
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
            babel({babelHelpers: 'bundled'}),
            postcss({
                // extract: true,
                extract: 'css/app.css',
                minimize: true,
                plugins: [
                    precss(),
                ]
            })
        ],
    },
    {
        input: 'js/editor.js',
        output: {
            dir: '../priv/static',
            name: 'bundle_name',
            entryFileNames: "js/[name].js",
            format: 'iife',
        },
        plugins: [
            babel({babelHelpers: 'bundled'}),
            postcss({
                // extract: true,
                extract: 'css/editor.css',
                minimize: true,
                plugins: [
                    precss(),
                ]
            })
        ],
    }
];