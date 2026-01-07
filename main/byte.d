import core.stdc.stdlib;
import core.stdc.stdio;

pragma(lib, "byte.lib");
extern (C) void test();

extern (C) int main()
{
    test();
    return 0;
}
