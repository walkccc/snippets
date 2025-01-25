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

function remove_file() {
  local filename="$1"

  if [ -f "$filename" ]; then
    rm "$filename"
    echo "$filename has been removed."
  fi
}

npm install -D eslint-plugin-simple-import-sort husky prettier prettier-plugin-tailwindcss

npx husky init

update_or_create_file "init-next" ".husky/pre-commit"
update_or_create_file "init-next" ".env.example"
update_or_create_file "init-next" ".gitignore"
update_or_create_file "init-next" ".prettierrc"
update_or_create_file "init-next" "eslint.config.mjs"

remove_file "app/page.tsx"
remove_file "app/favicon.ico"

git commit # to trigger husky
git add .
git commit -m $'chore: standard initial setup\n\n```bash\nbash <(curl -s https://raw.githubusercontent.com/walkccc/snippets/main/init-next.sh)\n```'
