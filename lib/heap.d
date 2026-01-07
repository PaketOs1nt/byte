module lib.heap;
import core.stdc.stdlib;

struct Heap
{
    ubyte* mem;
    size_t size;
    size_t used;
}

extern (C) Heap heapInit(size_t size)
{
    Heap heap = Heap();
    heap.mem = cast(ubyte*) calloc(1, size);
    heap.size = size;
    heap.used = 0;
    return heap;
}

extern (C) void* heapAlloc(ref Heap h, size_t size)
{
    if (h.used + size > h.size)
        return null;

    auto ptr = h.mem + h.used;
    h.used += size;
    return ptr;
}

extern (C) void heapDestroy(ref Heap h)
{
    if (h.mem !is null)
        free(cast(void*) h.mem);
}
