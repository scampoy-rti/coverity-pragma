# Pragma coverity deviate problem

Coverity does not behave as expeted when using `#pragma coverity deviate`. The blocks below show different examples and their outputs.

## Case 1
Making sure that coverity works as expected, without the use of any pragmas.

```c
$ make case-1
cat test.c
int main()
{
    int *fp = 0;

    return *fp;
}
cov-build --dir cov-test gcc -c test.c -o test.o
Coverity Build Capture (64-bit) version 2023.9.0 on Linux 6.2.0-35-generic x86_64
Internal version numbers: 801eb59666 p-2023.9-push-59


Emitted 1 C/C++ compilation units (100%) successfully

1 C/C++ compilation units (100%) are ready for analysis
The cov-build utility completed successfully.
cov-analyze --dir cov-test -V 0 --ignore-deviated-findings
Coverity Static Analysis version 2023.9.0 on Linux 6.2.0-35-generic x86_64
Internal version numbers: 801eb59666 p-2023.9-push-59

Looking for translation units
[STATUS] Computing links for 1 translation unit
[STATUS] Computing virtual overrides
[STATUS] Computing callgraph
[STATUS] Topologically sorting 1 function
[STATUS] Preparing for source code analysis
[STATUS] Running Sigma analysis
[STATUS] Computing node costs
[STATUS] Running analysis
[STATUS] Exporting summaries
Analysis summary report:
------------------------
Files analyzed                 : 1 Total
    C                          : 1
Total LoC input to cov-analyze : 5
Functions analyzed             : 1
Paths analyzed                 : 1
Time taken by analysis         : 00:00:08
Defect occurrences found       : 1 FORWARD_NULL

find cov-test -name deviations.txt | xargs cat

$
```

The results are as expected

## Case 2
This case demonstrates the basic use of the  #pragma coverity deviate directive added to the source code of the previous case.

```c
$ make case-2
cat test-pragma.c
int main()
{
    int *fp = 0;

    #pragma coverity compliance deviate "FORWARD_NULL" "Intentional null deref"
    return *fp;
}
cov-build --dir cov-test-pragma gcc -c test-pragma.c -o test-pragma.o
Coverity Build Capture (64-bit) version 2023.9.0 on Linux 6.2.0-35-generic x86_64
Internal version numbers: 801eb59666 p-2023.9-push-59


Emitted 1 C/C++ compilation units (100%) successfully

1 C/C++ compilation units (100%) are ready for analysis
The cov-build utility completed successfully.
cov-analyze --dir cov-test-pragma -V 0 --ignore-deviated-findings
Coverity Static Analysis version 2023.9.0 on Linux 6.2.0-35-generic x86_64
Internal version numbers: 801eb59666 p-2023.9-push-59

Looking for translation units
[STATUS] Computing links for 1 translation unit
[STATUS] Computing virtual overrides
[STATUS] Computing callgraph
[STATUS] Topologically sorting 1 function
[STATUS] Preparing for source code analysis
[STATUS] Running Sigma analysis
[STATUS] Computing node costs
[STATUS] Running analysis
[STATUS] Exporting summaries
Analysis summary report:
------------------------
Files analyzed                 : 1 Total
    C                          : 1
Total LoC input to cov-analyze : 6
Functions analyzed             : 1
Paths analyzed                 : 1
Time taken by analysis         : 00:00:09
Defect occurrences found       : 0

find cov-test-pragma -name deviations.txt | xargs cat
File,Line,Checker,Tool Message,Status,Comment,
/home/scampoy/repos/coverity-pragma/test-pragma.c,6,FORWARD_NULL,Dereferencing null pointer "fp".,Deviation,Intentional null deref,
$
```

The results are as expected

## Case 3: _Pragma() instead of #pragma
This case replaces the `#pragma coverity deviate` directive with its `_Pragma()` equivalent in the source code of the previous case.

```c
$ make case-3
cat test-_Pragma.c
int main()
{
    int *fp = 0;

    _Pragma("coverity compliance deviate \"FORWARD_NULL\" \"Intentional null deref\"")
    return *fp;
}
cov-build --dir cov-test-_Pragma gcc -c test-_Pragma.c -o test-_Pragma.o
Coverity Build Capture (64-bit) version 2023.9.0 on Linux 6.2.0-35-generic x86_64
Internal version numbers: 801eb59666 p-2023.9-push-59


Emitted 1 C/C++ compilation units (100%) successfully

1 C/C++ compilation units (100%) are ready for analysis
The cov-build utility completed successfully.
cov-analyze --dir cov-test-_Pragma -V 0 --ignore-deviated-findings
Coverity Static Analysis version 2023.9.0 on Linux 6.2.0-35-generic x86_64
Internal version numbers: 801eb59666 p-2023.9-push-59

Looking for translation units
[STATUS] Computing links for 1 translation unit
[STATUS] Computing virtual overrides
[STATUS] Computing callgraph
[STATUS] Topologically sorting 1 function
[STATUS] Preparing for source code analysis
[STATUS] Running Sigma analysis
[STATUS] Computing node costs
[STATUS] Running analysis
[STATUS] Exporting summaries
Analysis summary report:
------------------------
Files analyzed                 : 1 Total
    C                          : 1
Total LoC input to cov-analyze : 6
Functions analyzed             : 1
Paths analyzed                 : 1
Time taken by analysis         : 00:00:08
Defect occurrences found       : 0

find cov-test-_Pragma -name deviations.txt | xargs cat
File,Line,Checker,Tool Message,Status,Comment,
/home/scampoy/repos/coverity-pragma/test-_Pragma.c,6,FORWARD_NULL,Dereferencing null pointer "fp".,Deviation,Intentional null deref,
$
```

