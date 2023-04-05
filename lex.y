%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%code provides {
  int yylex (void);
  void yyerror (const char *);
  extern FILE * yyin;
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
%token tADD tSUB tMUL tDIV tLT tGT tNE tEQ tGE tLE tASSIGN tAND tOR tNOT
%token tLBRACE tRBRACE tLPAR tRPAR tSEMI tCOMMA tERROR

/* Operator precedence */
%left tOR
%left tAND
%left tEQ tNE
%left tLT tLE tGT tGE
%left tADD tSUB
%left tMUL tDIV

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

Var_declaration_mi:  tINT tID {printf("Declare int variable : %s\n", $2);}
                | tINT tID tASSIGN Expression {printf("Declare and assign an int value to : %s\n", $2);}
                | Var_declaration_mi tCOMMA tID tASSIGN Expression {printf("Declare and assign an int value to : %s\n", $3);}
                ;


Fun_declaration: tVOID tID tLPAR Params tRPAR Compound_stmt {printf("Declare void function : %s\n", $2);}
                | tINT tID tLPAR Params tRPAR Compound_stmt {printf("Declare int function : %s\n", $2);}
                ;

Params: tVOID
      | Param_list
      ;

Param_list: Param_list tCOMMA Param
          | Param
          ;

Param: tINT tID {printf("Declare int parameter : %s\n", $2);}
     ;

Compound_stmt: tLBRACE Local_declarations Statement_list Print_stmt tRBRACE
             ;

Local_declarations: Local_declarations Var_declaration
                   | /* empty */
                   ;

Statement_list: Statement_list Statement
              | /* empty */
              ;

Print_stmt: tPRINT Simple_expression tSEMI {printf("Printing a value\n");}
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

Selection_stmt: tIF tLPAR Expression tRPAR Statement %prec tOR {printf("If Statement\n");}
               | tIF tLPAR Expression tRPAR Statement tELSE Statement {printf("If Else Statement\n");}
               ;

Iteration_stmt: tWHILE tLPAR Expression tRPAR Statement {printf("While Statement\n");}
               ;

Return_stmt: tRETURN Expression tSEMI {printf("Returning a value\n");}
            | tRETURN tSEMI
            ;

Expression: Var tASSIGN Expression
          | Simple_expression
          ;

Var: tID
   | tID tLBRACE Expression tRBRACE
   ;

Simple_expression: Additive_expression Relop Additive_expression
                 | Additive_expression
                 ;

Relop: tLT
     | tGT
     | tLE
     | tGE
     | tEQ
     | tNE
     ;

Additive_expression: Additive_expression Addop Term
                | Term
                ;

Addop: tADD
     | tSUB
     ;

Term: Term Mulop Factor
    | Factor
    ;

Mulop: tMUL
     | tDIV
     ;

Factor: tLPAR Expression tRPAR
      | tNB
      | Var 
      | Call
      ;

Call: tID tLPAR Args tRPAR {printf("Calling function : %s\n", $1);}
    ;

Args: Arg_list
    | /* empty */
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
        fclose(file);
    } else{
        yyparse();
    }
    return 0;
}
