
makefiles:
	find . -name '??_*' -type d -exec sh -c './bin/makefile.sh > {}/Makefile' ';'

clean:
	find . -name '??_*' -type d -exec sh -c 'cd {} && make clean' ';'

