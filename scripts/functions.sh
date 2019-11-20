dolphin() {
  local path="$1"
  if [[ "${path:-x}" == "x" ]]; then
    (/usr/bin/dolphin $(pwd) 2>/dev/null >&1 &)
  fi
}

usage() {
  find $1 -maxdepth 1 -type d -exec du -sh {} \; | sort -h
}

gadd() {
  pattern="$1"
  git add $(git status -s | grep -v '^D' | awk '{print $2}' | grep "$pattern")
}

fdp() {
  fd $@ | fzf -m --preview 'cat {}'
}

agp() {
  ag -l $@ | fzf -m --preview 'cat {}'
}

vimrc() {
  local names="$@"
  names="$(find $DOT_FILES/vim/config -type f -name "*vimrc" | fzf)"
  echo ${names} | xargs -o vim
}

zshrc() {
  names="$(find $DOT_FILES/scripts -type f)"
  names="$names\n$DOT_FILES/zshenv"
  names="$names\n$DOT_FILES/zshrc"
  echo $(echo $names | fzf) | xargs -o vim
  source ~/.zshrc
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
  echo $(http http://central.maven.org/maven2/org/springframework/boot/spring-boot-dependencies/${spring_boot_version}.RELEASE/spring-boot-dependencies-${spring_boot_version}.RELEASE.pom \
    | sed 's/xmlns=".*"//g' \
    | xmllint --xpath '/project/properties/spring.version/text()' -)
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
  local password=$(echo ${item} | jq -r '.details.fields[] | select(.designation=="password").value')
  echo ${password} | pbcopy
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
        __git_complete_refs $track_opt
      else
        __gitcomp_nl "$(__git_heads '' $track)"
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
  ARGS=("$@")
  SRC=("${ARGS[@]:0:-1}")
  END=("${ARGS[@]: -1:1}")
  rsync -rptovl --progress --stats --human-readable --exclude .git --exclude node_modules "${ARGS[@]}"
}

to_datetime() {
  local timestamp=$1
  cmd=(
    "from datetime import datetime as dt;"
    "import pytz;"
    "t=dt.fromtimestamp(${timestamp}/1000, pytz.timezone('Europe/Berlin')).replace(microsecond=0).isoformat(' ');"
    "print(t);"
  )
  python3 -c "${cmd}"
}

doc_remove_all_images() {
  docker rm $(docker ps -a -q)
  docker rmi --force $(docker images -q)
}
