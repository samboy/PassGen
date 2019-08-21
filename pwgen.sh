#!/bin/sh

# Change this to something else to get a tiny bit more security
# (but changing this will break passwords already being used)
# Be aware that SUFFIX is here not for security, but to generate
# passwords allowed by stupid site-specific password rules
SUFFIX="Aa9"

# All of the passwords are generated from the file .master_password
# Edit that file to generate a secure master password.  Not that
# the security of this system is dependent on the master password being
# secret.
SECRET=$( cat $HOME/.master_password )
if [ -z "$SECRET" ] ; then
	echo Could not find $HOME/.master_password
	exit 1
fi

SITE="$1"
if [ -z "$SITE" ] ; then
	echo Usage: $0 {site} 
	echo Where {site} is the website to generate a password for
	exit 1
fi

# As a general rule, *most* sites require: 8-16 characters, at least one:
# a) lower case letter
# b) upper case letter
# c) number
# d) punctuation, where _ is considered punctuation
# This script adds _Aa1 to the end of each password which covers
# *most* sites.  However, this being the internet, some sites have dumb
# password rules we have to make exceptions for.  This script covers
# most of them

# Some sites will not allow a '_' character in their passwords.  That
# in mind, we can optionally zap the '_' character.
# Real world offender: timewarnercable.com
ZAP='~'

# Some sites do not consider _ punctuation.  
# Make $CHANGE something besides '_' to change the '_' to another symbol
# Real world offender: southwest.com
CHANGE='_'

# Some sites require passwords to be changed frequently.  This is actually
# a reasonable security practice, and we support it
INDEX=1

# Some sites might require a password to be longer than 16 characters, or
# to be shorter. The password length is 4 + (4 * LEN), so for a site which
# can only handle passwords 12 characters long, make LEN 2; for a site which
# can only handle 8 character passwords, make LEN 1.  For someone who needs
# 24 chars in the password, make LEN 5.

LEN=3 # 16 character password

# This makes it hard to brute force a master password should a 
# generated password be compromised.  Higher single-digit numbers are
# more secure, but password generation takes longer
# For compatibility with older versions of pwgen, make cost "@"
COST=3

##### SITE SPECIFIC RULES GO HERE #####
case "$SITE" in
timewarnercable.com)
	ZAP='_' # Remove the _ at the end of the password
	;;
southwest.com)
	CHANGE=':' # Make the _ a : in the password
	;;
paypal.com)
	INDEX=2 # Increase index by 1 every time we change a password
	;;
shutterfly.com)
	# For sites (hello, Shutterfly!) which can only have a password up 
	# to an odd length (10 chars in the case of Shutterfly), we have 
	# a special "Exact number of chars" rule.
	# LEN can not be greater than 36 when EXACTCHARS is set
	EXACTCHARS=1 # LEN now the exact length of password in characters
	LEN=10 
	;;
esac
### END SITE SPECIFIC RULES ###

# Make sure microrg32 is in the path; if not then compile and run it
MICRORG32="microrg32"

if ! command -v microrg32 > /dev/null 2>&1 ; then
	cat > microrg32-$$.c << EOF
#include <stdio.h> // cc -o microrg32 microrg32.c ; WORK=3 ; LEN=4 ######
#include <stdint.h> // SECRET="Something random like qhohxks5mx9elv6ujg3"
#include <stdlib.h> // export P="$LEN:$SECRET:x.org" # Public domain code
#define b(z) for(c=0;c<(z);c++) // ./microrg32 $WORK $LEN | head -1| tail
uint32_t c,e[42],f[42],g=19,h=13,r,s,n[45],i,k;char*q,y;void m(){int c,j=
0;b(12)f[c+c%3*h]^=e[c+1];b(g){j+=c;i=c*7%g;k=e[i++];k^=e[i%g]|~e[(i+1)%g
];n[c]=n[c+g]=k>>j|k<<-j%32;}for(c=39;c--;f[c+1]=f[c])e[c]=n[c]^n[c+1]^n[
c+4];*e^=1;b(3)e[c+h]^=f[c*h]=f[c*h+h];}int main(int p,char**v){q=getenv(
"P");if(q&&p>2){for(;;m()){b(3){for(r=0;r<4;){f[c*h]^=k=(*q?*q&255:1)<<8*
r++;e[16+c]^=k;if(!*q++){b(17+(1<<*v[1]%32))m();b(983){s=e[1+c%2];r=c;if(
c%2)m();b(4){y=y>0?y:*v[2]%16;i=s;s>>=8;if(y){i&=31;i+=i<8?50:89;}printf(
y?"%c":"%02x",i&255);}c=r;if(--y<1||c>981)puts("");}return 0;}}}}}}/*--*/
EOF
	cc -o microrg32-$$ microrg32-$$.c
	MICRORG32=./microrg32-$$
fi

# If you need a really really large index, change this command line
export P="$LEN:$SECRET:$SITE"
if [ -z "$EXACTCHARS" ] ; then
    PW=$( $MICRORG32 $COST $LEN | head -$INDEX | tail -1 | tr -d "$ZAP" | \
	tr '_' "$CHANGE" )
    echo ${PW}_${SUFFIX}
else
    $MICRORG32 $COST 9 | head -$INDEX | tail -1 | tr -d "$ZAP" | \
	tr '_' "$CHANGE" | awk '{print substr($0,1,'$LEN')}' 
fi

rm -f ./microrg32-$$ ./microrg32-$$.c ./microrg32-$$.exe

