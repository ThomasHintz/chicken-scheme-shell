# Makefile for Chicken-scheme shell

cscsh: shell.scm
	csc shell.scm -o cscsh

.PHONY: clean
clean:
	rm -f cscsh
