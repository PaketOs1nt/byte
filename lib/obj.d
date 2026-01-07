module lib.obj;

import lib.heap;
import lib.types.bint;

enum BTypes
{
    None,
    Int,
    Bool
}

struct BObject
{
    void* ptr;
    BTypes type;
}

extern (C) size_t btypesSize(BTypes type)
{
    final switch (type)
    {
    case BTypes.None:
        return 0;
    case BTypes.Int:
        return int.sizeof;
    case BTypes.Bool:
        return 1;
    }
}

extern (C) BObject* bobjectNew(ref Heap h, BTypes type)
{
    BObject* obj = cast(BObject*) h.heapAlloc(BObject.sizeof);
    obj.ptr = h.heapAlloc(btypesSize(type));
    obj.type = type;
    return obj;
}

extern (C) BObject* bobjectAdd(ref Heap heap, BObject* a, BObject* b)
{
    switch (a.type)
    {
    case BTypes.Int:
        return heap.intadd(a, b);
    default:
        return heap.bobjectNew(BTypes.None);
    }
}

enum UseOp
{
    ADD
}

extern (C) BObject* bobjectOp(ref Heap heap, BObject* a, BObject* b, UseOp op)
{
    final switch (op)
    {
    case op.ADD:
        return heap.bobjectAdd(a, b);
    }
}
