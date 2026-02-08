
function pretty_path() {
  local PWD_PATH="$PWD"

  # 拆分路径
  IFS='/' read -r -a parts <<< "$PWD_PATH"

  # 只保留最后 4 层
  local start=$(( ${#parts[@]} > 4 ? ${#parts[@]} - 4 : 0 ))
  local trimmed=("${parts[@]:start}")

  local indent=""
  local out=""
  local grays=(235 237 239 241 243 245 247 249 251 253)

  out+="\n"
  out+="[=^･ω･^=]meow!\n"

  local idx=0
  local current_path="$PWD_PATH"

  # 从最深层往上裁剪路径
  for ((i=${#trimmed[@]}-1; i>=0; i--)); do
    current_path="${current_path%/*}"
  done

  for p in "${trimmed[@]}"; do
    [[ -z "$p" ]] && continue

    current_path="$current_path/$p"

    # 判断是否是 git 根目录
    local git_flag=""
    if [[ -d "$current_path/.git" ]]; then
      git_flag="[git]"
    fi

    local bg=${grays[$((idx % ${#grays[@]}))]}
    out+="${indent}\e[48;5;${bg}m└── $p\e[0m $git_flag\n"

    indent="$indent    "
    ((idx++))
  done

  out+="\e[40m──────────────────────────\e[0m\n"
  out+="\e[40m$(date +%Y-%m-%d) $(date +%H:%M:%S)\e[0m "
  out+="$ "
  
  printf "%b" "$out"
}

# 启用动态 prompt
PS1='$(pretty_path)'
