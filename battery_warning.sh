#!/usr/bin/env bash

# Function to check if there's an existing Zenity dialog with "Low Battery Warning" or "High Battery Warning" title
isZenityDialogOpen() {
  wmctrl -l | grep 'Baterie se vybíjí!\|Baterie je nabitá!' > /dev/null
}

# Run forever
while true; do
  # Check if any Zenity dialog is currently open
  while isZenityDialogOpen; do
    # If so, wait until it closes before proceeding
    sleep 5
  done

  # Get battery level
  battery=$(cat /sys/class/power_supply/BAT0/capacity)

  # Get charging adapter status
  adapter=$(cat /sys/class/power_supply/ADP0/online)

  # Low battery warning
  if [[ "$battery" -lt 29 && "$adapter" == "0" ]]; then
    zenity --warning \
      --title="Baterie se vybíjí!" \
      --text="Stav Tvé baterie je ${battery}%! Připoj ji prosím do sítě." \
      --ok-label="Jasně."
  elif [[ "$battery" -gt 74 && "$adapter" == "1" ]]; then
    zenity --warning \
      --title="Baterie je nabitá!" \
      --text="Stav Tvé baterie je ${battery}%! Odpoj ji prosím ze sítě." \
      --ok-label="OK."
  fi

  # Wait for 10 minutes (in seconds)
  sleep 600
done

