module bytec.packer;

import std;
import bytec.structs;

struct Packed
{
    size_t consts_len = 0;
    ubyte[] consts_bin = [];

    ubyte[] code_bin = [];

    void pack_size_t(ref ubyte[] result, size_t v)
    {
        foreach (i; 0 .. size_t.sizeof)
        {
            result ~= cast(ubyte)((v >> (i * 8)) & 0xFF);
        }
    }

    void pack_const(BTypes type, ubyte[] data)
    {
        consts_len++;
        consts_bin ~= cast(ubyte) type;
        consts_bin.pack_size_t(data.length);
        consts_bin ~= data;
    }

    void pack_code(ubyte[] bytecode)
    {
        code_bin = bytecode;
    }

    ubyte[] compile()
    {
        ubyte[] bin = [];
        bin ~= cast(ubyte) consts_len;
        bin ~= consts_bin;
        bin ~= code_bin;
        return bin;
    }
}
