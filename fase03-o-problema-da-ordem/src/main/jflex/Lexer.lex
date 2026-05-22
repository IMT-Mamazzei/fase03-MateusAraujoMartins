package br.maua.cic303;

import java_cup.runtime.Symbol;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* ========================================================================= */
/* MACROS                                                                    */
/* ========================================================================= */

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

Letter = [a-zA-Z]
Digit  = [0-9]

Number = {Digit}+(\.{Digit}+)?([Ee][+-]?{Digit}+)?

Identifier = {Letter}({Letter}|{Digit}|_){0,31}

/* Identificador com mais de 32 chars */
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32,}

%%

<YYINITIAL> {

    /* Espaços */
    {WhiteSpace} { }

    /* ========================================================================= */
    /* PALAVRAS RESERVADAS                                                       */
    /* ========================================================================= */

    "if"        { return symbol(sym.IF); }
    "then"      { return symbol(sym.THEN); }
    "else"      { return symbol(sym.ELSE); }
    "while"     { return symbol(sym.WHILE); }

    /* ========================================================================= */
    /* PONTUAÇÃO                                                                 */
    /* ========================================================================= */

    "("         { return symbol(sym.LPAREN); }
    ")"         { return symbol(sym.RPAREN); }

    "{"         { return symbol(sym.LBRACE); }
    "}"         { return symbol(sym.RBRACE); }

    ";"         { return symbol(sym.SEMI); }

    /* ========================================================================= */
    /* OPERADORES RELACIONAIS                                                    */
    /* ========================================================================= */

    "=="        { return symbol(sym.REL_OP, yytext()); }
    "!="        { return symbol(sym.REL_OP, yytext()); }
    "<="        { return symbol(sym.REL_OP, yytext()); }
    ">="        { return symbol(sym.REL_OP, yytext()); }
    "<"         { return symbol(sym.REL_OP, yytext()); }
    ">"         { return symbol(sym.REL_OP, yytext()); }

    /* ========================================================================= */
    /* ATRIBUIÇÃO                                                                */
    /* ========================================================================= */

    "="         { return symbol(sym.ASSIGN); }

    /* ========================================================================= */
    /* OPERADORES MATEMÁTICOS                                                    */
    /* ========================================================================= */

    "+"|"-"     { return symbol(sym.ADD_OP, yytext()); }

    "*"|"/"|"%" { return symbol(sym.MUL_OP, yytext()); }

    /* ========================================================================= */
    /* IDENTIFICADORES E NÚMEROS                                                 */
    /* ========================================================================= */

    {OversizedIdentifier}
    {
        throw new RuntimeException(
            "Erro Léxico: Identificador gigante -> " + yytext()
        );
    }

    {Identifier}
    {
        return symbol(sym.ID, yytext());
    }

    {Number}
    {
        return symbol(sym.NUMBER, yytext());
    }

    /* ========================================================================= */
    /* ERRO                                                                      */
    /* ========================================================================= */

    .
    {
        throw new RuntimeException(
            "Erro Léxico: Caractere Ilegal -> " + yytext()
        );
    }
}

/* EOF */
<<EOF>> { return null; }