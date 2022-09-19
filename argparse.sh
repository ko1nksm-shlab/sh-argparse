# shellcheck shell=sh
# sh-argparse is released under CC0
# https://creativecommons.org/publicdomain/zero/1.0/
# formatter: shfmt -ci -i 2

argparse() {
  argparse_index=1
  argparse="while [ \$# -gt 0 ]; do case \"\$1\" in --) shift && break ;;"
  while [ $# -gt 0 ]; do
    case "$1,$2" in
      -*=,[-:]*) argparse="$argparse $1*) ${1#"${1%%[!-]*}"}\${1#*=} ;;" ;;
      -*=,*) argparse="$argparse $1*) $2=\${1#*=} ;;" && shift ;;
      -*,[-:]*) argparse="$argparse $1) ${1#"${1%%[!-]*}"}=true ;;" ;;
      -*,*) argparse="$argparse $1) $2=true ;;" && shift ;;
      :*,*) break ;;
      *,*) echo "argparse: invalid parameter: $1" >&2 && exit 1 ;;
    esac
    argparse_index=$((argparse_index + 1)) && shift
  done
  argparse="$argparse -*) echo \"argparse: unknown option: \${1%%=*}\" >&2"
  argparse="$argparse && exit 1 ;; *) break ;; esac; shift; done;"
  while [ $# -gt 0 ]; do
    case "$1" in
      :) shift && break ;;
      :*) argparse="$argparse ${1#:}=\$1 && shift;" ;;
      *) echo "argparse: invalid parameter: $1" >&2 && exit 1 ;;
    esac
    argparse_index=$((argparse_index + 1)) && shift
  done
  eval "$argparse"
  set -- $((argparse_index - 1))
  unset argparse argparse_index
  return "$1"
}
