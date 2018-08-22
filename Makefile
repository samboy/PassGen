all: randomLetters microrg32

clean:
	rm -f randomLetters microrg32 tinyrg32 *exe

randomLetters: randomLetters.c
	cc -O2 -Wall -Wpedantic -o randomLetters randomLetters.c

microrg32: microrg32.c
	cc -std=c99 -O2 -Wall -Wpedantic -o microrg32 microrg32.c
