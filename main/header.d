module header;
extern (C) void test();

enum BTypes
{
    None,
    Int,
    Bool,
    Str
}

struct BObject
{
    void* ptr;
    BTypes type;
}

struct Heap
{
    ubyte* mem;
    size_t size;
    size_t used;
    BObject* none;
}

struct Stack
{
    size_t pos;
    size_t size;
    BObject** mem;
}

struct Executor
{
    Heap heap;
    Stack stack;
    size_t pos;
}

struct Code
{
    ubyte* bytecode;
    size_t size;
    BObject** consts;
    size_t consts_len;
}

extern (C) Executor executorInit(size_t heapSize, size_t stackSize);
extern (C) Code codeImport(ref Heap heap, char* path);
extern (C) void executorRun(ref Executor executor, Code code);
