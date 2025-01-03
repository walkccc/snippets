#!/bin/bash

PRETTIERRC='{
  "endOfLine": "lf",
  "proseWrap": "always",
  "printWidth": 80,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "all",
  "useTabs": false,
  "plugins": ["prettier-plugin-tailwindcss"]
}'

ESLINT_CONFIG="import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { FlatCompat } from '@eslint/eslintrc';
import js from '@eslint/js';
import simpleImportSort from 'eslint-plugin-simple-import-sort';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const compat = new FlatCompat({
  baseDirectory: __dirname,
  recommendedConfig: js.configs.recommended,
  allConfig: js.configs.all,
});

const eslintConfig = [
  {
    ignores: ['**/.next/', '**/node_modules/'],
  },
  ...compat.extends('next/core-web-vitals', 'next/typescript'),
  {
    plugins: {
      'simple-import-sort': simpleImportSort,
    },
    rules: {
      'simple-import-sort/imports': 'error',
      'simple-import-sort/exports': 'error',
    },
  },
];

export default eslintConfig;"

GITIGNORE='# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js
.yarn/install-state.gz

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# local env files
.env*.local
.env

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts

# velite files
.velite'

ENV_EXAMPLE='# -----------------------------------------------------------------------------
# Authentication (Auth.js)
# -----------------------------------------------------------------------------
NEXTAUTH_SECRET=

GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=

# -----------------------------------------------------------------------------
# Database (PostgreSQL - Neon.tech)
# -----------------------------------------------------------------------------
DIRECT_URL=
DATABASE_URL=

# -----------------------------------------------------------------------------
# Stripe (dev)
# -----------------------------------------------------------------------------
NEXT_PUBLIC_APP_URL=http://localhost:3000
STRIPE_SECRET_KEY=sk_test_
STRIPE_WEBHOOK_SECRET=whsec_
STRIPE_PRO_MONTHLY_PLAN_ID=price_

# -----------------------------------------------------------------------------
# Stripe (prod)
# -----------------------------------------------------------------------------
STRIPE_API_KEY=pk_test_'

HUSKY_PRE_COMMIT='prettier . -w
npx eslint --fix .
git add -A .'

function update_or_create_file() {
  local filename="$1"
  local content="$2"

  if [ -f "$filename" ]; then
    echo "$content" >| "$filename"
    echo "$filename has been updated."
  else
    echo "$content" > "$filename"
    echo "$filename has been created."
  fi
}

function remove_file() {
  local filename="$1"

  if [ -f "$filename" ]; then
    rm "$filename"
    echo "$filename has been removed."
  fi
}

npm install -D eslint-plugin-simple-import-sort husky prettier prettier-plugin-tailwindcss

npx husky init

update_or_create_file ".prettierrc" "$PRETTIERRC"
update_or_create_file ".eslint.config.mjs" "$ESLINT_CONFIG"
update_or_create_file ".gitignore" "$GITIGNORE"
update_or_create_file ".husky/pre-commit" "$HUSKY_PRE_COMMIT"
update_or_create_file ".env.example" "$ENV_EXAMPLE"

remove_file "app/page.tsx"
remove_file "app/favicon.ico"

git commit # to trigger husky
git add .
git commit -m $'chore: standard initial setup\n\n```bash\nbash <(curl -s https://raw.githubusercontent.com/walkccc/snippets/main/init-next.sh)\n```'
