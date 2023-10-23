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
