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

ESLINTRC='{
  "extends": "next/core-web-vitals",
  "ignorePatterns": [".next/**", "node_modules/**"],
  "plugins": ["simple-import-sort"],
  "rules": {
    "simple-import-sort/imports": "error",
    "simple-import-sort/exports": "error"
  }
}'

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
update_or_create_file ".eslintrc.json" "$ESLINTRC"
update_or_create_file ".gitignore" "$GITIGNORE"
update_or_create_file ".husky/pre-commit" "$HUSKY_PRE_COMMIT"

remove_file "app/page.tsx"
remove_file "app/favicon.ico"

git commit # to trigger husky
git add .
git commit -m 'chore: standard initial setup'
