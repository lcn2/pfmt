# pfmt

Paragraph formatting with continuation lines.


# To install

```sh
sudo make install
```


# To use

```sh
/usr/local/bin/pfmt [-h] [-v level] [-V]
	[-f path]  [-1 first] [-e endstr] [-i istr]
	[-c] [-m] [-n] [-p] [-d chars] [-l num] [-t num] [-w width] [-a awk]
	[file ...]

	-h		print help message and exit
	-v level	set verbosity level (def level: 0)
	-V		print version string and exit

	-f path		path to the fmt command (def: use $PATH)

	-1 first	indent 1st line with 1str (def: within <>: <>)
	-e endstr	output entstr at end of line before final line (def within <>: < \>)
	-i istr		indent 2nd and later lines with istr (def within <>: <	>)

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

	-a awk		set path to awk (def: use $PATH)

	file		file to read from (def: stdin)
			    NOTE: you can specify more than one file but if you
			    do it will not read from stdin ('-' not accepted)

Exit codes:
     0	    all OK
     2	    -h and help string printed or -V and version string printed
     3	    command line error
     5	    fmt is not a regular executable file
     4	    awk is not a regular executable file
 >= 10	    internal error

pfmt version: 1.0.3 2023-07-11
```


# Reporting Security Issues

To report a security issue, please visit "[Reporting Security Issues](https://github.com/lcn2/pfmt/security/policy)".
