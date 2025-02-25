#/usr/bin/env sh

sinks=($(pactl list short sinks | awk '{print $2}'))
current_sink=$(pactl get-default-sink)
current_index=-1

for i in "${!sinks[@]}"; do
	if [[ "${sinks[$i]}" == "$current_sink" ]]; then
		current_index=$i
		break
	fi
done

if [[ $current_index -eq -1 ]]; then
	next_index=0
else
	next_index=$(( (current_index + 1) % ${#sinks[@]} ))
fi

pactl set-default-sink "${sinks[$next_index]}"
notify-send "Switched to sink: ${sinks[$next_index]}"
