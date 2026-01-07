module lib.types.bint;

import lib.types.bstr;
import lib.types.bbool;

import lib.obj;
import lib.heap;

import core.stdc.stdlib;
import core.stdc.stdio;

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

extern (C) BObject* intfromraw(ref Heap heap, ubyte* data, size_t size)
{
    BObject* obj = heap.bobjectNew(BTypes.Int);
    obj.intset(cast(int)*data);
    return obj;
}

extern (C) BObject* intto(ref Heap heap, BObject* obj, BTypes type)
{
    switch (type)
    {
    case BTypes.Bool:
        BObject* boolobj = heap.bobjectNew(type);
        boolobj.boolset(cast(bool) obj.intget());
        return boolobj;

        // case BTypes.Str:
        //     BObject* strobj = heap.bobjectNew(type);
        //     if (obj.boolget())
        //         strobj.strset("true");
        //     else
        //     {
        //         strobj.strset("false");
        //     }
        //     return strobj;

    default:
        return obj;
    }
}
