import core.stdc.stdlib;
import core.stdc.stdio;

@nogc
extern (C) struct Memory
{
    ubyte* mem;
    size_t size;
    size_t used;
}

extern (C) enum BTypes
{
    Int = int.sizeof
}

@nogc
extern (C) struct BObject
{
    void* ptr;
    BTypes type;
}

@nogc
extern (C) Memory heapInit(size_t size)
{
    Memory heap = Memory();
    heap.mem = cast(ubyte*) calloc(1, size);
    heap.size = size;
    heap.used = 0;
    return heap;
}

@nogc
extern (C) void* heapAlloc(ref Memory h, size_t size)
{
    if (h.used + size > h.size)
        return null;

    auto ptr = h.mem + h.used;
    h.used += size;
    return ptr;
}

@nogc
extern (C) void heapDestroy(ref Memory h)
{
    if (h.mem !is null)
        free(cast(void*) h.mem);
}

@nogc
extern (C) BObject* bobjectNew(ref Memory h, BTypes type)
{
    BObject* obj = cast(BObject*) h.heapAlloc(BObject.sizeof);
    obj.ptr = h.heapAlloc(type.sizeof);
    obj.type = type;
    return obj;
}

extern (C) int main() @nogc
{
    Memory mem = heapInit(1024 * 1024);

    BObject* testobj = mem.bobjectNew(BTypes.Int);
    *cast(int*) testobj.ptr = 123;

    printf("%i", *cast(int*) testobj.ptr);

    mem.heapDestroy();
    return 0;
}
