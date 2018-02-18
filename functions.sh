#!/bin/sh
dolphin() {
	local path="$1"
	if [[ "${path:-x}" == "x" ]]; then
		dolphin $(pwd) 2>&1 /dev/null
	fi
}

usage() {
	find $1 -maxdepth 1 -type d -exec du -sh {} \; | sort -h
}

gadd() {
	pattern="$1"
	git add $(git status -s | grep -v '^D' | awk '{print $2}' | grep "$pattern")
}
