#!/bin/sh

#############
# Pathing
#############

current_directory() {
    dirname "$(readlink -f "$0")"
}

#############
# Git Functions
#############