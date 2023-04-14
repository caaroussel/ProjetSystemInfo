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

Var_declaration_mi:  tINT tID {printf("Declare int variable : %s\n", $2); creationSymb($2, 0);}
                | tINT tID tASSIGN Expression {printf("Declare and assign an int value to : %s\n", $2);
                    supprLast();
                    creationSymb($2,1);
                }
                | Var_declaration_mi tCOMMA tID tASSIGN Expression {printf("Declare and assign an int value to : %s\n", $3);
                    supprLast();
                    creationSymb($3,1);
                }
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

Param: tINT tID {printf("Declare int parameter : %s\n", $2); creationSymb($2,0);}
    | /* empty */
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

Expression: Var tASSIGN Expression {
                printf("J'assigne une valeur\n");
                printf("COP %p %p\n", recupSymb($1), getLast());
                modifInit($1);
                supprLast();
            }
          | Simple_expression
          ;

Var: tID {$$ = $1;};

Simple_expression: Additive_expression tLT Additive_expression {
                printf("LT %p %p %p\n", getPreviousLast(), getPreviousLast(), getLast());
                supprLast();
            }
                 | Additive_expression tGT Additive_expression {
                printf("GT %p %p %p\n", getPreviousLast(), getPreviousLast(), getLast());
                supprLast();
            }
                 | Additive_expression tLE Additive_expression {
                printf("LE %p %p %p\n", getPreviousLast(), getPreviousLast(), getLast());
                supprLast();
            }
                 | Additive_expression tGE Additive_expression {
                printf("GE %p %p %p\n", getPreviousLast(), getPreviousLast(), getLast());
                supprLast();
            }
                 | Additive_expression tEQ Additive_expression {
                printf("EQ %p %p %p\n", getPreviousLast(), getPreviousLast(), getLast());
                supprLast();
            }
                 | Additive_expression tNE Additive_expression {
                printf("NE %p %p %p\n", getPreviousLast(), getPreviousLast(), getLast());
                supprLast();
            }
                 | Additive_expression
                 ;

Additive_expression: Additive_expression tADD Term {
                printf("ADD %p %p %p\n", getPreviousLast(), getPreviousLast(), getLast());
                supprLast();
            }
                | Additive_expression tSUB Term {
                printf("SUB %p %p %p\n", getPreviousLast(), getPreviousLast(), getLast());
                supprLast();
            }
                | Term
                ;

Term: Term tMUL Factor {
                printf("MUL %p %p %p\n", getPreviousLast(), getPreviousLast(), getLast());
                supprLast();
            }
    | Term tDIV Factor {
                printf("DIV %p %p %p\n", getPreviousLast(), getPreviousLast(), getLast());
                supprLast();
            }
    | Factor
    ;

Factor: tLPAR Expression tRPAR
      | tNB {
                creationSymb("_",1);
                printf("AFC %p %d\n", getLast(), $1);
            }
      | Var {
                creationSymb("_",1);
                printf("COP %p %p\n", (int *)recupSymb($1), getLast());
            }
      | Call
      ;

Call: tID tLPAR Args tRPAR {printf("Calling function : %s\n", $1);}
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
        fclose(file);
    } else{
        yyparse();
    }
    return 0;
}
