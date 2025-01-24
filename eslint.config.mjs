/** @format */

// Rules can be found at https://eslint.org/docs/latest/rules/?utm_source
// eslint.config.mjs
//import js from '/usr/local/lib/node_modules/@eslint/js/src/index.js';
//import tsPlugin from '/usr/local/lib/node_modules/@typescript-eslint/eslint-plugin/dist/index.js';
//import tsParser from '/usr/local/lib/node_modules/@typescript-eslint/parser/dist/index.js';
//import reactPlugin from '/usr/local/lib/node_modules/eslint-plugin-react/index.js';
//import prettierConfig from '/usr/local/lib/node_modules/eslint-config-prettier/build/index.js';
//import prettierPlugin from '/usr/local/lib/node_modules/eslint-plugin-prettier/eslint-plugin-prettier.js';

//import prettier from '/usr/local/lib/node_modules/prettier/index.mjs';

import { homedir } from 'os';
import { resolve } from 'path';
import { createRequire } from 'module';

const require = createRequire(import.meta.url);

const js = require('@eslint/js');
const tsPlugin = require('@typescript-eslint/eslint-plugin');
const tsParser = require('@typescript-eslint/parser');
const reactPlugin = require('eslint-plugin-react');
const prettierConfig = require('eslint-config-prettier');
const prettierPlugin = require('eslint-plugin-prettier');
const prettier = require('prettier');

const prettierConfigPath = resolve(homedir(), '.config/prettier/.prettierrc');
const prettierOptions = await prettier.resolveConfig(prettierConfigPath);

//console.log(require.resolve('@eslint/js'));
//console.log(require.resolve('@typescript-eslint/eslint-plugin'));
//console.log(require.resolve('@typescript-eslint/parser'));
//console.log(require.resolve('eslint-plugin-react'));
//console.log(require.resolve('eslint-config-prettier'));
//console.log(require.resolve('eslint-plugin-prettier'));
//console.log(require.resolve('prettier'));

const jscustomRules = {
   ...js.configs.recommended.rules,
   'default-case': 'error',
   'accessor-pairs': 'error',
   'arrow-body-style': ['error', 'always'],
   'block-scoped-var': 'error',
   camelcase: ['error', { properties: 'never' }],
   'class-methods-use-this': 'error',
   'consistent-this': 'error',
   curly: ['error', 'all'],
   'default-case': 'error',
   'default-case-last': 'error',
   'dot-notation': 'error',
   eqeqeq: 'error',
   'prettier/prettier': ['error', prettierOptions || {}],
   ...prettierConfig.rules
};

const jsxcustomRules = {
   ...js.configs.recommended.rules,
   ...reactPlugin.configs.recommended.rules,
   'default-case': 'error',
   'accessor-pairs': 'error',
   'arrow-body-style': ['error', 'always'],
   'block-scoped-var': 'error',
   camelcase: ['error', { properties: 'never' }],
   'class-methods-use-this': 'error',
   'consistent-this': 'error',
   curly: ['error', 'all'],
   'default-case': 'error',
   'default-case-last': 'error',
   'dot-notation': 'error',
   eqeqeq: 'error',
   'prettier/prettier': ['error', prettierOptions || {}],
   'react/prop-types': 'off',
   ...prettierConfig.rules
};

const tscustomRules = {
   ...js.configs.recommended.rules,
   ...tsPlugin.configs.recommended.rules,
   'default-case': 'error',
   'accessor-pairs': 'error',
   'arrow-body-style': ['error', 'always'],
   'block-scoped-var': 'error',
   camelcase: ['error', { properties: 'never' }],
   'class-methods-use-this': 'error',
   'consistent-this': 'error',
   curly: ['error', 'all'],
   'default-case': 'error',
   'default-case-last': 'error',
   'dot-notation': 'error',
   eqeqeq: 'error',
   'prettier/prettier': ['error', prettierOptions || {}],
   '@typescript-eslint/explicit-function-return-type': 'error',
   ...prettierConfig.rules
};

const tsxcustomRules = {
   ...js.configs.recommended.rules,
   ...tsPlugin.configs.recommended.rules,
   ...reactPlugin.configs.recommended.rules,
   'default-case': 'error',
   'accessor-pairs': 'error',
   'arrow-body-style': ['error', 'always'],
   'block-scoped-var': 'error',
   camelcase: ['error', { properties: 'never' }],
   'class-methods-use-this': 'error',
   'consistent-this': 'error',
   curly: ['error', 'all'],
   'default-case': 'error',
   'default-case-last': 'error',
   'dot-notation': 'error',
   eqeqeq: 'error',
   'prettier/prettier': ['error', prettierOptions || {}],
   'react/prop-types': 'off',
   '@typescript-eslint/no-unused-vars': 'warn',
   ...prettierConfig.rules
};

export default [
   {
      files: ['**/*.js'],
      languageOptions: {
         ecmaVersion: 'latest',
         sourceType: 'module',
         parserOptions: {
            ecmaFeatures: {
               jsx: false
            }
         }
      },
      plugins: {
         prettier: prettierPlugin
      },
      rules: {
         ...jscustomRules
      }
   },
   {
      files: ['**/*.jsx'],
      languageOptions: {
         ecmaVersion: 'latest',
         sourceType: 'module',
         parserOptions: {
            ecmaFeatures: {
               jsx: true
            }
         }
      },
      plugins: {
         react: reactPlugin,
         prettier: prettierPlugin
      },
      rules: {
         ...jsxcustomRules
      }
   },
   {
      files: ['**/*.ts'],
      languageOptions: {
         parser: tsParser,
         parserOptions: {
            ecmaVersion: 'latest',
            sourceType: 'module',
            project: './tsconfig.json',
            ecmaFeatures: {
               jsx: false
            }
         }
      },
      plugins: {
         '@typescript-eslint': tsPlugin,
         prettier: prettierPlugin
      },
      rules: {
         ...tscustomRules
      }
   },
   {
      files: ['**/*.tsx'],
      languageOptions: {
         parser: tsParser,
         parserOptions: {
            ecmaVersion: 'latest',
            sourceType: 'module',
            project: './tsconfig.json',
            ecmaFeatures: {
               jsx: true
            }
         }
      },
      plugins: {
         '@typescript-eslint': tsPlugin,
         react: reactPlugin,
         prettier: prettierPlugin
      },
      rules: {
         ...tsxcustomRules
      }
   }
];
