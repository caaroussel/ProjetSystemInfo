%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lex.tab.h"
%}

/* To not generate code that calls yywrap() at end of input */
%option noyywrap

/* To not generate code for yyinput */
%option noinput

/* To not generate code for unput */
%option nounput


/* yytext will be the matched text */
%%
[a-zA-Z][a-zA-Z0-9]* {
    /* Matching text that start with an alphabetic letter and controling each case*/
    if(strcmp(yytext, "if") == 0) {
        return tIF;
    } else if(strcmp(yytext, "else") == 0) {
        return tELSE;
    } else if(strcmp(yytext, "while") == 0) {
        return tWHILE;
    } else if(strcmp(yytext, "print") == 0) {
        return tPRINT;
    } else if(strcmp(yytext, "return") == 0) {
        return tRETURN;
    } else if(strcmp(yytext, "int") == 0) {
        return tINT;
    } else if(strcmp(yytext, "void") == 0) {
        return tVOID;
    } else if(strcmp(yytext, "main") == 0) {
        return tMAIN;
    } else if(strcmp(yytext, "const") == 0) {
        return tCONST;
    } else {
        yylval.s = strdup(yytext);
        return tID;
    }
}

0[xX][0-9a-fA-F]+ {
    /* Matching hexadecimal numbers starting with 0x or 0X */
    /* Converting the matched string to an integer with base 16 and print it */
    yylval.d = (int)strtol(yytext, NULL, 16);
    return tNB;
}

[0-9]+ {
    /* Matching decimal numbers */
    /* Converting the matched string to an integer with base 10 and print it in hexadecimal format */
    yylval.d = atoi(yytext);
    return tNB;
}

\/\/.* {
    /* Ignoring single line comments */
}

\/\*[^*]*\*+([^/*][^*]*\*+)*\/ {
    /* Ignoring multiple lines comments */
}

"+" {
    return tADD;
}

"-" {
    return tSUB;
}

"*" {
    return tMUL;
}

"/" {
    return tDIV;
}

"<" {
    return tLT;
}

">" {
    return tGT;
}

"!=" {
    return tNE;
}

"==" {
    return tEQ;
}

">=" {
    return tGE;
}

"<=" {
    return tLE;
}

"=" {
    return tASSIGN;
}

"&&" {
    return tAND;
}

"||" {
    return tOR;
}

"!" {
    return tNOT;
}


"{" {
    return tLBRACE;
}

"}" {
    return tRBRACE;
}

"(" {
    return tLPAR;
}

")" {
    return tRPAR;
}

";" {
    return tSEMI;
}

"," {
    return tCOMMA;
}

[ \t\n\r] {
    /* Ignoring whitespace */
}

. {
    /* Printing tERROR if we don't recognize the text*/
    return tERROR;
}

%%

//     /* Printing how to use in case of errors */ int main(int argc, char **argv) {

//     if(argc != 2) {
//         printf("Usage: %s filename\n", argv[0]);
//         exit(1);
//     }

//     /* Letting the user know if we can read the file*/
//     FILE *file = fopen(argv[1], "r");
//     if(file == NULL) {
//         printf("Unable to open file\n");
//         exit(1);
//     }

//     /* Associating yyin to the file pointer */
//     yyin = file;

//     /* Running the rules section */
//     yylex();

//     /* Closing the file */
//     fclose(file);
//     return 0;
// }
