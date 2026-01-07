module lib.types.bstr;

import lib.types.bbool;
import lib.types.bint;

import lib.obj;
import lib.heap;

import core.stdc.stdlib;
import core.stdc.stdio;

extern (C) int strcmp(const char* s1, const char* s2);

extern (C) void strset(BObject* obj, char* val)
{
    *cast(char**) obj.ptr = val;
}

extern (C) char* strget(BObject* obj)
{
    return *cast(char**) obj.ptr;
}

extern (C) BObject* strfromraw(ref Heap heap, ubyte* data, size_t size)
{
    BObject* obj = heap.bobjectNew(BTypes.Str);
    obj.strset(cast(char*) data);
    return obj;
}

extern (C) BObject* strto(ref Heap heap, BObject* obj, BTypes type)
{
    switch (type)
    {
    case BTypes.Bool:
        BObject* boolobj = heap.bobjectNew(type);
        char* str = obj.strget();
        if (strcmp(str, "true") == 0)
            boolobj.boolset(true);
        else if (strcmp(str, "false") == 0)
        {
            boolobj.boolset(false);
        }
        return boolobj;

    case BTypes.Int:
        BObject* strobj = heap.bobjectNew(type);
        strobj.strset(cast(char*) "0");
        // if (obj.boolget())
        //     strobj.strset(cast(char*) "true");
        // else
        // {
        //     strobj.strset(cast(char*) "false");
        // }
        return strobj;

    default:
        return obj;
    }
}

// extern (C) BObject* stradd(ref Heap heap, BObject* a, BObject* b)
// {
//     BObject* obj = heap.bobjectNew(BTypes.Int);
//     obj.intset(a.strset() + b.strset());
//     return obj;
// }
