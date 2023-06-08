# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias clip='xclip -selection c'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../../'


alias mkdir='mkdir -p'

alias dc='docker compose'
alias dd='docker'
alias t='gnome-terminal'
alias x='exit'

function mk-exec-file() {
  if [ $# -ne 1 ]; then
    echo "missing argment ..."
    echo "example: mkfile ${file-neme}"
    exit 1
  fi
  local filename=$1
  touch $filename && chmod +x $filename
}

function dps() {
  declare -a format
  local is_default=true
  local OPTIND
  local OPTARG
  local OPT
  OLDIFS=$IFS
  format=("{{.ID}}")
  isAll=''
  onlyID=''
  while getopts aisnltqh OPT
  do
    case ${OPT} in
      a) isAll="-a"
        ;;
      i) format=("${format[@]}" " {{.Image}}")
        is_default=false
        ;;
      s) format=("${format[@]}" " {{.Status}}")
        is_default=false
        ;;
      n) format=("${format[@]}" " {{.Names}}")
        is_default=false
        ;;
      l) format=("${format[@]}" " {{.Labels}}");;
      t) format=("table" "${format[@]}");;
      q) onlyID="-q";;
      h) echo "Usage: dps [OPTIONS]"
          echo "Options:"
          echo "  -a show all container"
          echo "  -i add image name at output"
          echo "  -s add container status at output"
          echo "  -n add container name at output"
          echo "  -l add container labels at output"
          echo "  -t add column name at output"
          return
          ;;
    esac
  done

  echo $onlyID
  echo ${format[@]}
  # IFS=""



  if [ -n $onlyID ]; then
    docker ps $isAll $onlyID
  elif [ ${#format[@]} -gt 1 ]; then
    docker ps $isAll --format "${format[*]}"
  else
    docker ps $isAll
  fi
  IFS=$OLDIFS
}

# fzf系 ---------------------

fdex() {
  local CMD
  local NAME
  read -p "docker exec で実行するコマンド (press enter key to skip -> used '/bin/bash'): " CMD
  # list=$(docker ps --format "table{{.Names}}\t{{.Image}}\t{{.Command}}\t{{.Ports}}\t{{.Mounts}}")
  NAME=$(docker ps --format "table{{.Names}}\t{{.Image}}\t{{.Command}}\t{{.Ports}}\t{{.Mounts}}" | fzf | awk '{print $1}')
  # list=("${list[@]}:1")
  docker exec -it $NAME ${CMD:-/bin/bash}
}

fdc() {
  local CMD
  local NAME
  read -p "実行する docker-compose コマンド (press enter key to skip -> used 'up -d'): " CMD
  # list=$(docker ps --format "table{{.Names}}\t{{.Image}}\t{{.Command}}\t{{.Ports}}\t{{.Mounts}}")
  NAME=$(find ~ -type f -name docker-compose.yml 2>/dev/null | fzf)
  # list=("${list[@]}:1")
  if [[ -z "$CMD" ]]; then
    CMD="up -d"
  fi
  docker-compose -f $NAME ${CMD}
}


fdst() {
  local NAME
  NAME=$(docker ps --format "table{{.Names}}\t{{.Image}}\t{{.Command}}\t{{.Ports}}\t{{.Mounts}}" | fzf -m | awk '{print $1}')
  docker stop $NAME
}

fdrm() {
  local NAME
  NAME=$(docker ps -a --format "table{{.Names}}\t{{.Image}}\t{{.Command}}\t{{.Ports}}\t{{.Mounts}}" | fzf -m | awk '{print $1}')
  docker rm -f $NAME
}

# fbr - checkout git branch
fgch() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

fgbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf -m) &&
  git branch -D $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# fbr - checkout git branch (including remote branches)
fgchr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

fgad() {
  local files
  files=$(git status -s | fzf -m | awk '{print $2}')
  $files && git add $files
}

# fd - cd to selected directory
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
