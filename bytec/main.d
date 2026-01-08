import std.file;
import std.stdio;
import std.string;
import std.conv;
import std.array;

import bytec.ast;
import bytec.basm;
import bytec.packer;
import bytec.structs;
import bytec.tokens;

const CODE = `
.code:
push_const 0
push_const 1
use_op 0
to str
flag 255

.consts:
int 1
int 2`;

void main(string[] args)
{
    if (args.length > 1)
    {
        string path = args[cast(size_t) args.length - 1];
        string code = to!string(std.file.read(path));
        Packed packed = compile_asm(code);

        string[] splitted = path.split(".");
        splitted[cast(size_t) splitted.length - 1] = "byte";
        string output = std.array.join(splitted, ".");

        std.file.write(output, packed.compile());
        writeln("[bytec] saved as ", output);
    }
}
