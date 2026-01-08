module bytec.basm;

import bytec.ast;
import bytec.packer;
import bytec.structs;
import bytec.tokens;

import core.stdc.stdlib;

import std;

extern (C) void* memcpy(void* dest, const void* src, size_t n);

enum Section
{
    CONSTS,
    CODE,
    EMPTY
}

enum AsmContext
{
    EMPTY,
    NEXT_SECTION,
    AFTER_SECTION,
    CONST_TYPE,
    CONST_DATA,
    CODE_OP,
    CODE_ARG
}

struct Instr
{
    Op op;
    ubyte arg;

    ubyte[] compile()
    {
        return [cast(ubyte) op, arg];
    }
}

struct Const
{
    BTypes type;
    ubyte[] raw;
}

ubyte[] int_to_bytes(int val)
{
    ubyte* buff = cast(ubyte*) malloc(int.sizeof);
    memcpy(buff, &val, int.sizeof);
    return buff[0 .. int.sizeof];
}

Packed compile_asm(string code)
{
    Packed packed = Packed();
    Token[] tokens = tokenize(code);
    Section section = Section.EMPTY;
    AsmContext ctx = AsmContext.EMPTY;

    bool iscomm = false;
    Instr instr = Instr();
    Const bconst = Const();

    foreach (Token t; tokens)
    {
        if (t.type == TokenType.NEW_LINE)
        {
            iscomm = false;
            if (instr != Instr())
            {
                //writeln("packed instr ", instr);
                packed.pack_code(instr.compile());
                instr = Instr();
            }
            if (bconst != Const())
            {
                //writeln("packed const ", bconst);
                packed.pack_const(bconst.type, bconst.raw);
                bconst = Const();
            }
        }
        if (t.type == TokenType.OTHER && t.str == "#")
        {
            iscomm = true;
        }
        if (iscomm)
            continue;

        else if (t.type == TokenType.DDOT)
        {
            if (ctx == ctx.AFTER_SECTION)
            {
                if (section == Section.CODE)
                    ctx = ctx.CODE_OP;
                else if (section == Section.CONSTS)
                    ctx = ctx.CONST_TYPE;
            }

        }
        else if (t.type == TokenType.DOT)
        {
            ctx = ctx.NEXT_SECTION;
        }
        else if (t.type == TokenType.NAME)
        {
            if (ctx == ctx.NEXT_SECTION)
            {
                //writeln("into section ", t.str);
                if (t.str == "code")
                    section = Section.CODE;

                if (t.str == "consts")
                    section = Section.CONSTS;

                ctx = ctx.AFTER_SECTION;
                continue;
            }
            if (section == Section.CODE)
            {
                if (ctx == ctx.CODE_OP)
                {
                    instr.op = op_from_str(t.str);
                    ctx = ctx.CODE_ARG;
                }
                else if (ctx == ctx.CODE_ARG)
                {
                    instr.arg = cast(ubyte) type_from_str(t.str);
                    ctx = ctx.CODE_OP;
                }
            }
            else if (section == Section.CONSTS)
            {
                if (ctx == ctx.CONST_TYPE)
                {
                    bconst.type = type_from_str(t.str);
                    ctx = ctx.CONST_DATA;
                }
                else if (ctx == ctx.CONST_DATA)
                {
                    bconst.raw = [cast(ubyte) to!bool(t.str)];
                    ctx = ctx.CONST_TYPE;
                }
            }

        }
        else if (t.type == TokenType.INT)
        {
            if (section == Section.CODE && ctx == ctx.CODE_ARG)
            {
                //writeln("int instr arg ", to!int(t.str));
                instr.arg = cast(ubyte) to!int(t.str);
                ctx = ctx.CODE_OP;
            }
            else if (section == Section.CONSTS && ctx == ctx.CONST_DATA)
            {
                bconst.raw = int_to_bytes(to!int(t.str));
                ctx = ctx.CONST_TYPE;
            }
        }

    }

    return packed;
}
