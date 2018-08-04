# Generate secure passwords

PassGen is a password generation shell script.

pwgen.sh allows the one to generate secure passwords for websites. 
To use, do something like this:

```
echo 'Some secret string' > ~/.master_password # Only do this once
pwgen.sh facebook.com
```

Replace “Some secret string” with a suitably hard to guess string, and 
facebook.com with the site you need to log in to.

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
edited by hand for each stire with a stupid password rule which 
its default behavior does not cover.  There is a section giving
examples of how to deal with site-specific rules.

## Security considerations

The master password needs to be kept secret.

This tool should not be used on multi-user systems; untrusted users
can peek at the master password while the password is being generated.

### Cryptography used

The underlying C program which provides the cryptography for passwords is
only 12 lines long.

```c
#include <stdio.h> // cc -o tinyrg32 tinyrg32.c /////// Public domain code
#include <stdint.h> // ./tinyrg32 --hex --numbers 'A tiny list of numbers'
#define b(z) for(c=0;c<(z);c++) // ./tinyrg32 --binary-stream 'Es la niña'
uint32_t c,e[40],f[40],g=19,h=13,r,s,t,n[40],i,k,y,z;void m(){int c,j=0;b(
12)f[c+c%3*h]^=e[c+1];b(g){j=(c+j)&31;i=c*7%g;k=e[i++];k^=e[i%g]|~e[(i+1)%
g];n[c]=k>>j|k<<(32-j);}for(c=39;c--;f[c+1]=f[c])e[c]=n[c]^n[(c+1)%g]^n[(c
+4)%g];*e^=1;b(3)e[c+h]^=f[c*h]=f[c*h+h];}int main(int p,char**v){char *q=
v[--p],*x=0;for(;;m()){b(3){for(r=0;r<4;){f[c*h]^=k=(*q?*q&255:1)<<8*r++;e
[16+c]^=k;if(!*q++){b(17)m();b(p<3?8:89*p){if(~t&1)m();s=e[(t&1)+1];r=(p&3
)-2?c:1;b(4){i=s;if(p&4){x=v[p-2];y=z=z?z:*v[p-1]%16;i&=31;i+=i<8?50:89;}s
>>=8;printf(p==2||p&4?"%c":"%02x",255&i);}if((++t%8==0||(p&22)==2)&&p-2&&!
y){puts("");}c=r;if(y&&!--z)puts(*x==95?x:"");}if(x)puts(x);return 0;}}}}}
```

This is a compact implementation, suitable for printing on a coffee mug, of 
[RadioGatún32](http://radiogatun.noekeon.org/), a secure hash function and 
stream cipher.  For programmers who find this hard to read, a somewhat out
of date explanation of how the code works is 
[available](https://github.com/samboy/rg32hash/blob/master/C/nanorg32.md).

The above program also has a 
[user guide](https://github.com/samboy/rg32hash/blob/master/C/tinyrg32.md).

## Some other C programs

This package includes a couple of other C programs:

* `randomLetters.c`  This small C program generates 32 random letters
  with 5 bits of entropy each, giving us a string with 160 bits of
  entropy.  `/dev/urandom` support needed (MacOS, Windows + Cygwin, Linux,
  any other UNIX clone with /dev/urandom)
* `tinyrg32.c`  This is a standalone version of the program which pwgen.sh
  uses to generate the undelying random numbers.  If the program `tinyrg32`
  is in one’s `$PATH`, the pwgen.sh script will not need to compile its
  built-in version of tinyrg32.c to generate secure passwords.

To compile these two program, simply type in `make` (the classic UNIX
make program will, of course, be needed—it’s surprising how many so-called
UNIX systems do not include this out of the box these days, but the package
is available for pretty much every modern UNIX variant out there).

