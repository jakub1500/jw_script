#!/bin/bash

if [[ -z $1 ]]; then
	echo "Expected parameter b!tch.."
	exit 1
fi

mac=$(ifconfig $1 | grep hwaddr | grep -Eo "([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}")

echo "$1	$mac"
