module lib.types.bbool;
import lib.obj;

extern (C) void boolset(BObject* obj, bool val)
{
    *cast(bool*) obj.ptr = val;
}

extern (C) int boolget(BObject* obj)
{
    return *cast(bool*) obj.ptr;
}
