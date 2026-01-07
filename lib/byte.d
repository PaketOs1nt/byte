import lib.heap;
import lib.obj;
import lib.exec;
import lib.types.bint;

import core.stdc.stdio;

extern (C) void test()
{
    ubyte[16] program = [
        Op.PUSH_OBJ, BTypes.Int,
        Op.PUSH_OBJ, BTypes.Bool,
        Op.PUSH_OBJ, BTypes.None,
        Op.POP_TOP, 0,
        Op.POP_TOP, 0,
        Op.PUSH_OBJ, BTypes.Int,
        Op.USE_OP, UseOp.ADD,
        Op.FLAG, 255
    ];
    Code code = Code(program.ptr, program.length);

    Executor executor = executorInit(1024 * 1024, 64);
    executor.executorRun(code);
}
