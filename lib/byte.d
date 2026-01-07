import lib.heap;
import lib.obj;
import lib.exec;

import lib.types.bint;
import lib.types.bbool;
import lib.types.bstr;

import core.stdc.stdio;

extern (C) void test()
{
    Executor executor = executorInit(1024 * 1024, 64);

    // ubyte[6] program = [
    //     Op.PUSH_CONST, 0,
    //     Op.TO, BTypes.Str,
    //     Op.FLAG, 255
    // ];
    // BObject** consts = cast(BObject**) executor.heap.heapAlloc(size_t.sizeof);
    // consts[0] = executor.heap.bobjectNew(BTypes.Bool);
    // consts[0].boolset(true);

    // Code code = Code(program.ptr, program.length, consts, 1);
    Code code = executor.heap.codeImport(cast(char*) "test.byte");
    printf("loaded code, consts-len: %i, bytecode: ", cast(int) code.consts_len);
    foreach (size_t i; 0 .. code.size)
    {
        printf("%02x ", code.bytecode[i]);
    }
    printf("\n");

    executor.executorRun(code);
}
