all: randomLetters tinyrg32

clean:
	rm -f randomLetters tinyrg32 *exe

randomLetters:
	cc -O2 -Wall -Wpedantic -o randomLetters randomLetters.c

tinyrg32:
	cc -O2 -Wall -Wpedantic -o tinyrg32 tinyrg32.c
