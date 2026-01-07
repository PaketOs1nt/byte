module lib.types.bint;

import lib.obj;
import lib.heap;

extern (C) void intset(BObject* obj, int num)
{
    *cast(int*) obj.ptr = num;
}

extern (C) int intget(BObject* obj)
{
    return *cast(int*) obj.ptr;
}

extern (C) BObject* intadd(ref Heap heap, BObject* a, BObject* b)
{
    BObject* obj = heap.bobjectNew(BTypes.Int);
    obj.intset(a.intget() + b.intget());
    return obj;
}
