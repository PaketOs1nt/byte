module lib.obj;

import lib.heap;
import lib.types.bint;
import lib.types.bbool;
import lib.types.bstr;

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

extern (C) size_t btypesSize(BTypes type, ubyte* data)
{
    final switch (type)
    {
    case BTypes.None:
        return 1;

    case BTypes.Int:
        return int.sizeof;

    case BTypes.Str:
        return size_t.sizeof;

    case BTypes.Bool:
        return 1;

    }
}

extern (C) BObject* bobjectNew(ref Heap h, BTypes type)
{
    if (type == BTypes.None)
        return h.none;

    BObject* obj = cast(BObject*) h.heapAlloc(BObject.sizeof);
    obj.ptr = h.heapAlloc(btypesSize(type, cast(ubyte*) h.none.ptr));
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

extern (C) BObject* bobjectTo(ref Heap heap, BObject* obj, BTypes type)
{
    final switch (obj.type)
    {
    case BTypes.Bool:
        return heap.boolto(obj, type);

    case BTypes.Int:
        return heap.intto(obj, type);

    case BTypes.Str:
        return heap.strto(obj, type);

    case BTypes.None:
        return heap.bobjectNew(type);
    }
}

extern (C) BObject* bobjectFromRaw(ref Heap heap, ubyte* data, size_t size, BTypes type)
{
    final switch (type)
    {
    case BTypes.Bool:
        return heap.boolfromraw(data, size);

    case BTypes.Int:
        return heap.intfromraw(data, size);

    case BTypes.Str:
        return heap.strfromraw(data, size);

    case BTypes.None:
        return heap.bobjectNew(type);
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
