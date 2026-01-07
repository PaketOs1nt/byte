module lib.types.bint;
import lib.obj;

extern (C) void intset(BObject* obj, int num)
{
    *cast(int*) obj.ptr = num;
}

extern (C) int intget(BObject* obj)
{
    return *cast(int*) obj.ptr;
}
