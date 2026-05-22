#!/bin/bash

if [[ $1 == "go" ]]; then
    read -r last_dir < $HOME/.last-dir
    cd "${last_dir}"
elif [[ $1 == "update" ]]; then
    current=$(pwd)
    echo ${current} > $HOME/.last-dir
else
    echo "Error: please enter a parameter."
fi

