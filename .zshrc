setopt prompt_subst

function pretty_path() {
  IFS='/' read -r -A parts <<< "$PWD"

  # 只保留最后 4 层
  parts=("${parts[@]: -4}")

  local indent=""
  local out=""
  local grays=(235 237 239 241 243 245 247 249 251 253)

  out+="\n"
  out+="%K{black}₍˄·͈༝·͈˄*₎◞ ̑̑ meow!%k\n"

  local idx=0
  local current_path="$PWD"

  # 从最深层往上裁剪路径
  for ((i=${#parts[@]}-1; i>=0; i--)); do
    current_path="${current_path%/*}"
  done

  for p in "${parts[@]}"; do
    [[ -z "$p" ]] && continue

    # 当前层路径
    current_path="$current_path/$p"

    # 判断是否是 git 根目录
    local git_flag=""
    if [[ -d "$current_path/.git" ]]; then
      git_flag="[git]"
    fi

    local bg=${grays[$((idx % ${#grays[@]}))]}
    out+="${indent}%K{$bg}└── $p%k $git_flag\n"

    indent="$indent    "
    ((idx++))
  done

  out+="%K{black}──────────────────────────%k\n"
  out+="%K{black}%D{%Y-%m-%d} %*%k "
  out+="$"

  printf "%b" "$out"
}

PS1='$(pretty_path)'
