%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ti.h"
#include "ts.h"
#include "tn.h"
#include "tf.h"
%}

%code provides {
  int yylex (void);
  void yyerror (const char *);
  extern FILE * yyin;
  extern int prof;
}

%union { 
    char *s;
    int d;
}

/* Define tokens */
/* Token definitions */
%token <s> tID 
%token <d> tNB
%token tIF tELSE tWHILE tPRINT tRETURN tINT tVOID
%token tADD tSUB tMUL tDIV tLT tGT tNE tEQ tGE tLE tASSIGN tMAIN tAND tOR tNOT
%token tLBRACE tRBRACE tLPAR tRPAR tSEMI tCOMMA tERROR tCONST

%type <s> Var

/* Operator precedence */
%left tOR
%left tAND
%left tEQ tNE
%left tLT tLE tGT tGE
%left tADD tSUB
%left tMUL tDIV

%nonassoc tTHEN
%nonassoc tELSE

%%

Program: Declaration_list
        ;

Declaration_list: Declaration_list Declaration
                | Declaration
                ;

Declaration: Var_declaration
           | Fun_declaration
           ;

Var_declaration: Var_declaration_mi tSEMI
                ;

Var_declaration_mi:  tINT tID {}
                | Var_declaration_mi tCOMMA tID {}
                | tINT tID tASSIGN Expression {}
                | tCONST tINT tID tASSIGN Expression {}
                | Var_declaration_mi tCOMMA tID tASSIGN Expression {}
                ;


Fun_declaration: tVOID tMAIN tLPAR Params tRPAR Compound_stmt {}
                | tVOID tID tLPAR Params tRPAR Compound_stmt {}
                | tINT tID tLPAR Params tRPAR Compound_stmt {}
                ;

Params: tVOID
      | Param_list
      ;

Param_list: Param_list tCOMMA Param
          | Param
          ;

Param: tINT tID {}
    | /* empty */
     ;

Compound_stmt: tLBRACE {prof++;} Print_stmt Local_declarations Print_stmt Statement_list Print_stmt tRBRACE {}
             ;

Local_declarations: Local_declarations Var_declaration
                   | /* empty */
                   ;

Statement_list: Statement_list Statement
              | /* empty */
              ;

Print_stmt: tPRINT Simple_expression tSEMI {}
            | /* empty */
            ;

Statement: Expression_stmt
         | Compound_stmt
         | Selection_stmt
         | Iteration_stmt
         | Return_stmt
         ;

Expression_stmt: Expression tSEMI
               | tSEMI
               ;

Selection_stmt: tIF tLPAR Simple_expression tRPAR Compound_stmt Selection_stmt_suite {}
               ;

Selection_stmt_suite : tELSE Compound_stmt {}
        | /* Empty */

Iteration_stmt: tWHILE tLPAR Simple_expression tRPAR Compound_stmt {}
               ;

Return_stmt: tRETURN Expression tSEMI {}
            | tRETURN tSEMI
            ;

Expression: Var tASSIGN Expression {}
          | Simple_expression
          ;

Var: tID {$$ = $1;};

Simple_expression: Additive_expression tLT Additive_expression {}
                 | Additive_expression tGT Additive_expression {}
                 | Additive_expression tLE Additive_expression {}
                 | Additive_expression tGE Additive_expression {}
                 | Additive_expression tEQ Additive_expression {}
                 | Additive_expression tNE Additive_expression {}
                 | Additive_expression
                 ;

Additive_expression: Additive_expression tADD Term {}
                | Additive_expression tSUB Term {}
                | Term
                ;

Term: Term tMUL Factor {}
    | Term tDIV Factor {}
    | Factor
    ;

Factor: tLPAR Expression tRPAR
      | tNB {}
      | Var {}
      | Call
      ;

Call: tID tLPAR Args tRPAR {    }
    ;

Args: Arg_list
    | /* empty*/
    ;


Arg_list: Arg_list tCOMMA Expression
        | Expression
        ;

%%

void yyerror(const char *msg) {
  fprintf(stderr, "error: %s\n", msg);
  exit(1);
}

int main(int argc, char **argv) {
    if (argc == 2) {
        FILE *file = fopen(argv[1], "r");
        if (file == NULL) {
            printf("Unable to open file\n");
            exit(1);
        }
        yyin = file;
        yyparse();
        writeInFile("output");
        fclose(file);
    } else{
        yyparse();
        writeInFile("output");
        afficherInstr();
    }
    return 0;
}
