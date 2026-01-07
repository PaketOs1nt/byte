module lib.exec;

import lib.obj;
import lib.heap;

import core.stdc.stdlib;
import core.stdc.stdio;

struct Stack
{
    size_t pos;
    size_t size;
    BObject** mem;
}

extern (C) Stack stackInit(size_t size, ref Heap heap)
{
    Stack stack = Stack();
    stack.pos = 0;
    stack.size = size;
    stack.mem = cast(BObject**) heap.heapAlloc(size_t.sizeof * size);
    return stack;
}

extern (C) void stackPush(ref Stack stack, BObject* obj)
{
    stack.mem[stack.pos++] = obj;
}

extern (C) BObject* stackPop(ref Stack stack)
{
    BObject* obj = stack.mem[--stack.pos];
    return obj;
}

enum Op
{
    NOP,
    POS_ADD,
    POS_SUB,
    POP_TOP,
    FLAG,
    PUSH_OBJ,
    USE_OP
}

struct Code
{
    ubyte* bytecode;
    size_t size;
}

struct Executor
{
    Heap heap;
    Stack stack;
    size_t pos;
}

extern (C) Executor executorInit(size_t heapSize, size_t stackSize)
{
    Executor executor = Executor();
    executor.heap = heapInit(heapSize);
    executor.stack = stackInit(stackSize, executor.heap);
    executor.pos = 0;

    return executor;
}

extern (C) void executorRun(ref Executor executor, Code code)
{
    while (executor.pos + 1 < code.size)
    {
        Op op = cast(Op) code.bytecode[executor.pos];
        ubyte arg = code.bytecode[executor.pos + 1];
        final switch (op)
        {
        case Op.NOP:
            break;

        case Op.POS_ADD:
            executor.pos += arg * 2;
            goto skip;

        case Op.POS_SUB:
            executor.pos -= arg * 2;
            goto skip;

        case Op.POP_TOP:
            executor.stack.stackPop();
            break;

        case Op.FLAG:
            printf("pos: %u, arg: %u\n", cast(uint) executor.pos, cast(uint) arg);
            if (arg == 255)
                while (executor.stack.pos > 0)
                {
                    BObject* obj = executor.stack.stackPop();
                    printf("| type: %i\t0x%p\t |\n", obj.type, obj.ptr);
                }
            break;

        case Op.PUSH_OBJ:
            executor.stack.stackPush(executor.heap.bobjectNew(cast(BTypes) arg));
            break;

        case Op.USE_OP:
            BObject* b = executor.stack.stackPop();
            BObject* a = executor.stack.stackPop();
            executor.stack.stackPush(executor.heap.bobjectOp(a, b, cast(UseOp) arg));
            break;
        }

        executor.pos += 2;
    skip:
    }
}
