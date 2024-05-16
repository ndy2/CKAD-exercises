#!/bin/zsh

setopt SH_WORD_SPLIT

alias k="microk8s kubectl"
export do="--dry-run=client -oyaml"
export dos="--restart=Never -oyaml --dry-run=client"
