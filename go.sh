#!/bin/bash

# $1 how many spacebar on the left side of intro
# $2 how many time sleep after every row of intro
function print_banner_one() {
	local ver=$SCRIPT_VERSION
	local spc
	local tm="$2"
	for (( i=1; i <= $1; i++ )) ; do
       spc+=" "
	done

	sleep "$tm" && echo "$spc    ____________                         ___"
	sleep "$tm" && echo "$spc   (_______  \\  \\                       /  /"
	sleep "$tm" && echo "$spc           \\  \\  \\                     /  / "
	sleep "$tm" && echo "$spc            \\  \\  \\                   /  /  "
	sleep "$tm" && echo "$spc             \\  \\  \\       ___       /  /   "
	sleep "$tm" && echo "$spc   JW script  \\  \\  \\     /   \\     /  /    "
	sleep "$tm" && echo "$spc        $ver   \\  \\  \\___/  _  \\___/  /     "
	sleep "$tm" && echo "$spc         _______\\  \\       / \\       /      "
	sleep "$tm" && echo "$spc        (___________\\_____/   \\_____/       "
	sleep "$tm" && echo

}
function print_banner() {
	echo -e "\\033[s"
	if [[ $ANIMATED_INTRO == 1 ]]; then
		echo -e "\\033[u"
		print_banner_one 0 0.15
		for (( i=1; i <= 20; i++ )) ; do
			echo -e "\\033[u"
			print_banner_one $i 0
			sleep 0.1
		done 
	else
		print_banner_one 0 0.15
	fi
	sleep 0.7
}

function show_main_menu(){
	echo -e "\\033[u"
	echo "**************** MENU ****************"
	echo "1) Add aliases to .bashrc."
	echo "2) Update aliases"
	echo "3) Add aliasec to .zshrc."
	echo "4) Print aliases."
	echo "5) Print credits."
	echo
	echo "EXIT --> type exit or q"
	echo "**************************************"
}


function get_bash_version() {
	BASH_VERSION=$(bash --version | grep bash | grep -Eo "version\\ (.*)\\ " | cut -d " " -f2)
}

function get_directory() {
	SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
}

function get_term_value() {
	#actualy only screen is supported 'cause I always use it and I love it
	TERM_VALUE=$(env | grep TERM | cut -d "=" -f2)
	if [[ ! -z $(echo $TERM_VALUE | grep screen) ]] ; then
		ANIMATED_INTRO=1
	fi
}

function get_info() {
	get_directory
	get_bash_version
	get_term_value
}

function wait_f() {
	echo "Press --enter-- to continue"
	read -r
}

usage() {
	echo "Usage: $0 [-v for verbose] " 1>&2
	exit 1
}

# $1 .zshrc = 0 / .bashrc = 1
function add_aliases() {
	local grepped_string
	local pattern="source /home/jakub/.jw_script/jw_aliases"
	local file
	
	file=".bashrc"
	grepped_string=$(grep "$pattern" $HOME/$file)

	if [[ -n $grepped_string ]]; then
		echo "Aliases already added."
		return
	fi

	if [[ ! -d $SRC_DIR ]]; then
		mkdir $SRC_DIR
		cp $SCRIPT_DIR/jw_aliases $SRC_DIR
	fi
	echo "source $SRC_DIR/jw_aliases" >> $HOME/$file
	echo "Aliases added properly."
}

function update_aliases() {
	if [ ! -f $SRC_DIR/jw_aliases ]; then
		echo "Could not find aliases file, try add them first"
		return
	fi
	cp $SCRIPT_DIR/jw_aliases $SRC_DIR
	echo "Aliases updated properly"
}

function print_aliases() {
	if [ ! -f $SCRIPT_DIR/jw_aliases ]; then
		echo "Could not find aliases file inside repo"
		return
	fi
	echo
	cat $SCRIPT_DIR/jw_aliases
	echo
}
function print_credits() {
	echo;echo
	echo "source by JW."
	echo;echo
}

function main_loop() {
	local opt
	while true; do
		clear
		show_main_menu
		read -r opt

		case "$opt" in
		"1")
			add_aliases	;;
		"2")
			update_aliases	;;
		"3")
			print_aliases	;;
		"4")
			print_credits	;;
		"exit" | "q")
			break	;;
		*)
			continue	;;
		esac
		wait_f
	done
}

# script starts here

#declaration of used variable to have them all in one places
declare SCRIPT_DIR
declare BASH_VERSION
declare TERM_VALUE
declare ANIMATED_INTRO=0
declare VERBOSE=0
declare DEBUG=0
declare SCRIPT_VERSION=v0.1
declare SRC_DIR="$HOME/repos/jw_script/"
declare SKIP_INTRO=0

while getopts ":v:ds" o; do
    case "${o}" in
        v)
            VERBOSE=1
            ;;
		d)
			DEBUG=1
			;;
		s)
			SKIP_INTRO=1
			;;
        *)
            usage
            ;;
    esac
done

#setup stuff
clear
get_info
if [[ $SKIP_INTRO -ne 1 ]]; then
	print_banner
fi

#go into main loop
main_loop
