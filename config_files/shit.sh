#!/bin/bash

# mapfile -t dir_list < dirs
dir_list=()
i=0
echo "- Dir Marks -->"

cd "$HOME"
while IFS= read -r line; do
    i=$((i + 1))
    echo "${i}. [ ${line} ]"
    dir_list+=("$line")
done < dirs

while true; do
    echo ""
    echo -n "Enter index (1 - ${i}): "
    read dir_num
    if (( dir_num > i )); then
        echo "Error: Index out of bounds"
        continue
    elif (( dir_num < 1 )); then
        echo "Error: Index too low"
        continue
    fi

    echo "Chosen ${dir_list[$dir_num]}."
    break
done

dir_string="${dir_list[$dir_num]}"
cd "${dir_string}"
