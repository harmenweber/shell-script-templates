#
# LOGGING
#
# Provides functions and constants related to logging.
#
# To use this script, include it by adding the following to your script:
#   source <path-to-this-script>
#
# For every supported log level, there is a corresponding function:
#  - logDebug
#  - logInfo
#  - logWarn
#  - logError
#
# All logging is printed to stderr. The rationale behind this is the following:
# The stdout should be used for data output only. If you create a mixture of log
# output and data output on the stdout, you will have a hard time reusing your
# command in pipes.

# Define constants for colors and font style.
# Ensure the file can be sourced multiple times without errors.
if [ "${__LOGGING_CONSTANTS_LOADED:-}" != "true" ]; then
  # Color definitions
  readonly reset=$(tput sgr0)
  readonly blue=$(tput setaf 4)
  readonly grey=$(tput setaf 8)
  readonly red=$(tput setaf 9)
  readonly green=$(tput setaf 10)
  readonly yellow=$(tput setaf 11)
  readonly lila=$(tput setaf 12)
  readonly pink=$(tput setaf 13)
  readonly cyan=$(tput setaf 14)
  readonly white=$(tput setaf 15)
  readonly black=$(tput setaf 16)
  # Font style definitions
  readonly bold=$(tput bold)
  readonly start_underline=$(tput smul)
  readonly stop_underline=$(tput rmul)
fi
__LOGGING_CONSTANTS_LOADED="true"

function areColorsSupported() {
  # Check if terminal supports at least 256 colors
  [ "$(tput colors 2>/dev/null || echo 0)" -ge 256 ]
}

# By default the log output has colors to improve readability and highlight important
# information. However, if you intend to capture the log output into a log file,
# you should disable colors. You can do that by setting the variable 'colorsEnabled'
# to false.
function areColorsEnabled() {
  # By default colors are enabled.
  colorsEnabled=${colorsEnabled:-true}
  # Check if the variable colorsEnabled is explicitly set to false
  [ "${colorsEnabled}" != "false" ] && areColorsSupported
}

# Usage: getLogTimestamp
#
# Returns the current date and time in the local timezone
# and in the format: 2020-11-10 08:57:19 CET
function getLogTimestamp() {
  date -jR "+%Y-%m-%d %H:%M:%S %Z"
}

# By default debug logging is disabled. To enable it, set the variable 'debugEnabled'
# to true.
function isDebugEnabled() {
  # By default debug is disabled.
  debugEnabled=${debugEnabled:-false}
  # Check if the variable debugEnabled is explicitly set to true
  [ "${debugEnabled}" = "true" ]
}

# Usage: logDebug [message]
#
# If 'debugEnabled' is true, prints the passed message with log level DEBUG to stderr .
# Format: [<local-date-time>] DEBUG: <message>
# If 'colorsEnabled' is not false, the log message will be colored.
function logDebug() {
  # Exit early if debug logging is disabled
  if ! isDebugEnabled; then
    return
  fi

  if [ $# -gt 0 ]; then
    # There are arguments, log them.
    local -r message="$*"
    if areColorsEnabled; then
      printf "${grey}[%s] %-5s:${reset} %s\n" "$(getLogTimestamp)" "DEBUG" "${message}" >&2
    else
      printf "[%s] %-5s: %s\n" "$(getLogTimestamp)" "DEBUG" "${message}" >&2
    fi
  else
    # There are no arguments, read the stdin and log what you have read.
    while IFS="" read -r line || [ -n "$line" ]; do
      logDebug "${line}"
    done
  fi
}

# Usage: logInfo [message]
#
# Prints the passed message with log level INFO to stderr.
# Format: [<local-date-time>]  INFO : <message>
# If 'colorsEnabled' is not false, the log message will be colored.
function logInfo() {
  if [ $# -gt 0 ]; then
    # There are arguments, log them.
    local -r message="$*"
    if areColorsEnabled; then
      printf "${grey}[%s] %-5s:${reset} %s\n" "$(getLogTimestamp)" "INFO" "${message}" >&2
    else
      printf "[%s] %-5s: %s\n" "$(getLogTimestamp)" "INFO" "${message}" >&2
    fi
  else
    # There are no arguments, read the stdin and log what you have read.
    while IFS="" read -r line || [ -n "$line" ]; do
      logInfo "${line}"
    done
  fi
}

# Usage: logWarn [message]
#
# Prints the passed message with log level WARN to stderr.
# Format: [<local-date-time>]  WARN : <message>
# If 'colorsEnabled' is not false, the log message will be colored.
function logWarn() {
  if [ $# -gt 0 ]; then
    # There are arguments, log them.
    local -r message="$*"
    if areColorsEnabled; then
      printf "${grey}[%s]${reset} ${yellow}%-5s:${reset} %s\n" "$(getLogTimestamp)" "WARN" "${message}" >&2
    else
      printf "[%s] %-5s: %s\n" "$(getLogTimestamp)" "WARN" "${message}" >&2
    fi
  else
    # There are no arguments, read the stdin and log what you have read.
    while IFS="" read -r line || [ -n "$line" ]; do
      logWarn "${line}"
    done
  fi
}

# Usage: logError [message]
#
# Prints the passed message with log level ERROR to stderr.
# Format: [<local-date-time>] ERROR: <message>
# If 'colorsEnabled' is not false, the log message will be colored.
function logError() {
  if [ $# -gt 0 ]; then
    # There are arguments, log them.
    local -r message="$*"
    if areColorsEnabled; then
      printf "${grey}[%s]${reset} ${red}%-5s:${reset} %s\n" "$(getLogTimestamp)" "ERROR" "${message}" >&2
    else
      printf "[%s] %-5s: %s\n" "$(getLogTimestamp)" "ERROR" "${message}" >&2
    fi
  else
    # There are no arguments, read the stdin and log what you have read.
    while IFS="" read -r line || [ -n "$line" ]; do
      logError "${line}"
    done
  fi
}


