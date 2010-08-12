# Generated Makefile. See makefile.sh with the distribution.

targets =
# Commands internal to this tutorial.
targets += hello
# Generated listing for GNU coreutils.
targets += arch base64 basename cat chcon chgrp chmod chown chroot cksum
targets += comm cp csplit cut date dd df dir dircolors dirname du echo
targets += env expand expr factor false fmt fold groups head hostid id
targets += install join link ln logname ls md5sum mkdir mkfifo mknod
targets += mktemp mv nice nl nohup od paste pathchk pinky pr printenv
targets += printf ptx pwd readlink rm rmdir runcon seq sha1sum sha224sum
targets += sha256sum sha384sum sha512sum shred shuf sleep sort split stat
targets += stty sum sync tac tail tee test touch tr true truncate tsort
targets += tty uname unexpand uniq unlink users vdir wc who whoami yes

list:
	$(info Available targets:)
	$(info $(basename $(foreach t,$(targets),$(wildcard $(t).hs))))
clean:
	rm -f $(targets) *.hi *.o
$(targets): %: %.hs
	ghc --make -O2 -o $@ $<
