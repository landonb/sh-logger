#!/bin/bash
# vim:tw=0:ts=2:sw=2:et:norl:ft=sh
# Project: https://github.com/landonb/sh-logger#🎮🐸
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  local curdir="${HOMEFRIES_LIB:-${HOME}/.homefries/lib}"
  if [ -n "${BASH_SOURCE}" ]; then
    curdir=$(dirname -- "${BASH_SOURCE[0]}")
  fi

  # Load colors.
  . ${curdir}/color_funcs.sh
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

export_log_levels () {
  # The Python logging library defines the following levels,
  # along with some levels I've slid in.
  export LOG_LEVEL_FATAL=186 # [*probably what it really should be]
  export LOG_LEVEL_CRITICAL=50
  export LOG_LEVEL_FATAL=50 # [*aliases CRITICAL]
  export LOG_LEVEL_ERROR=40
  export LOG_LEVEL_WARNING=30 # [*also WARN]
  export LOG_LEVEL_NOTICE=25 # [*new]
  export LOG_LEVEL_INFO=20
  export LOG_LEVEL_DEBUG=15
  export LOG_LEVEL_TRACE=10 # [*new]
  export LOG_LEVEL_VERBOSE1=9 # [*new]
  export LOG_LEVEL_VERBOSE2=8 # [*new]
  export LOG_LEVEL_VERBOSE3=7 # [*new]
  export LOG_LEVEL_VERBOSE4=6 # [*new]
  export LOG_LEVEL_VERBOSE5=5 # [*new]
  export LOG_LEVEL_VERBOSE=5 # [*new]
  export LOG_LEVEL_NOTSET=0

  if [ -z ${LOG_LEVEL+x} ]; then
    export LOG_LEVEL=${LOG_LEVEL_ERROR}
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_sh_logger_echo () {
  [ "$(echo -e)" = '' ] && echo -e "${@}" || echo "${@}"
}

_sh_logger_log_msg () {
  local FCN_LEVEL="$1"
  local FCN_COLOR="$2"
  local FCN_LABEL="$3"
  shift 3
  if [ ${FCN_LEVEL} -ge ${LOG_LEVEL} ]; then
    #echo "${FCN_COLOR} $@"
    local RIGHT_NOW
    #RIGHT_NOW=$(date +%Y-%m-%d.%H.%M.%S)
    RIGHT_NOW=$(date "+%Y-%m-%d @ %T")
    local bold_maybe=''
    [ ${FCN_LEVEL} -ge ${LOG_LEVEL_WARNING} ] && bold_maybe=$(attr_bold)
    local invert_maybe=''
    [ ${FCN_LEVEL} -ge ${LOG_LEVEL_WARNING} ] && invert_maybe=$(bg_maroon)
    [ ${FCN_LEVEL} -ge ${LOG_LEVEL_ERROR} ] && invert_maybe=$(bg_hotpink)
    local echo_msg
    echo_msg="${FCN_COLOR}$(attr_underline)[${FCN_LABEL}]$(attr_reset) ${RIGHT_NOW} ${bold_maybe}${invert_maybe}$@$(attr_reset)"
    _sh_logger_echo "${echo_msg}"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

fatal () {
  _sh_logger_log_msg "${LOG_LEVEL_FATAL}" "$(bg_white)$(fg_lightred)$(attr_bold)" FATL "$@"
  # So that errexit can be used to stop execution.
  return 1
}

critical () {
  _sh_logger_log_msg "${LOG_LEVEL_CRITICAL}" "$(bg_pink)$(fg_black)$(attr_bold)" CRIT "$@"
}

error () {
  critical "$@"
}

warning () {
  _sh_logger_log_msg "${LOG_LEVEL_WARNING}" "$(fg_hotpink)$(attr_bold)" WARN "$@"
}

warn () {
  warning "$@"
}

notice () {
  _sh_logger_log_msg "${LOG_LEVEL_NOTICE}" "$(fg_lime)" NOTC "$@"
}

# MAYBE: This 'info' functions shadows /usr/bin/info
# - We could name it `infom`, or something.
# - The author almost never uses `info`.
# - Users can run just `command info ...`.
# - I don't care about this too much either way...
info () {
  _sh_logger_log_msg "${LOG_LEVEL_INFO}" "$(fg_mintgreen)" INFO "$@"
}

debug () {
  _sh_logger_log_msg "${LOG_LEVEL_DEBUG}" "$(fg_jade)" DBUG "$@"
}

trace () {
  _sh_logger_log_msg "${LOG_LEVEL_TRACE}" "$(fg_mediumgrey)" TRCE "$@"
}

verbose () {
  _sh_logger_log_msg "${LOG_LEVEL_VERBOSE}" "$(fg_mediumgrey)" VERB "$@"
}

test_logger () {
  fatal "FATAL: I'm gonna die!"
  critical "CRITICAL: Take me to a hospital!"
  error "ERROR: Oops! I did it again!!"
  warning "WARNING: You will die someday."
  warn "WARN: This is your last warning."
  notice "NOTICE: Hear ye, hear ye!!"
  info "INFO: Extra! Extra! Read all about it!!"
  debug "DEBUG: If anyone asks, you're my debugger."
  trace "TRACE: Not a trace."
  verbose "VERBOSE: I'M YELLING AT YOU"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

export_log_funcs () {
  # (lb): This function isn't necessary, but it's a nice list of
  # available functions.
  export -f fatal
  export -f critical
  export -f error
  export -f warning
  export -f warn
  export -f notice
  # NOTE: This 'info' shadows the builtin,
  #       now accessible at `command info`.
  export -f info
  export -f debug
  export -f trace
  export -f verbose
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  source_deps
  unset -f source_deps

  export_log_levels
  unset -f export_log_levels

  export_log_funcs
  unset -f export_log_funcs
}

main "$@"
unset -f main

