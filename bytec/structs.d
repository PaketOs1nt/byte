module bytec.structs;

import std.string : toLower;

enum Op
{
    NOP,
    POS_ADD,
    POS_SUB,
    POP_TOP,
    FLAG,
    PUSH_OBJ,
    PUSH_CONST,
    USE_OP,
    TO
}

enum BTypes
{
    None,
    Int,
    Bool,
    Str
}

enum UseOp
{
    ADD
}

BTypes type_from_str(string str)
{
    switch (str)
    {
    case "int":
        return BTypes.Int;

    case "bool":
        return BTypes.Bool;

    case "str":
        return BTypes.Str;

    default:
        return BTypes.None;
    }
}

Op op_from_str(string str)
{
    switch (str.toLower())
    {
    case "flag":
        return Op.FLAG;
    case "to":
        return Op.TO;
    case "pop_top":
        return Op.POP_TOP;
    case "push_obj":
        return Op.PUSH_OBJ;
    case "push_const":
        return Op.PUSH_CONST;
    case "use_op":
        return Op.USE_OP;
    case "pos_add":
        return Op.POS_ADD;
    case "pos_sub":
        return Op.POS_SUB;
    case "nop":
        return Op.NOP;
    default:
        return Op.NOP;
    }
}
