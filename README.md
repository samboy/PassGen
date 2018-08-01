# Generate secure passwords

pwgen.sh allows the one to generate secure passwords for websites. 
To use, do something like this:

```
echo 'Some secret string' > ~/.master_password # Only do this once
pwgen.sh facebook.com
```

Replace “Some secret string” with a suitably hard to guess string, and 
facebook.com with the site you need to log in to.

To create another password for the site, edit the file `pwgen.sh`
to give, say. facebook.com a higher `INDEX` value.

## Dealing with website rules

Obligatory: https://xkcd.com/936/

The password “hlrehcv5kn4o545v” has (or had, until I posted this)
a good deal more security than “Password1!” (the has 80 bits of
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
