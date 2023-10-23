int main()
{
    int *fp = 0;

    #pragma coverity compliance deviate "FORWARD_NULL" "Intentional null deref"
    return *fp;
}
