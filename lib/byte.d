import lib.heap;
import lib.obj;
import lib.exec;
import lib.types.bint;

import core.stdc.stdio;

extern (C) void test()
{
    Executor executor = executorInit(1024 * 1024, 64);
}
