#!/usr/bin/env make
#
# pfmt - paragraph formatting
#
# Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby granted,
# provided that the above copyright, this permission notice and text
# this comment, and the disclaimer below appear in all of the following:
#
#       supporting documentation
#       source copies
#       source works derived from this source
#       binaries derived from this source or from derived source
#
# LANDON CURT NOLL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
# EVENT SHALL LANDON CURT NOLL BE LIABLE FOR ANY SPECIAL, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
# USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
# chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
#
# Share and enjoy! :-)


SHELL= bash

CC= cc
RM= rm
CP= cp
CHMOD= chmod
INSTALL= install
TRUE= true
SH_FILES= pfmt.sh

DESTDIR= /usr/local/bin


TARGETS= pfmt

all: ${TARGETS}
	@:

# rules, not file targets
#
.PHONY: all configure clean clobber install

pfmt: pfmt.sh
	@${CP} -fv $< $@
	${CHMOD} +x $@

configure:
	@echo nothing to configure

clean:
	${RM} -f ${TARGETS}

clobber: clean
	@${TRUE}

install: all
	${INSTALL} -m 0555 ${TARGETS} ${DESTDIR}
