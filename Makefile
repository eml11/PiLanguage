CC=g++
MAIN=$PWD
BIN=$MAIN

all:main

main:main.cpp
	$(CC) -o $BIN/main main.cpp
	PATH=$PATH:$BIN
