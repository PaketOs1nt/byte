module lib.heap;

import lib.obj;
import core.stdc.stdlib;
import core.stdc.stdio;

struct Heap
{
    ubyte* mem;
    size_t size;
    size_t used;
    BObject* none;
}

extern (C) Heap heapInit(size_t size)
{
    Heap heap = Heap();
    heap.mem = cast(ubyte*) calloc(1, size);
    heap.size = size;
    heap.used = 0;

    heap.none = cast(BObject*) heap.heapAlloc(BObject.sizeof);
    heap.none.ptr = heap.heapAlloc(1);
    heap.none.type = BTypes.None;

    return heap;
}

extern (C) void* heapAlloc(ref Heap h, size_t size)
{
    if (h.used + size > h.size)
    {
        printf("[heap] no more memory :(");
        return null;
    }

    auto ptr = h.mem + h.used;
    h.used += size;
    return ptr;
}

extern (C) void heapDestroy(ref Heap h)
{
    if (h.mem !is null)
        free(cast(void*) h.mem);
}
