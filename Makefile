.PHONY: case-1 case-2 case-3 case-4 case-warning case-5 clean

all: clean case-1 case-2 case-3 case-4 case-warning case-5

case-1: test.c
	cat test.c
	cov-build --dir cov-test gcc -c test.c -o test.o
	cov-analyze --dir cov-test -V 0 --ignore-deviated-findings
	find cov-test -name deviations.txt | xargs cat

case-2: test-pragma.c
	cat test-pragma.c
	cov-build --dir cov-test-pragma gcc -c test-pragma.c -o test-pragma.o
	cov-analyze --dir cov-test-pragma -V 0 --ignore-deviated-findings
	find cov-test-pragma -name deviations.txt | xargs cat

case-3: test-_Pragma.c
	cat test-_Pragma.c
	cov-build --dir cov-test-_Pragma gcc -c test-_Pragma.c -o test-_Pragma.o
	cov-analyze --dir cov-test-_Pragma -V 0 --ignore-deviated-findings
	find cov-test-_Pragma -name deviations.txt | xargs cat

case-4: test-macro.c
	cat test-macro.c
	cov-build --dir cov-test-macro gcc -c test-macro.c -o test-macro.o
	cov-analyze --dir cov-test-macro -V 0 --ignore-deviated-findings
	find cov-test-macro -name deviations.txt | xargs cat

case-warning: test-warning.c
	cat test-warning.c
	gcc -Wall -c test-warning.c -o test-warning.o

case-5: test-macro-workaround.c
	cat test-macro-workaround.c
	cov-build --dir cov-test-macro-workaround gcc -c test-macro-workaround.c -o test-macro-workaround.o
	cov-analyze --dir cov-test-macro-workaround -V 0 --ignore-deviated-findings
	find cov-test-macro-workaround -name deviations.txt | xargs cat

clean:
	rm -rf *.o cov-test*