The results look the same as Case 2, as expected.

## Case 4: wrapping _Pragma() in a macro hides defect
The whole point of this exercise was to get to a situation where we can use our own macros for annotating deviations. This case shows an example of what this could look like.

```c
$ make case-4
cat test-macro.c
#define STR(x) #x
#define STRINGIFY(x) STR(x)
#define CONCATENATE(X,Y,Z) X Y Z

#define RTI_COMPLIANCE_DEVIATE(checker_, reason_) \
    _Pragma(STRINGIFY(CONCATENATE(coverity compliance deviate, STRINGIFY(checker_), STRINGIFY(reason_))))

int main()
{
    int *fp = 0;

    RTI_COMPLIANCE_DEVIATE(FORWARD_NULL, Intentional null deref)
    return *fp;

}
cov-build --dir cov-test-macro gcc -c test-macro.c -o test-macro.o
Coverity Build Capture (64-bit) version 2023.9.0 on Linux 6.2.0-35-generic x86_64
Internal version numbers: 801eb59666 p-2023.9-push-59


Emitted 1 C/C++ compilation units (100%) successfully

1 C/C++ compilation units (100%) are ready for analysis
The cov-build utility completed successfully.
cov-analyze --dir cov-test-macro -V 0 --ignore-deviated-findings
Coverity Static Analysis version 2023.9.0 on Linux 6.2.0-35-generic x86_64
Internal version numbers: 801eb59666 p-2023.9-push-59

Looking for translation units
[STATUS] Computing links for 1 translation unit
[STATUS] Computing virtual overrides
[STATUS] Computing callgraph
[STATUS] Topologically sorting 1 function
[STATUS] Preparing for source code analysis
[STATUS] Running Sigma analysis
[STATUS] Computing node costs
[STATUS] Running analysis
[STATUS] Exporting summaries
Analysis summary report:
------------------------
Files analyzed                 : 1 Total
    C                          : 1
Total LoC input to cov-analyze : 11
Functions analyzed             : 1
Paths analyzed                 : 1
Time taken by analysis         : 00:00:07
Defect occurrences found       : 0

find cov-test-macro -name deviations.txt | xargs cat

$
```

In this case, the defect is not reported anywhere.

Note that a similar approach works with other pragmas. For this example we are using the `GCC diagnostic ignored` pragma to suppress the `-Wunused-variable` warning.

```c
$ make case-warning
cat test-warning.c
#define STR(x) #x
#define STRINGIFY(x) STR(x)
#define CONCATENATE(X,Y) X Y

#define RTI_IGNORE_WARNING(warning_) \
    _Pragma(STRINGIFY(CONCATENATE(GCC diagnostic ignored, STRINGIFY(warning_))))

int main() {
    RTI_IGNORE_WARNING(-Wunused-variable)
    int variable;
}
gcc -Wall -c test-warning.c -o test-warning.o

$
```

## Case 5: wrapping _Pragma() in a macro, second approach
Adding a parameter to the macro with the contents of the line that is affected by the pragma has the same effect as case 2 and 3.

```c
$ make case-5
cat test-macro-workaround.c
#define STR(x) #x
#define STRINGIFY(x) STR(x)
#define CONCATENATE(X,Y,Z) X Y Z

#define RTI_COMPLIANCE_DEVIATE(checker_, reason_, line_) \
    _Pragma(STRINGIFY(CONCATENATE(coverity compliance deviate, STRINGIFY(checker_), STRINGIFY(reason_)))) \
    line_

int main()
{
    int *fp = 0;

    RTI_COMPLIANCE_DEVIATE(FORWARD_NULL, Intentional null deref, return *fp;)
}
cov-build --dir cov-test-macro-workaround gcc -c test-macro-workaround.c -o test-macro-workaround.o
Coverity Build Capture (64-bit) version 2023.9.0 on Linux 6.2.0-35-generic x86_64
Internal version numbers: 801eb59666 p-2023.9-push-59


Emitted 1 C/C++ compilation units (100%) successfully

1 C/C++ compilation units (100%) are ready for analysis
The cov-build utility completed successfully.
cov-analyze --dir cov-test-macro-workaround -V 0 --ignore-deviated-findings
Coverity Static Analysis version 2023.9.0 on Linux 6.2.0-35-generic x86_64
Internal version numbers: 801eb59666 p-2023.9-push-59

Looking for translation units
[STATUS] Computing links for 1 translation unit
[STATUS] Computing virtual overrides
[STATUS] Computing callgraph
[STATUS] Topologically sorting 1 function
[STATUS] Preparing for source code analysis
[STATUS] Running Sigma analysis
[STATUS] Computing node costs
[STATUS] Running analysis
[STATUS] Exporting summaries
Analysis summary report:
------------------------
Files analyzed                 : 1 Total
    C                          : 1
Total LoC input to cov-analyze : 11
Functions analyzed             : 1
Paths analyzed                 : 1
Time taken by analysis         : 00:00:06
Defect occurrences found       : 0

find cov-test-macro-workaround -name deviations.txt | xargs cat
File,Line,Checker,Tool Message,Status,Comment,
/home/scampoy/repos/coverity-pragma/test-macro-workaround.c,13,FORWARD_NULL,Dereferencing null pointer "fp".,Deviation,Intentional null deref,
$
```