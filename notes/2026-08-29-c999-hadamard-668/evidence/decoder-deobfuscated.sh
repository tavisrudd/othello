# DO NOT RUN -- reference only.
#
# Static de-obfuscation of the shell script embedded in the poster's reply
# (evidence/decoder-raw.txt).  The reply's first line is
#     sed 's/M/\\/g;s/I/\//g;y/<cipher>/<plain>/'<<'_'>/tmp/r ... _ ; sh /tmp/r $*
# The three substitutions (M -> backslash, I -> forward slash, then an
# 81-character transliteration) were applied in Python, never by sed/sh.
# The result below is the script the poster intended to execute.  It was read
# and re-implemented from scratch in decode.py; it has never been run here.
#
W=$(sed 'H;$!d;x;s/[^-+]//g' $*)
c(){ n=$1;x=$(echo $W|cut -c1-$1);W=$(echo $W|cut -c$(($1+1))-);}
r(){ printf %s "$3$(echo $x|fold -w$1|sed "$2"';$!s/$/\\/')";}
h(){ d=$x
sed>/tmp/p "$1"'s/r/\\(%\\)\\(.\\)/;s/l/\\(.\\)\\(%\\)/g;s|L\(.\)\(.*\)|;s/.*/\&\\\
\&/\
:\1\
P\
s/\2\\n/\\2\\1\\4\\3\\6\\5\\8\\7\\\
/\
/^\\(.*\\)\\n\\1/!b\1\
g;y/+-/-+/;G|;s/=/\\(A\\)/g;s/Z/%...\\(.\\)\\(%\\)/g;s/A/%./g;s/%/.\\{'$((n/8))'\\}.\\{'$((n/4-1-n/8))'\\}/g'<<'^'
h;y/+/-/;H;y/-/+/;G;s/^=.*\n\(=AA\).*/-++-\2\1\
+-+-\3\3\1\3\
++--\3\1\3\3\
----\1\2/p;g;s/\n.*//
s/^=\(.*\)/\1\
\2\
\2/
:4
s/\n\(.*\)\(.\)\n/\2\
\1\
/
t4
h;s/^====.*/+++-\1\4\3\2/L0rlll
s/^AAA=ZA.=AAAAZ.*/--+-\1\4\6\5\3\2/L1lrll
s/^AA=AAZ.=AAZ.*/-+--\1\3\2\4\6\5/L2llrl
s/^A=AZAA.=AAAZ.*/+---\1\6\5\3\2\4/L3lllr
d
^
echo $d|sed -f /tmp/p
}
g(){ h '1,4d;s,/[-+]\{4\},/,;';}
w(){ d=$x;m=$n
{ c 336;r 28 's/^/B/' 'h;y/-/+/;H;y/+/-/;G;s/^=[-+]*\n[-+]*\n=.*/'
cat<<'^'
/p;g;s/\n.*//;h;s/l/\1,\2;/g
:8
s/,\([-+]*\)\([-+]\);/\2,\1;/g;t8
s/,;//g;G;h;y/+-/-+/;G;s/^JJK\(KKK\)\nI.*/\2\1\
^
c 48;r 12 's/^//'
cat<<'^'
/L01rlll
s/^KIKK\nKKIK\nJIKKI/\1\3\4\2\
^
c 48;r 12 's/^//'
cat<<'^'
/L23lrll
s/^KKIK\nKKKI\nJ\(KK\).*/\1\2\3\
^
c 48;r 12 's/^//'
cat<<'^'
/L45llrl
s/^KKKI\nKIKK\nJIKI.*/\1\4\2\3\
^
c 48;r 12 's/^//'
cat<<'^'
/L67lllr
d
^
}>/tmp/q
sed>/tmp/p ':c
/B............[-+]/s/+\([^-+]*\)$/\\2\1/;/B............[-+]/s/-\([^-+]*\)$/\\1\1/;tc
s/B//;s|L\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)|\
:\1\
/^[-+]*\\nZ\\nZ\\nZ$/s/==/\\2\\1/g;/^[-+]*\\nZ\\nZ$/s/====/\\4\\3\\2\\1/g;/^[-+]*\\nZ$/s/==/\\2\\1/g;s/^\\([-+]*\\)\\n\\(Z\\)/\\2\\1\\\
\\2\\1/\
:\2\
P;s/^\\(Z\\)\3\3\3\3/~/;s/^\\(ZK\\)\4\4\4\4/~/;s/^\\(ZKK\\)\5\5\5\5/~/;s/^\\(ZKKK\\)\6\6\6\6/~/;/^\\(.*\\)\\n\\1/!b\2\
s/^[-+]*\\nZ//;/\\n/b\1\
g;y/+-/-+/;G|;s/J/KKKK\\n/g;s/I/\\(K\\)/g;s/r/\\(%\\)\\(.\\)/g;s/l/\\(.\\)\\(%\\)/g;s/~/\\1\\3\\2\\5\\4\\7\\6\\9\\8/g;s/Z/............/g;s/K/AAAA/g;s/=/\\(A\\)/g;s/A/%./g;s/%/.\\{'$((m/16-1))'\\}/g' /tmp/q
echo $d|sed -f /tmp/p
}
v(){ d=$x;m=$n
{ c 880;r 44 's/^\(.\{20\}\)/\1S/' 'h;y/-/+/;x;H;y/+/-/;G;s/^=[-+]*\n=.*/'
cat<<'^'
/;s/S//g;p;g;s/.*\n//;h;s/l/\1,\2;/g
:8
s/,\([-+]*\)\([-+]\);/\2,\1;/g;t8
s/,;//g;s/===/\1\3\2/g;G;h;y/+-/-+/;G;s/^JJK\(KKK\)\nI.*/\2\1\
^
c 120;r 20 's/^//'
cat<<'^'
/X0rlllY0
s/^KIKK\nKKIK\nJIKKI/\1\3\4\2\
^
c 120;r 20 's/^//'
cat<<'^'
/X1lrllY1K
s/^KKIK\nKKKI\nJ\(KK\).*/\1\2\3\
^
c 120;r 20 's/^//'
cat<<'^'
/X2llrlY2KK
s/^KKKI\nKIKK\nJIKI.*/\1\4\2\3\
^
c 120;r 20 's/^//'
cat<<'^'
/X3lllrY3KKK
d
^
}>/tmp/q
sed>/tmp/p ':c
/S[-+]/s/+\([^-+]*\)$/\\2\1/;/S[-+]/s/-\([^-+]*\)$/\\1\1/;tc
s|X\(.\)\(.\)\(.\)\(.\)\(.\)|\
:\1\
s/^\\([-+]*\\)\\n\\(Z\\)/\\2\\1\\\
\\2\\1/\
:\1\1\
P;s/^\\(Z\\)\2\2\2/~/;s/^\\(ZAAA\\)\2\2\2/~/;s/^\\(ZK\\)\3\3\3/~/;s/^\\(ZKAAA\\)\3\3\3/~/;s/^\\(ZKK\\)\4\4\4/~/;s/^\\(ZKKAAA\\)\4\4\4/~/;s/^\\(ZKKK\\)\5\5\5/~/;s/^\\(ZKKKAAA\\)\5\5\5/~/;/^\\(.*\\)\\n\\1/!b\1\1|;s|Y\(.\)\(K*\)|\
s/^[-+]*\\n//;s/^\\(Z\2\\)QQ/\\1\\3\\2\\5\\4/;s/^Z//;s/Q/\\2\\1/g;/^[-+]*\\nZ\\nZ\\nZ$/s/WW/\\2\\1/g;/\\n/b\1\
g;y/+-/-+/;G|;s/J/KKKK\\n/g;s/I/\\(K\\)/g;s/W/\\(AAA\\)/g;s/Q/=\\(AA\\)/g;s/r/\\(%\\)\\(.\\)/g;s/l/\\(.\\)\\(%\\)/g;s/~/\\1\\3\\2\\5\\4\\7\\6/g;s/Z/..................../g;s/K/AAAAAA/g;s/=/\\(A\\)/g;s/A/%./g;s/%/.\\{'$((m/24-1))'\\}/g' /tmp/q
echo $d|sed -f /tmp/p
}
u(){ d=$x;m=$n
{ c 1680;r 60 's/^\(.\{28\}\)/\1S/' 'h;y/-/+/;x;H;y/+/-/;G;s/^=[-+]*\n=.*/'
cat<<'^'
/;s/S//g;p;g;s/.*\n//;h;s/l/\1,\2;/g
:8
s/,\([-+]*\)\([-+]\);/\2,\1;/g;t8
s/,;//g;s/========/\1\8\7\6\5\4\3\2/g;G;h;y/+-/-+/;G;s/^JJK\(KKK\)\nI.*/\2\1\
^
c 896;r 28 's/^//'
cat<<'^'
/X0rlllY0
s/^KIKK\nKKIK\nJIKKI/\1\3\4\2\
^
c 896;r 28 's/^//'
cat<<'^'
/X1lrllY1K
s/^KKIK\nKKKI\nJ\(KK\).*/\1\2\3\
^
c 896;r 28 's/^//'
cat<<'^'
/X2llrlY2KK
s/^KKKI\nKIKK\nJIKI.*/\1\4\2\3\
^
c 896;r 28 's/^//'
cat<<'^'
/X3lllrY3KKK
d
^
}>/tmp/q
sed>/tmp/p ':c
/S[-+]/s/+\([^-+]*\)$/\\2\1/;/S[-+]/s/-\([^-+]*\)$/\\1\1/;tc
/S/s/\\.\\./&&&&/g;s|X\(.\)\(.\)\(.\)\(.\)\(.\)|\
:\1\
s/^\\([-+]*\\)\\n\\(Z\\)/\\2\\1\\\
\\2\\1/\
:\1\1\
P;s/^\\(Z\\)\2\2\2\2/~/;s/^\\(ZAAAA\\)\2\2\2\2/~/;s/^\\(ZC\\)\2\2\2\2/~/;s/^\\(ZCAAAA\\)\2\2\2\2/~/\
s/^\\(ZCC\\)\2\2\2\2/~/;s/^\\(ZCCAAAA\\)\2\2\2\2/~/;s/^\\(ZCCC\\)\2\2\2\2/~/;s/^\\(ZCCCAAAA\\)\2\2\2\2/~/\
s/^\\(ZK\\)\3\3\3\3/~/;s/^\\(ZKAAAA\\)\3\3\3\3/~/;s/^\\(ZKC\\)\3\3\3\3/~/;s/^\\(ZKCAAAA\\)\3\3\3\3/~/\
s/^\\(ZKCC\\)\3\3\3\3/~/;s/^\\(ZKCCAAAA\\)\3\3\3\3/~/;s/^\\(ZKCCC\\)\3\3\3\3/~/;s/^\\(ZKCCCAAAA\\)\3\3\3\3/~/\
s/^\\(ZKK\\)\4\4\4\4/~/;s/^\\(ZKKAAAA\\)\4\4\4\4/~/;s/^\\(ZKKC\\)\4\4\4\4/~/;s/^\\(ZKKCAAAA\\)\4\4\4\4/~/\
s/^\\(ZKKCC\\)\4\4\4\4/~/;s/^\\(ZKKCCAAAA\\)\4\4\4\4/~/;s/^\\(ZKKCCC\\)\4\4\4\4/~/;s/^\\(ZKKCCCAAAA\\)\4\4\4\4/~/\
s/^\\(ZKKK\\)\5\5\5\5/~/;s/^\\(ZKKKAAAA\\)\5\5\5\5/~/;s/^\\(ZKKKC\\)\5\5\5\5/~/;s/^\\(ZKKKCAAAA\\)\5\5\5\5/~/\
s/^\\(ZKKKCC\\)\5\5\5\5/~/;s/^\\(ZKKKCCAAAA\\)\5\5\5\5/~/;s/^\\(ZKKKCCC\\)\5\5\5\5/~/;s/^\\(ZKKKCCCAAAA\\)\5\5\5\5/~/;/^\\(.*\\)\\n\\1/!b\1\1|;s|Y\(.\)\(K*\)|\
s/^[-+]*\\n//;s/^\\(Z\2\\)QQQQ/~/;s/^Z//\
s/^WWWW/M/;s/^IWWWW/~/;s/^\\(KK\\)WWWW/~/;s/^\\(KKK\\)WWWW/~/\
/^[-+]*OOO$/s/^VVVVVVVV/M/\
/^[-+]*OOO$/s/^\\(KK\\)VVVVVVVV/~/\
/^[-+]*OO$/s/^VVVVVVVV/M/\
/^[-+]*OO$/s/^\\(KK\\)VVVVVVVV/~/\
/^[-+]*OO$/s/^UUUUUUUU/M/\
/^[-+]*O$/s/^VVVVVVVV/M/\
/^[-+]*O$/s/^\\(KK\\)VVVVVVVV/~/;/\\n/b\1\
g;y/+-/-+/;G|;s/J/KKKK\\n/g;s/I/\\(K\\)/g;s/V/\\(C\\)/g;s/U/\\(CC\\)/g;s/W/\\(A\\)\\(.\\{77\\}\\)/g;s/Q/\\(.\\{66\\}\\)\\(.\\{22\\}\\)/g;s/O/\\nZ\\nZ\\nZ\\nZ\\nZ\\nZ\\nZ\\nZ/g;s/M/\\2\\1\\4\\3\\6\\5\\8\\7/g;s/~/\\1\\3\\2\\5\\4\\7\\6\\9\\8/g;s/r/\\(%\\)\\(.\\)/g;s/l/\\(.\\)\\(%\\)/g;s/Z/............................/g;s/K/.\\{176\\}.\\{176\\}/g;s/C/.\\{88\\}/g;s/=/\\(A\\)/g;s/A/%./g;s/%/.\\{'$((m/128-1))'\\}/g' /tmp/q
echo $d|sed -f /tmp/p
}
e=$(echo bnghbndhdmiddljddlcdhkkhjkhpbjhhbjbhfiipdigddifd|sed 's/a/++++/g;s/b/+++-/g;s/c/++-+/g;s/d/++--/g;s/e/+-++/g;s/f/+-+-/g;s/g/+--+/g;s/h/+---/g
s/i/-+++/g;s/j/-++-/g;s/k/-+-+/g;s/l/-+--/g;s/m/--++/g;s/n/--+-/g;s/o/---+/g;s/p/----/g')
while [ -n "$e" ]
do k=$(echo $e|cut -c1-3);b=$(echo $e|cut -c4-16);e=$(echo $e|cut -c17-);n=0
while [ -n "$b" ];do case $b in +*) n=$((n*2+1));;*) n=$((n*2));;esac;b=$(echo $b|cut -c2-);done
c $n;case $k in +++) h;;++-) g;;+-+) w;;+--) v;;-++) u;;esac
done
