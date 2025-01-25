# Usage: localDateTime
#
# Returns the current date and time in the local timezone
# and in the format: 2025-01-24 23:26:51 CET
function localDateTime() {
  date -jR "+%Y-%m-%d %H:%M:%S %Z"
}

# Usage: localIsoDateTime
#
# Returns the current date and time in the local timezone
# and in the ISO 8601 format: 2025-01-24T23:29:51+01:00
function localIsoDateTime() {
  date -jIseconds
}

# Usage: utcDateTime
#
# Returns the current date and time in the UTC timezone
# and in the format: 2025-01-24 22:27:19 UTC
function utcDateTime() {
  date -juR "+%Y-%m-%d %H:%M:%S %Z"
}

# Usage: utcIsoDateTime
#
# Returns the current date and time in the UTC timezone
# and in the ISO 8601 format: 2025-01-24T22:32:15+00:00
function utcIsoDateTime() {
  date -juIseconds
}

# Usage: zuluDateTime
#
# Returns the current date and time in the Zulu timezone
# and in the ISO 8601 format: 2025-01-24T22:27:34Z
function zuluDateTime() {
  date -juR "+%Y-%m-%dT%H:%M:%SZ"
}