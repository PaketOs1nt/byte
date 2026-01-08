module lib.types.bint;

import lib.types.bstr;
import lib.types.bbool;

import lib.obj;
import lib.heap;

import core.stdc.stdlib;
import core.stdc.stdio;

extern (C) void* memcpy(void* dest, const void* src, size_t n);

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
    int value;
    memcpy(&value, data, int.sizeof);
    obj.intset(value);
    //printf("loaded int %i\n", obj.intget());
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

    case BTypes.Str:
        BObject* strobj = heap.bobjectNew(type);
        char* buff = cast(char*) heap.heapAlloc(12); // -maxint + \0
        sprintf(buff, "%d", obj.intget());
        strobj.strset(buff);
        return strobj;

    default:
        return obj;
    }
}
