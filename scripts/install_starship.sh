#!/bin/bash

if command -v starship &> /dev/null; then
    exit
fi

curl -sS https://starship.rs/install.sh | sh
