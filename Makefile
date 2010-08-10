clean:
	rm -rf *.o *.hi
arch base64 basename cat chcon chgrp chmod chown chroot cksum: %: %.hs
	ghc --make -O2 -o $@ $<
comm cp csplit cut date dd df dir dircolors dirname du echo: %: %.hs
	ghc --make -O2 -o $@ $<
env expand expr factor false fmt fold groups head hello hostid: %: %.hs
	ghc --make -O2 -o $@ $<
id install join link ln logname ls md5sum mkdir mkfifo mknod: %: %.hs
	ghc --make -O2 -o $@ $<
mktemp mv nice nl nohup od paste pathchk pinky pr printenv: %: %.hs
	ghc --make -O2 -o $@ $<
printf ptx pwd readlink rm rmdir runcon seq sha1sum sha224sum: %: %.hs
	ghc --make -O2 -o $@ $<
sha256sum sha384sum sha512sum shred shuf sleep sort split stat: %: %.hs
	ghc --make -O2 -o $@ $<
stty sum sync tac tail tee test touch tr true truncate tsort: %: %.hs
	ghc --make -O2 -o $@ $<
tty uname unexpand uniq unlink users vdir wc who whoami yes: %: %.hs
	ghc --make -O2 -o $@ $<
