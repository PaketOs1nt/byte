module bytec.structs;

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
