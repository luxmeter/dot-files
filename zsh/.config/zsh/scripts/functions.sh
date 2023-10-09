if [[ "$OSTYPE" != darwin* ]]; then
  open() {
    local targets=( "$@" ) # "@" expands each elements as an argument with prevented globbing
    for target in "${targets[@]}" ; do
      echo "${target}"
      xdg-open "$target" > /dev/null 2>&1 &
    done
  }
fi

disk_usage() {
  du -sh "$1"/* | sort -h
}

gadd() {
  local pattern="$1"
  git add "$(git status -s | grep -v '^D' | awk '{print $2}' | grep "$pattern")"
}

vimrc() {
  # for bash
  # readarray -d '' names < <(find $DOT_FILES/vim/config -print0 -type f -name "*vimrc" | fzf)
  # for zsh http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
  local names=( ${(f)"$(find "$DOT_FILES/nvim/.config/nvim/lua/caylak" -type f -name '*.lua' | fzf)"} )
  if [[ ${#names[@]} -gt 0 ]]; then
    vim "${names[@]}"
  fi
}

zshrc() {
  local files="$(find "$DOT_FILES/zsh/.config/zsh/scripts" -type f)"
  files="$files\n$DOT_FILES/zsh/.zshenv"
  files="$files\n$DOT_FILES/zsh/.config/zsh/.zshrc"
  names=( ${(f)"$(echo "$files" | fzf)"} )
  if [[ ${#names[@]} -gt 0 ]]; then
    vim "${names[@]}"
    echo "${names[@]}" | xargs -n1 echo
    source "${names[@]}"
  fi
}

doc_get_id() {
  local name="$1"
  if [[ "${name:-x}" != "x" ]]; then
    docker ps | grep "$name" | awk '{print $1}'
  else
    docker ps | awk '{print $1}'
  fi
}

doc_purge_containers() {
  docker stop $(docker ps -a -q) >/dev/null 2>&1
  docker rm $(docker ps -a -q) >/dev/null 2>&1
}

## returns spring version to the given spring boot version
get_spring_version() {
  local spring_boot_version="$1"
  http https://repo1.maven.org/maven2/org/springframework/boot/spring-boot-dependencies/${spring_boot_version}.RELEASE/spring-boot-dependencies-${spring_boot_version}.RELEASE.pom \
    | sed 's/xmlns=".*"//g' \
    | xmllint --xpath '/project/properties/spring-framework.version/text()' -
}

enable_charles_proxy() {
  export http_proxy=http://localhost:8888/
  export https_proxy=http://localhost:8888/
}

get_pom_version() {
  if [[ -f pom.xml ]]; then
    mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\['
  else
    (echo &>2 "No pom.xml found")
  fi
}

passwd_ldap() {
  local item=$(op get item "LDAP Login" 2>&1)
  if [[ ${item} =~ "not currently signed in" ]]; then
    passwd_login
    item=$(op get item "LDAP Login" 2>&1)
  fi
  local password=$(echo "${item}" | jq -r '.details.fields[] | select(.designation=="password").value')
  echo "${password}" | pbcopy
}

aws_cred_to_env() {
  jq -r 'to_entries | map("export \(.key)=\(.value)") | .[]'
}

aws_cred_to_file() {
  echo "[default]" >!~/.aws/credentials
  jq -r ' with_entries( .key |= ascii_downcase ) | to_entries | map("\(.key)=\(.value)") | .[]' >>~/.aws/credentials
}

_git_checkout() {
  __git_has_doubledash && return

  case "$cur" in
    --conflict=*)
      __gitcomp "diff3 merge" "" "${cur##--conflict=}"
      ;;
    --*)
      __gitcomp_builtin checkout "--no-track --no-recurse-submodules"
      ;;
    *)
      # check if --track, --no-track, or --no-guess was specified
      # if so, disable DWIM mode
      local flags="--track --no-track --no-guess" track_opt="--track"
      if [ "$GIT_COMPLETION_CHECKOUT_NO_GUESS" = "1" ] \
        || [ -n "$(__git_find_on_cmdline "$flags")" ]; then
        track_opt=''
      fi
      if [ "$command" = "checkoutr" ]; then
        __git_complete_refs "$track_opt"
      else
        __gitcomp_nl "$(__git_heads '' "$track")"
      fi
      ;;
  esac
}

gbf() {
  git branch --format='%(refname:short)' | fzf | xargs -I{} git checkout {}
}

gbdf() {
  git branch --format='%(refname:short)' | grep -v master | fzf | xargs -I{} git branch -D {}
}

rcp() {
  local args=("$@")
  rsync -rptovl --progress --stats --human-readable --exclude .git --exclude node_modules "${args[@]}"
}

to_datetime() {
  local timestamp=$1
  cmd=(
    "from datetime import datetime as dt"
    "import pytz"
    "ts=${timestamp}"
    "ts=ts / 1000 if len(str(ts)) > 10 else ts"
    "t=dt.fromtimestamp(ts, pytz.timezone('Europe/Berlin')).replace(microsecond=0).isoformat(' ')"
    "print(t)"
  )
  python3 -c "$(printf '%s\n' "${cmd[@]}")"
}

doc_remove_all_images() {
  docker rm "$(docker ps -a -q)"
  docker rmi --force "$(docker images -q)"
}

# source: https://github.com/ChristianChiarulli/Machfiles/blob/master/zsh/.config/zsh/zsh-functions
# Function to source files if they exist
function zsh_add_file() {
    [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

function zsh_add_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then
        # For plugins
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
        git clone --depth 1 "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
    fi
}

function zsh_add_completion() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then
        # For completions
		completion_file_path=$(ls $ZDOTDIR/plugins/$PLUGIN_NAME/_*)
		fpath+="$(dirname "${completion_file_path}")"
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
    else
        git clone --depth 1 "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
		fpath+=$(ls $ZDOTDIR/plugins/$PLUGIN_NAME/_*)
        [ -f $ZDOTDIR/.zccompdump ] && $ZDOTDIR/.zccompdump
    fi
	completion_file="$(basename "${completion_file_path}")"
	if [ "$2" = true ] && compinit "${completion_file:1}"
}


function kontext() {
  IFS=':' read -A CONFIGS <<< ${KUBECONFIG:-~/.kube/config}
  local contexts
  for config in ${CONFIGS[@]}; do
    contexts+="$(yq '.contexts[]|.name' < $config)"$'\n'
  done
  for context in $(fzf <<< $contexts); do
    export KUBECTL_CONTEXT=$context
  done
}
