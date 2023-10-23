int main()
{
    int *fp = 0;

    _Pragma("coverity compliance deviate \"FORWARD_NULL\" \"Intentional null deref\"")
    return *fp;
}
