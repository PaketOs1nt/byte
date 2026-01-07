module lib.types.bbool;

import lib.types.bstr;
import lib.types.bint;

import lib.obj;
import lib.heap;

import core.stdc.stdlib;
import core.stdc.stdio;

extern (C) void boolset(BObject* obj, bool val)
{
    *cast(bool*) obj.ptr = val;
}

extern (C) int boolget(BObject* obj)
{
    return *cast(bool*) obj.ptr;
}

extern (C) BObject* boolfromraw(ref Heap heap, ubyte* data, size_t size)
{
    BObject* obj = heap.bobjectNew(BTypes.Bool);
    obj.boolset(cast(bool) data[0]);
    return obj;
}

extern (C) BObject* boolto(ref Heap heap, BObject* obj, BTypes type)
{
    switch (type)
    {
    case BTypes.Int:
        BObject* intobj = heap.bobjectNew(type);
        intobj.intset(cast(int) obj.boolget());
        return intobj;

    case BTypes.Str:
        BObject* strobj = heap.bobjectNew(type);
        if (obj.boolget())
            strobj.strset(cast(char*) "true");
        else
        {
            strobj.strset(cast(char*) "false");
        }
        return strobj;

    default:
        return obj;
    }
}
