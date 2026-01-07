module lib.exec;

import lib.obj;
import lib.heap;

import lib.types.bbool;
import lib.types.bint;
import lib.types.bstr;

import core.stdc.stdlib;
import core.stdc.stdio;

extern (C) void* memcpy(void* dest, const void* src, size_t n);

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
    PUSH_CONST,
    USE_OP,
    TO
}

struct Code
{
    ubyte* bytecode;
    size_t size;
    BObject** consts;
    size_t consts_len;
}

extern (C) Code codeImport(ref Heap heap, char* path)
{
    FILE* f = fopen(path, "rb");
    if (!f)
        return Code();

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    ubyte* buffer = cast(ubyte*) malloc(size);
    if (!buffer)
    {
        fclose(f);
        return Code();
    }

    fread(buffer, 1, size, f);
    fclose(f);

    size_t ptr = 0;

    Code code = Code();
    code.consts_len = buffer[ptr++];
    code.consts = cast(BObject**) heap.heapAlloc(code.consts_len * size_t.sizeof);

    size_t scanned_consts = 0;

    while (scanned_consts < code.consts_len)
    {
        BTypes type = cast(BTypes) buffer[ptr++];

        size_t const_size;
        memcpy(&const_size, buffer + ptr, size_t.sizeof);
        ptr += size_t.sizeof;

        BObject* obj = heap.bobjectFromRaw(buffer + ptr, const_size, type);

        code.consts[scanned_consts] = obj;
        scanned_consts++;
    }
    ptr++;
    code.size = size - ptr;
    code.bytecode = buffer + ptr;

    return code;
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
                    BObject* objstr = executor.heap.bobjectTo(obj, BTypes.Str);
                    printf("| type: %i\t0x%p\t |\n", objstr.type, objstr.ptr);
                    printf("str: %s", objstr.strget());

                }
            break;

        case Op.PUSH_OBJ:
            executor.stack.stackPush(executor.heap.bobjectNew(cast(BTypes) arg));
            break;

        case Op.PUSH_CONST:
            executor.stack.stackPush(code.consts[arg]);
            break;

        case Op.USE_OP:
            BObject* b = executor.stack.stackPop();
            BObject* a = executor.stack.stackPop();
            executor.stack.stackPush(executor.heap.bobjectOp(a, b, cast(UseOp) arg));
            break;

        case Op.TO:
            executor.stack.stackPush(executor.heap.bobjectTo(
                    executor.stack.stackPop(),
                    cast(BTypes) arg
            ));
            break;
        }

        executor.pos += 2;
    skip:
    }
}
