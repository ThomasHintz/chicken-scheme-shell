# Makefile for Chicken-scheme shell

cscsh: shell.scm
	csc shell.scm -compile-syntax -o hiss

.PHONY: clean
clean:
	rm -f hiss
