#!/bin/bash

specialutils() {
cat <<SPECIAL
hello
SPECIAL
}

coreutils() {
  dpkg -L coreutils | sed -nr '/^.*\/s?bin\/([a-z0-9]+)$/ { s//\1/; p }'
}

fmt_listing() {
  sort | uniq | fmt -w 64
}

make_rules() {
sed -r '
1 {
i\
# Generated Makefile. See makefile.sh with the distribution.
i\

i\
targets =
}

s/^[^#].+$/targets += &/

$ {
a\

a\
clean:\n\trm -f $(targets) *.hi *.o
a\
$(targets): %: %.hs\n\tghc --make -O2 -o $@ $<
}
'
}

( echo '# Commands internal to this tutorial.'
  specialutils | fmt_listing
  echo '# Generated listing for GNU coreutils.'
  coreutils | fmt_listing) | make_rules





