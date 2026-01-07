import core.stdc.stdlib;
import core.stdc.stdio;

pragma(lib, "byte.lib");

import header;

extern (C) int main(int argc, char** argv)
{
    if (argc > 0)
    {
        char* path = argv[argc - 1];

        Executor executor = executorInit(1024 * 1024, 64);
        Code code = executor.heap.codeImport(path);
        executor.executorRun(code);
    }
    return 0;
}
