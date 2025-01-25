#!/usr/bin/env bash

# Exit on error and ensure safe script execution
set -o errexit    # Exit on error
set -o errtrace   # Exit on errors in functions/subshells
set -o pipefail   # Catch errors in piped commands
set -o nounset    # Treat unset variables as errors
# Uncomment for debugging
# set -o xtrace

# Script metadata
readonly SCRIPT_FILE="$(basename "${0}")" # Full script filename
readonly SCRIPT_NAME="$(basename "${0}" .sh)" # Script name without extension
readonly SCRIPT_HOME="$(cd "$(dirname "$(readlink -f "${0}")")" && pwd)" # Absolute path to the script directory

# Settings
debugEnabled=${debugEnabled:-false}
colorsEnabled=${colorsEnabled:-true}
option=${option:-default}

# Include dependencies
readonly LIB_DIR="${LIB_DIR:-${SCRIPT_HOME}/lib}"
# Usage: loadDependency FILE
function loadDependency() { source "$1" || { echo "Failed to source $1" >&2; exit 1; } }
loadDependency "${LIB_DIR}/datetime.sh"
loadDependency "${LIB_DIR}/logging.sh"
loadDependency "${LIB_DIR}/progressBar.sh"

# Usage
function usage() {
  cat >&2 <<EOF
Usage: ${SCRIPT_NAME} [OPTION...] ARG

A shell script template that doesn't do anything.

Options:
   -o, --option OPTION     Some option.
   -h, --help              Display this help and exit.
       --debug             Enables debug logging.
       --no-colors         Disables colored logging. Useful when logging to a file.

Arguments:
   ARG                     The mandatory argument.
EOF
}

# Parse options
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --debug)
      debugEnabled=true
      shift
      ;;
    --no-colors)
      colorsEnabled=false
      shift
      ;;
    -o|--option)
      option="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    -*)
      printf "Error: Unknown option $1%n%n" >&2
      usage
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

# Validate arguments
if [[ $# -eq 0 ]]; then
  echo "Error: ARG is required." >&2
  usage
  exit 1
fi

# Trap for cleanup
function cleanup() {
    logDebug "Cleaning up..."
    # Any cleanup tasks (e.g., removing temp files)
}
trap cleanup EXIT

# Main logic
readonly ARG="$1"
logInfo "Executed template with option '${option}' and ARG '${ARG}'"