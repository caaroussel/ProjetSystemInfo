%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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
%token tADD tSUB tMUL tDIV tLT tGT tNE tEQ tGE tLE tASSIGN tAND tOR tNOT
%token tLBRACE tRBRACE tLPAR tRPAR tSEMI tCOMMA tERROR

%type <d> Factor Var Expression Simple_expression Additive_expression Term

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

Var_declaration_mi:  tINT tID {printf("Declare int variable : %s\n", $2); creationSymb($2, 0);}
                | tINT tID tASSIGN Expression {printf("Declare and assign an int value to : %s\n", $2); creationSymb($2, 1);}
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

Compound_stmt: tLBRACE {prof++;} Local_declarations Statement_list Print_stmt tRBRACE {supprProfAct(); prof--;}
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

Selection_stmt: tIF tLPAR Expression tRPAR Compound_stmt %prec tTHEN {printf("If Statement\n");}
               | tIF tLPAR Expression tRPAR Compound_stmt tELSE Compound_stmt {printf("If Else Statement\n");}
               ;

Iteration_stmt: tWHILE tLPAR Expression tRPAR Compound_stmt {printf("While Statement\n");}
               ;

Return_stmt: tRETURN Expression tSEMI {printf("Returning a value\n");}
            | tRETURN tSEMI
            ;

Expression: Var tASSIGN Expression {$$ = $3;}
          | Simple_expression {$$ = $1;}
          ;

Var: tID {$$ = $1;}
   | tID tLBRACE Expression tRBRACE {$$ = $3;}
   ;

Simple_expression: Additive_expression tLT Additive_expression {$$ = $1 < $3;}
                 | Additive_expression tGT Additive_expression {$$ = $1 > $3;}
                 | Additive_expression tLE Additive_expression {$$ = $1 <= $3;}
                 | Additive_expression tGE Additive_expression {$$ = $1 >= $3;}
                 | Additive_expression tEQ Additive_expression {$$ = $1 == $3;}
                 | Additive_expression tNE Additive_expression {$$ = $1 != $3;}
                 | Additive_expression {$$ = $1;}
                 ;

Additive_expression: Additive_expression tADD Term {$$ = $1 + $3;}
                | Additive_expression tSUB Term {$$ = $1 - $3;}
                | Term {$$ = $1;}
                ;

Term: Term tMUL Factor {$$ = $1 * $3;}
    | Term tDIV Factor {$$ = $1 / $3;}
    | Factor {$$ = $1;}
    ;

Factor: tLPAR Expression tRPAR {$$ = $2;}
      | tNB {$$ = $1;}
      | Var {$$ = $1;}
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
