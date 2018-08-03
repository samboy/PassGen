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
}
