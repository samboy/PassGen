/* Donated to the public domain 2018 by Sam Trenholme (CC0 "license")
 * https://creativecommons.org/publicdomain/zero/1.0/
 *
 * This small C program generates 32 random letters with 5 bits of 
 * entropy each, giving us a string with 160 bits of total entropy.
 *
 * a is the file pointer to /dev/urandom
 * b is the loop iterator; change "b<32" to give the output string another
 *   length
 * i is the character the users sees when running this program; we use a 
 *   simple small algorithm to convert an 8-bit random number in to a 
 *   5-bit alphanumeric random number
 *
 * The alphabet is non-standard: "23456789abcdefghijklmnopqrstuvwx" (where
 * a binary 0 becomes "2", a binary 1 "3", a binary 8 "a", and so on)
 */

#include <stdio.h>

int main() {
	FILE *a;
	int b, i;
	a = fopen("/dev/urandom","rb");
	if(a == NULL) { printf("Error opening /dev/urandom!\n"); return 1; }
	for(b=0;b<32;b++) {
		i = getc(a);
		i&=31;i+=i<8?50:89;
		printf("%c",i);
	}
	printf("\n");
	return 0;
}
