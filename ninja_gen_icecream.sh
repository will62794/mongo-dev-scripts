#!/bin/sh
rm -rf mongo/src/db/modules/ninja
git clone -b icecream git@github.com:RedBeard0531/mongo_module_ninja.git mongo/src/db/modules/ninja
cd mongo
python buildscripts/scons.py --icecream CC=gcc CXX=g++ \
	CCFLAGS='-Wa,--compress-debug-sections -gsplit-dwarf' \
	MONGO_VERSION='0.0.0' MONGO_GIT_HASH='unknown' \
	VARIANT_DIR=ninja --modules=ninja \
	build.ninja
