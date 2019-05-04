#! /bin/bash

FILE=/tmp/jobs.pid
function stop {
	if [[ -f "${FILE}" ]]; then
		while read -r pid; do
			kill -9 "${pid}"
		done < /tmp/jobs.pid
		rm /tmp/jobs.pid
	fi
}

function start {
	stop
	~/.virtualenvs/nvimpy3/bin/python -m pyls --tcp --port 2078 &
	echo $! >> "${FILE}"
	npx javascript-typescript-langserver --port 2089 &
	echo $! >> "${FILE}"
}

function main {
	local cmd="$1"
	if ! grep -q "function $cmd {" $(realpath -s "$0"); then
		echo "Command $cmd not found"
		exit 1
	fi
	$cmd
}

main "$@"
