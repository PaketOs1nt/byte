module lib.obj;
import lib.heap;

enum BTypes
{
    Int
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
    case BTypes.Int:
        return int.sizeof;
    }
}

extern (C) BObject* bobjectNew(ref Heap h, BTypes type)
{
    BObject* obj = cast(BObject*) h.heapAlloc(BObject.sizeof);
    obj.ptr = h.heapAlloc(btypesSize(type));
    obj.type = type;
    return obj;
}
