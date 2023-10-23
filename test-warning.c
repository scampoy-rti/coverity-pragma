#define STR(x) #x
#define STRINGIFY(x) STR(x)
#define CONCATENATE(X,Y) X Y

#define RTI_IGNORE_WARNING(warning_) \
    _Pragma(STRINGIFY(CONCATENATE(GCC diagnostic ignored, STRINGIFY(warning_))))

int main() {
    RTI_IGNORE_WARNING(-Wunused-variable)
    int variable;
}
