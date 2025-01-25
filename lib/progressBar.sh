# Settings
progressBarCharacter="${progressBarCharacter:-#}"
progressBarEmptyCharacter="${progressBarEmptyCharacter:-.}"
progressBarMaxLength="${progressBarMaxLength:-30}"

# Moves the cursor up one row.
function cursorUp() {
  tput cuu1
}

# Usage: progressBar CURRENT_ITEM MAX_ITEMS
#
# Prints a progress bar. The function requires the current item's index
# and the total number of items to process.
#
# Arguments:
#   CURRENT_ITEM     The index of the current item (e.g., 5).
#   MAX_ITEMS        The total number of items to process (e.g., 10).
#
# Below are some examples that demonstrate how this could be used inside
# a shell script.
#
# Example 1: Simple
# numberOfItemsToProcess=10
# for i in $(seq 1 $numberOfItemsToProcess); do
#   sleep 1 # <- Do your processing here.
#   logInfo "$(progressBar "$i" $numberOfItemsToProcess) Processing item $i/$numberOfItemsToProcess"
# done
#
# Example 2: Progress bar printed on same line
# numberOfItemsToProcess=10
# for i in $(seq 1 $numberOfItemsToProcess); do
#   sleep 1 # <- Do your processing here.
#   if [ $i != 1 ]; then cursorUp; fi
#   logInfo "$(progressBar "$i" $numberOfItemsToProcess) Processing item $i/$numberOfItemsToProcess"
# done
#
# Example 3: Print success symbol when complete
# numberOfItemsToProcess=10
# for number in $(seq 1 $numberOfItemsToProcess); do
#   sleep 1 # <- Do your processing here.
#   if [[ $number -lt $numberOfItemsToProcess ]]; then
#     message="Processing items (${number}/${numberOfItemsToProcess}) ... "
#   else
#     message="Processing items (${number}/${numberOfItemsToProcess}) ... done ${green}✔${reset}"
#   fi
#   if [ $i != 1 ]; then cursorUp; fi
#   logInfo "$(progressBar "${number}" "${numberOfItemsToProcess}")" "${message}"
# done
function progressBar() {
  local currentItem="$1"
  local -r maxItems="$2"

  # Validate inputs
  if [[ -z "$currentItem" || -z "$maxItems" || "$maxItems" -le 0 ]]; then
    echo "Error: Invalid arguments for progressBar (CURRENT_ITEM: $currentItem, MAX_ITEMS: $maxItems)" >&2
    return 1
  fi
  currentItem=$((currentItem < 0 ? 0 : currentItem)) # Cap currentItem at maxItems
  currentItem=$((currentItem > maxItems ? maxItems : currentItem)) # Cap currentItem at maxItems

  # Calculate progress
  local progressInPercent=$(( (100 * currentItem) / maxItems ))
  local progressBarLength=$(( (progressBarMaxLength * currentItem) / maxItems ))
  local remainingBarLength=$(( progressBarMaxLength - progressBarLength ))

  # Build the progress bar
  local progressBar
  if [ $progressBarLength -gt 0 ]; then
    progressBar="$(printf "%0.s${progressBarCharacter}" $(seq 1 "$progressBarLength"))"
  fi
  if [ $remainingBarLength -gt 0 ]; then
    progressBar+=$(printf "%0.s${progressBarEmptyCharacter}" $(seq 1 "$remainingBarLength"))
  fi

  # Print the progress bar
  printf "[%-${progressBarMaxLength}s] (%3d%%)" "$progressBar" "$progressInPercent"
}