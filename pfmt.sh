#!/usr/bin/env bash
#
# pfmt - paragraph formatting with continuation lines
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

# setup
#
export VERSION="1.0.1 2023-03-23"
NAME=$(basename "$0"); export NAME
#
export V_FLAG=0
export FMT="fmt"
export C_FLAG=
export M_FLAG=
export N_FLAG=
export P_FLAG=
export D_FLAG=
export L_FLAG=
export T_FLAG=
export W_FLAG=
export FIRST=
export END=" \\"
export ISTR="	"

# usage
#
export USAGE="usage: $0 [-h] [-v level] [-V]
	[-f path]  [-1 first] [-e endstr] [-i istr]
	[-c] [-m] [-n] [-p] [-d chars] [-l num] [-t num] [-w width]
	[file ...]

	-h		print help message and exit
	-v level	set verbosity level (def level: $V_FLAG)
	-V		print version string and exit

	-f path		path to the fmt command (def: $FMT)

	-1 first	indent 1st line with 1str (def: within <>: <$FIRST>)
	-e endstr	output entstr at end of line before final line (def within <>: <$END>)
	-i istr		indent 2nd and later lines with istr (def within <>: <$ISTR>)

	-c		center line of text (def: do not)
			    use: fmt -c ...
	-m		format mail header lines (def: do not)
			    use: fmt -m ...
	-n		format lines beginning . (dot) (def: do not)
			    use: fmt -n ...
	-p		allow indented paragraphs (def: do not)
			    use: fmt -p ...
	-d chars	treat chars as sentence-ending (def: do not)
			    use: fmt -d chars ...
	-l num		replace multiple spaces with tabs (def: 8)
			    0 ==> spaces are preserved
			    use: fmt -l num ...
	-t num		assume num spaces per tab (def: 8)
			    use: fmt -l num ...
	-w width	have fmt limit lines to length width (def: 72)

Exit codes:
     0	    all OK
     2	    -h and help string printed or -V and version string printed
     3	    command line error
 >= 10	    internal error

$NAME version: $VERSION"

# parse command line
#
while getopts :hv:Vf:1:e:i:cmnpd:l:t:w: flag; do
  case "$flag" in
    h) echo "$USAGE"
	exit 2
	;;
    v) V_FLAG="$OPTARG"
	;;
    V) echo "$VERSION"
	exit 2
	;;
    f) FMT="$OPTARG"
	;;
    1) FIRST="$OPTARG"
	;;
    e) END="$OPTARG"
	;;
    i) ISTR="$OPTARG"
	;;
    c) C_FLAG="-c"
	;;
    m) M_FLAG="-m"
	;;
    n) N_FLAG="-n"
	;;
    p) P_FLAG="-p"
	;;
    d) D_FLAG="$OPTARG"
	;;
    l) L_FLAG="$OPTARG"
	;;
    t) T_FLAG="$OPTARG"
	;;
    w) W_FLAG="$OPTARG"
	;;
    \?) echo "$0: invalid option: -$OPTARG" 1>&2
	echo 1>&2
	echo "$USAGE" 1>&2
	exit 3
	;;
    :) echo "$0: option -$OPTARG requires an argument" 1>&2
	echo 1>&2
	echo "$USAGE" 1>&2
	exit 3
	;;
    *) echo "$0: unexpected value from getopts: $flag" 1>&2
	echo 1>&2
	echo "$USAGE" 1>&2
	exit 3
	;;
  esac
done
#
# remove the options
#
shift $(( OPTIND - 1 ));

# debug non-fmt options
#
if [[ $V_FLAG -ge 1 ]]; then
    echo "$0: debug[1]: debug level: $V_FLAG" 1>&2
    echo "$0: debug[1]: end line text within <>: <$END>" 1>&2
    echo "$0: debug[1]: 2nd and later line indent within <>: <$ISTR>" 1>&2
fi

# build fmt options
#
declare -a F_OPTION
if [[ -n $C_FLAG ]]; then
    if [[ $V_FLAG -ge 5 ]]; then
	echo "$0: debug[5]: set -c" 1>&2
    fi
    F_OPTION+=("-c")
fi
if [[ -n $M_FLAG ]]; then
    if [[ $V_FLAG -ge 5 ]]; then
	echo "$0: debug[5]: set -m" 1>&2
    fi
    F_OPTION+=("-m")
fi
if [[ -n $N_FLAG ]]; then
    if [[ $V_FLAG -ge 5 ]]; then
	echo "$0: debug[5]: set -n" 1>&2
    fi
    F_OPTION+=("-n")
fi
if [[ -n $P_FLAG ]]; then
    if [[ $V_FLAG -ge 5 ]]; then
	echo "$0: debug[5]: set -p" 1>&2
    fi
    F_OPTION+=("-p")
fi
if [[ -n $D_FLAG ]]; then
    if [[ $V_FLAG -ge 5 ]]; then
	echo "$0: debug[5]: set -d $D_FLAG" 1>&2
    fi
    F_OPTION+=("-p")
fi
if [[ -n $L_FLAG ]]; then
    if [[ $V_FLAG -ge 5 ]]; then
	echo "$0: debug[5]: set -l $L_FLAG" 1>&2
    fi
    F_OPTION+=("-l $L_FLAG")
fi
if [[ -n $T_FLAG ]]; then
    if [[ $V_FLAG -ge 5 ]]; then
	echo "$0: debug[5]: set -t $T_FLAG" 1>&2
    fi
    F_OPTION+=("-t $T_FLAG")
fi
if [[ -n $W_FLAG ]]; then
    if [[ $V_FLAG -ge 5 ]]; then
	echo "$0: debug[5]: set -w $W_FLAG" 1>&2
    fi
    F_OPTION+=("-w $W_FLAG")
fi
if [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: will use fmt: $FMT" 1>&1
fi
F_OPTION+=("--")
if [[ $V_FLAG -ge 1 ]]; then
    echo "$0: debug[1]: will use fmt: $FMT ${F_OPTION[*]} $*" 1>&2
fi

# run fmt
#
"$FMT" "${F_OPTION[@]}" "$@" |
    awk -v first="$FIRST" -v end="$END" -v istr="$ISTR" \
	'NR == 1 {line = $0;}
	 NR == 2 {print first line end; line=$0;}
	 NR > 2 {print istr line end; line=$0;}
	 END {if (NR == 1) { print first line; } else { print istr line; }}'
export EXIT_CODE="${PIPESTATUS[0]}"

# exit according to fmt exit code
#
if [[  $V_FLAG -ge 1 && $EXIT_CODE -ne 1 ]]; then
    echo "$0: debug[1]: fmt ext code: $EXIT_CODE" 1>&2
fi
exit "$EXIT_CODE"
