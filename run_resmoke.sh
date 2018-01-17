#!/bin/sh

set -o nounset # Don't reference undefined variables.
set -o errexit # Don't ignore failing commands.

# Useful default options for running resmoke.py to run MongoDB JS tests.

logconfig="/home/william/mongodb/repl/mongo-macbook-copy/scripts/clean.yml"
filterout="I NETWORK|I ASIO|D REPL_HB|I REPL_HB|I BRIDGE"
baseport="47123"
python buildscripts/resmoke.py --basePort $baseport --log $logconfig $1 | grep -vE "$filterout" \
	| colout "REPL" blue \
	| colout "ROLLBACK" yellow \
	| colout "REPL_HB" red \
