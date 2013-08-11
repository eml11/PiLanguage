CC=g++
MAIN=$PWD
BIN=$MAIN

all:PiMain

PiMain:main.cpp
	$(CC) -o $BIN/PiMain main.cpp
	PATH=$PATH:$BIN
