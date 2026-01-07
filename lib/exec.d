module lib.exec;

import lib.obj;
import lib.heap;

import core.stdc.stdlib;

struct Stack
{
    size_t pos;
    size_t size;
    BObject* mem;
}

extern (C) Stack stackInit(size_t size, ref Heap heap)
{
    Stack stack = Stack();
    stack.pos = 0;
    stack.size = size;
    stack.mem = cast(BObject*) heap.heapAlloc(BObject.sizeof * size);
    return stack;
}

extern (C) void stackPush(ref Stack stack, BObject obj)
{
    stack.mem[stack.pos] = obj;
    stack.pos++;
}

extern (C) void stackPop(ref Stack stack)
{
    BObject obj = stack.mem[stack.pos];
    stack.pos--;
    return obj;
}

enum Op
{
    NOP
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
    executor.stack = stackInit(stackSize);
    executor.pos = 0;

    return executor;
}

extern (C) void executorRun(ref Executor executor, ubyte* bytecode, size_t size)
{
    while (executor.pos + 1 < size)
    {
        Op op = cast(Op) bytecode[executor.pos];
        ubyte arg = bytecode[executor.pos] + 1;

        final switch (op)
        {
        case Op.NOP:
        }

        executor.pos += 2;
    }
}
