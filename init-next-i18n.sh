function update_or_create_file() {
  local folder="$1"
  local filename="$2"
  local github_base_url="https://raw.githubusercontent.com/walkccc/snippets/main/${folder}"

  # Encode special characters for the GitHub URL.
  local encoded_filename="${filename//[/%5B}"
  encoded_filename="${encoded_filename//]/%5D}"
  local source_url="$github_base_url/$encoded_filename"

  local directory=$(dirname "$filename")

  # Ensure the target directory exists.
  mkdir -p "$directory"

  # Define color codes.
  local RED="\033[31m"
  local GREEN="\033[32m"
  local BLUE="\033[94m"
  local RESET="\033[0m"

  # Define column widths for alignment
  local FILENAME_WIDTH=40
  local URL_WIDTH=80

  # Fetch content from GitHub and update or create the target file.
  if curl -s --fail "$source_url" -o "$filename"; then
    printf "✅ ${GREEN}%-${FILENAME_WIDTH}s${RESET} <- ${BLUE}%-${URL_WIDTH}s${RESET}\n" "$filename" "$source_url"
  else
    printf "❌ ${RED}%-${FILENAME_WIDTH}s${RESET} ${RED}Failed to fetch${RESET} from ${BLUE}%-${URL_WIDTH}s${RESET}. Aborting.\n" "$filename" "$source_url"
    return 1
  fi
}

update_or_create_file "init-next-i18n" "middleware.ts"
update_or_create_file "init-next-i18n" "next.config.ts"
update_or_create_file "init-next-i18n" "tailwind.config.ts"
update_or_create_file "init-next-i18n" "app/layout.tsx"
update_or_create_file "init-next-i18n" "app/[locale]/layout.tsx"
update_or_create_file "init-next-i18n" "app/[locale]/(marketing)/layout.tsx"
update_or_create_file "init-next-i18n" "app/[locale]/(marketing)/page.tsx"
update_or_create_file "init-next-i18n" "components/appearance-toggle.tsx"
update_or_create_file "init-next-i18n" "components/footer.tsx"
update_or_create_file "init-next-i18n" "components/icons.tsx"
update_or_create_file "init-next-i18n" "components/language-toggle.tsx"
update_or_create_file "init-next-i18n" "components/mobile-nav.tsx"
update_or_create_file "init-next-i18n" "components/mobile-toggle.tsx"
update_or_create_file "init-next-i18n" "components/navbar.tsx"
update_or_create_file "init-next-i18n" "components/tailwind-indicator.tsx"
update_or_create_file "init-next-i18n" "components/theme-provider.tsx"
update_or_create_file "init-next-i18n" "config/marketing.ts"
update_or_create_file "init-next-i18n" "config/site.ts"
update_or_create_file "init-next-i18n" "hooks/use-lock-body.ts"
update_or_create_file "init-next-i18n" "i18n/request.ts"
update_or_create_file "init-next-i18n" "i18n/routing.ts"
update_or_create_file "init-next-i18n" "public/locales/en.json"
update_or_create_file "init-next-i18n" "public/locales/zh.json"
update_or_create_file "init-next-i18n" "types/index.ts"

npm install next-intl
npm install next-themes
npm install -D @tailwindcss/typography
npx shadcn@latest add button dropdown-menu toast

update_or_create_file "init-next-i18n" "hooks/use-toast.ts"

git add .
git commit -m $'feat(ui): add `app/layout` and `app/[locale]/(marketing)`\n\n```bash\nbash <(curl -s https://raw.githubusercontent.com/walkccc/snippets/main/init-next-i18n.sh)\n```'
