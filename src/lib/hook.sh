#!/bin/sh

#############
# Pathing
#############

function current_directory() {
    dirname $(readlink -f "$0")
}

#############
# Git Functions
#############