# Generate secure passwords

PassGen is a password generation shell script.

pwgen.sh allows the one to generate secure passwords for websites. 
To use, do something like this:

```
echo 'Some secret string hlrehcv5kn4' > ~/.master_password # Only do this once
pwgen.sh facebook.com
```

Replace `Some secret string hlrehcv5kn4` with a suitably hard to guess
string, and facebook.com with the site you need to log in to.

This script is for people familiar with shell scripting (or Bash, as
it’s usually called these days); by being a shell script, the rules can
be customized for sites with difficult password rules.

To create another password for the site, edit the file `pwgen.sh`
to give, say, facebook.com a higher `INDEX` value.

## Requirements to install:

* A Posix compliant Bourne Shell compatible command line interpreter
  (this comes with Linux and Mac; Windows users can install 
   [Cygwin](https://cygwin.com))
* A C compiler with the name `cc`  This compiles the underlying
  cryptographic program.

## Dealing with website rules

Obligatory: https://xkcd.com/936/

The password “hlrehcv5kn4o545v” has (or had, until I posted this)
a good deal more security than “Password1!” (the first has 80 bits of
entropy; the largest attacks I have seen, requiring entire datacenters
filled with computers, can crack 64 bits; the second has at best 28 bits
of security), but many sites consider the first password insecure and
the second password secure.

Making people have mixed case or punctuation in their password does
not increase password security that much. However, it makes password
management a pain.  For the majority of websites, adding the string
`_Aa9` to the end of a password will allow a password to be considered
“secure”; this password generator does that.

While most sites accept the underscore `_` as a “punctuation”
character, some do not.  Southwest, for example, does not even allow a `_`
in a password, so pwgen.sh has a special “for Southwest, use : instead 
of _ for punctuation” rule in it.

To handle site specific rules, the script pwgen.sh will need to be
edited by hand for each site with a stupid password rule which 
its default behavior does not cover.  There is a section giving
examples of how to deal with site-specific rules.

## Security considerations

The master password needs to be kept secret.  The master password 
should have enough entropy (i.e. be long enough) to be difficult 
to guess.

Be sure to keep the password in the clipboard for a minimal amount
of time.  Browser extensions or other installed software may have
access to the clipboard; note that [browsers don’t allow arbitrary
websites unrestricted clipboard access](https://www.lucidchart.com/techblog/2014/12/02/definitive-guide-copying-pasting-javascript/); see [this
Mozilla article](http://kb.mozillazine.org/Granting_JavaScript_access_to_the_clipboard).

### Cryptography used

The underlying C program which provides the cryptography for passwords is
only 12 lines long.

```c
#include <stdio.h> // cc -o microrg32 microrg32.c ; WORK=3 ; LEN=4 #######
#include <stdint.h> // SECRET="Something random like qhohxks5mx9elv6ujgx3"
#include <stdlib.h> // export P="$LEN:$SECRET:x.org" ## Public domain code
#define b(z) for(c=0;c<(z);c++) // ./microrg32 $WORK $LEN | head -1 | tail
uint32_t c,e[42],f[42],g=19,h=13,r,s,n[45],i,k;char*q;void m(){int c;r=0;b
(12)f[c+c%3*h]^=e[c+1];b(g){r=(r+c)%32;i=c*7%g;k=e[i++];k^=e[i%g]|~e[(i+1)
%g];n[c]=n[c+g]=k>>r|k<<-r%32;}for(c=39;c--;f[c+1]=f[c])e[c]=n[c]^n[c+1]^n
[c+4];*e^=1;b(3)e[c+h]^=f[c*h]=f[c*h+h];}int main(int p,char **v){q=getenv
("P");if(q&&p>2){for(;;m()){b(3){for(r=0;r<4;){f[c*h]^=k=(*q?*q&255:1)<<8*
r++;e[16+c]^=k;if(!*q++){p=0;b(17+(1<<*v[1]%32))m();b(983){s=e[1+c%2];r=c;
b(4){p=p>0?p:*v[2]%16;i=s;s>>=8;if(p!=0){i&=31;i+=i<8?50:89;}printf(p?"%c"
:"%02x",i&255);}c=r;if(c%2)m();if(--p<1||c>981)puts("");}return 0;}}}}}}//
```

This is a compact implementation, suitable for printing on a coffee mug, of 
[RadioGatún32](http://radiogatun.noekeon.org/), a secure hash function and 
stream cipher.  For programmers who find this hard to read, a somewhat out
of date explanation of how the code works is 
[available](https://github.com/samboy/rg32hash/blob/master/C/nanorg32.md).

The above program also has a 
[user guide](https://github.com/samboy/passgen/blob/master/microrg32.md).

## Some other C programs

This package includes a couple of other C programs:

* `randomLetters.c`  This small C program generates 32 random letters
  with 5 bits of entropy each, giving us a string with 160 bits of
  entropy.  `/dev/urandom` support needed (MacOS, Windows + Cygwin, Linux,
  any other UNIX clone with /dev/urandom)
* `microrg32.c`  This is a standalone version of the program which pwgen.sh
  uses to generate the undelying random numbers.  If the program `microrg32`
  is in one’s `$PATH`, the pwgen.sh script will not need to compile its
  built-in version of `microrg32.c` to generate secure passwords.

To compile these two programs, simply type in `make` (the classic UNIX
make program will, of course, be needed—it’s surprising how many so-called
UNIX systems do not include this out of the box these days, but the package
is available for pretty much every modern UNIX variant out there).

## Compatibility with older versions of PassGen

Release 1.0 of PassGen, done on August 22, 2018, broke compatibility
with older versions of PassGen.  If older generated passwords are needed,
please edit pwgen.sh to make `COST` be `@` instead of `3`.

## Cyber Resilience Act statement

PassGen is a project developed on a strictly volunteer, non-commercial
basis.  It has been developed outside the course of a commercial
activity, developed entirely in the Americas (i.e. *outside of Europe*)
and therefore is not subject to the restrictions or conditions of the
proposed EU Cyber Resilience Act.  Someone selling a product that
uses any component of PassGen may be subject to this act and may
need to handle any and all necessary compliance.

PassGen is provided free of charge but with **no warranty**.

## External links

https://github.com/dropbox/zxcvbn is a useful tool for seeing how secure 
a password really is.

https://michaeldadams.org/projects/password/ is a Javascript password 
generator using a dictionary of 2048 words four letters or shorter. 
