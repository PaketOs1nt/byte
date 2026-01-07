import std;

enum TokenType
{
    COSMETIC,
    NEXT_INSTR
}

struct Token
{
    string str;
    TokenType type;
}
