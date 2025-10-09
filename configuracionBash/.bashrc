# ==== Prompt personalizado por drymnz ====

# Colores
RESET='\[\e[0m\]'
BOLD='\[\e[1m\]'
RED='\[\e[31m\]'
GREEN='\[\e[32m\]'
BLUE='\[\e[34m\]'
CYAN='\[\e[36m\]'
YELLOW='\[\e[33m\]'

# Obtener la rama Git actual
_git_branch() {
  command -v git >/dev/null 2>&1 || return
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
  branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  [ -n "$branch" ] && printf " (${branch})"
}

# Mostrar solo carpeta padre + actual, con prefijo ../ si hay más arriba
_short_path() {
  local path="$PWD"
  local base=$(basename "$path")
  local parent=$(basename "$(dirname "$path")")

  # si estamos en home directo
  if [[ "$path" == "$HOME" ]]; then
    echo "~"
    return
  fi

  # si hay más niveles encima del padre
  local grandparent="$(dirname "$(dirname "$path")")"
  if [[ "$grandparent" != "/" && "$grandparent" != "$HOME" ]]; then
    echo "../${parent}/${base}"
  else
    echo "${parent}/${base}"
  fi
}

# Construcción dinámica del prompt
_set_prompt() {
  local git=$(_git_branch)
  local path=$(_short_path)

  if [ "$EUID" -eq 0 ]; then
    # ROOT prompt
    PS1="${RED}[root ${YELLOW}${path}${RED}]${RESET}\n# "
  else
    # Usuario normal
    PS1="${CYAN}[user@${GREEN}\h ${BLUE}${path}${YELLOW}${git}${CYAN}]${RESET}\n$ "
  fi
}

PROMPT_COMMAND=_set_prompt

# ==== Fin del prompt ====
