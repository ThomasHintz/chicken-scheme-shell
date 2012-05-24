# Makefile for Chicken-scheme shell

cscsh: shell.scm
	csc shell.scm -o hiss

.PHONY: clean
clean:
	rm -f hiss
