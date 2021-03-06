
#include <ccxx/ccxx.h>

using namespace std;

int f_argc = 0;
const char * * f_argv = NULL;

int main(int argc,const char * argv[])
{
    f_argc = argc;
    f_argv = argv;

    cout << "begin test encoding : " << endl;

    CxApplication::init(argc, argv);

    string src = "��ã�";

    string dest = CxEncoding::gb2312ToUtf8(src);

    cout << "gbk : " << src << endl;

    cout << "utf : " << dest << endl;

    FILE * pFile;
    pFile = fopen ("c:/1.txt", "wb");
    if (pFile==NULL) return false;
    rewind (pFile);
    size_t iWrote = fwrite (dest.data() , 1, dest.size(), pFile);
    fclose (pFile);

    cout << "end test encoding !!!" << endl;

    return CxApplication::exec();
}
