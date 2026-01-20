#!/bin/bash

# Catppuccin colors
GREEN="#a6e3a1"
YELLOW="#f9e2af"
PEACH="#fab387"
RED="#f38ba8"

# Get battery info
battery_info=$(pmset -g batt)
percentage=$(echo "$battery_info" | /usr/bin/grep -Eo '[0-9]+%' | head -1 | tr -d '%')

# Exit if no battery found
[[ -z "$percentage" ]] && exit 0

# Determine color based on percentage
if [[ $percentage -ge 50 ]]; then
    color="$GREEN"
elif [[ $percentage -ge 30 ]]; then
    color="$YELLOW"
elif [[ $percentage -ge 15 ]]; then
    color="$PEACH"
else
    color="$RED"
fi

# Check if charging
if echo "$battery_info" | /usr/bin/grep -q "AC Power"; then
    if echo "$battery_info" | /usr/bin/grep -q "charged"; then
        icon="󰁹"
        color="$GREEN"
    else
        icon="󰂄"
        color="$GREEN"
    fi
elif echo "$battery_info" | /usr/bin/grep -q "charged"; then
    icon="󰁹"
    color="$GREEN"
else
    # Discharging - choose icon based on level
    if [[ $percentage -ge 90 ]]; then
        icon="󰁹"
    elif [[ $percentage -ge 80 ]]; then
        icon="󰂂"
    elif [[ $percentage -ge 70 ]]; then
        icon="󰂁"
    elif [[ $percentage -ge 60 ]]; then
        icon="󰂀"
    elif [[ $percentage -ge 50 ]]; then
        icon="󰁿"
    elif [[ $percentage -ge 40 ]]; then
        icon="󰁾"
    elif [[ $percentage -ge 30 ]]; then
        icon="󰁽"
    elif [[ $percentage -ge 20 ]]; then
        icon="󰁼"
    elif [[ $percentage -ge 10 ]]; then
        icon="󰁻"
    else
        icon="󰁺"
    fi
fi

echo "#[fg=$color]$icon $percentage%"
