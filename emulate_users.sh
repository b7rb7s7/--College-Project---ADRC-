#!/bin/bash

if [ "$#" -ne 7 ]; then
    echo "Usage: $0 <destination> <instances> <min_time> <max_time> <packet_size> <duration_seconds> <output_file>"
    exit 1
fi

destination="$1"
instances="$2"
min_time="$3"
max_time="$4"
packet_size="$5"
duration="$6"
output_file="$7"

start_time=$(date +%s)  # Get current timestamp
end_time=$((start_time + duration))  # Calculate stop time


ping_host() {
    while [ "$(date +%s)" -lt "$end_time" ]; do
        response=$(ping -c 1 -s "$packet_size" "$destination" 2>/dev/null | grep -oP 'time=\K[\d.]+' || echo "LOSS")
        echo "$response" >> "$output_file"

        sleep $((RANDOM % (max_time - min_time + 1) + min_time))
    done
}


for ((i=1; i<=instances; i++)); do
    ping_host &
done

wait

echo "Ping test completed. Results saved in $output_file."
