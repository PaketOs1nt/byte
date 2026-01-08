module bytec.tokens;

import std.ascii : isAlpha, isDigit;
import std.conv;

enum TokenType
{
    COSMETIC,
    NEXT_INSTR,
    NEW_LINE,
    COMMA,
    NAME,
    DOT,
    DDOT,
    OTHER,
    INT,
    STR
}

enum TokenContext
{
    STR,
    INT,
    NAME,
    EMPTY
}

struct Token
{
    string str;
    TokenType type;
}

Token[] tokenize(string code)
{
    Token[] result = [];
    Token buff;
    TokenContext ctx = TokenContext.EMPTY;

    void flush()
    {
        if (buff.str.length)
        {
            result ~= buff;
            buff = Token();
            ctx = TokenContext.EMPTY;
        }
    }

    foreach (char c; code)
    {
        if (c == '\n')
        {
            flush();
            result ~= Token("\n", TokenType.NEW_LINE);
            continue;
        }

        if (c == ' ' || c == '\t')
        {
            flush();
            continue;
        }

        if (c == '.')
        {
            flush();
            result ~= Token(".", TokenType.DOT);
            continue;
        }

        if (c == ':')
        {
            flush();
            result ~= Token(":", TokenType.DDOT);
            continue;
        }

        if (isDigit(c))
        {
            if (ctx == TokenContext.EMPTY)
            {
                ctx = TokenContext.INT;
                buff.type = TokenType.INT;
            }
            buff.str ~= c;
            continue;
        }

        if (isAlpha(c) || c == '_')
        {
            if (ctx == TokenContext.EMPTY)
            {
                ctx = TokenContext.NAME;
                buff.type = TokenType.NAME;
            }
            buff.str ~= c;
            continue;
        }

        flush();
        result ~= Token(c.to!string, TokenType.OTHER);
    }
    flush();

    return result ~ Token("\n", TokenType.NEW_LINE);
}
