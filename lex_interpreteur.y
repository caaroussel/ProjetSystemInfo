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
%token tADD tSUB tMUL tDIV tLT tGT tNE tEQ tGE tLE tASSIGN tMAIN tCONST tAND tOR tNOT
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

Program:{
    creationInstr("JMT", 0, 0);
    creationInstrVal(getLastInstr(), 0, "0notAfunc");
} Declaration_list
        ;

Declaration_list: Declaration_list Declaration
                | Declaration
                ;

Declaration: Var_declaration
           | Fun_declaration
           ;

Var_declaration: Var_declaration_mi tSEMI
                ;

Var_declaration_mi:  tINT tID {
                    // printf("Declare int variable : %s\n", $2); 
                    creationSymb($2, 0);
                }
                | Var_declaration_mi tCOMMA tID {
                    // printf("Declare int variable : %s\n", $3);
                    creationSymb($3,1);
                }
                | tINT tID tASSIGN Expression {
                    // printf("Declare and assign an int value to : %s\n", $2);
                    supprLast();
                    creationSymb($2,1);
                }
                | tCONST tINT tID tASSIGN Expression {
                    // printf("Declare and assign a const int value to : %s\n", $3);
                    supprLast();
                    creationSymb($3,1);
                }
                | Var_declaration_mi tCOMMA tID tASSIGN Expression {
                    // printf("Declare and assign an int value to : %s\n", $3);
                    supprLast();
                    creationSymb($3,1);
                }
                ;


Fun_declaration: tVOID tMAIN tLPAR {
                    // printf("Je viens de rencontrer Main \n");
                    modifNomInstr(getFirstInstrVal(), getLastInstr(), 1);
                    // printf("%s\n", getNameInstr(getFirstInstrVal()));
                } Params tRPAR Compound_stmt {
                    // printf("Declare void main\n");
                }
                |tVOID tID tLPAR {
                    creationFunctionDetails($2, getLastIndex());
                } Params tRPAR {
                    prof++;
                    creationSymb("_",0);
                    creationSymb("_",0);
                    prof--;
                } Compound_stmt {
                    creationInstr("BX", 0, 0);
                    creationInstrVal(getLastInstr(), 1, $2);
                }{
                    // printf("Declare void function : %s\n", $2);
                }
                | tINT tID tLPAR {
                    creationFunctionDetails($2, getLastIndex());
                } Params tRPAR {
                    prof++;
                    creationSymb("_",0);
                    creationSymb("_",0);
                    prof--;
                } Compound_stmt {
                    creationInstr("BX", 0, 0);
                    creationInstrVal(getLastInstr(), 1, $2);
                }{
                    // printf("Declare int function : %s\n", $2);
                }
                ;

Params: tVOID
      | Param_list
      ;

Param_list: Param_list tCOMMA Param
          | Param
          ;

Param: tINT tID {
        // printf("Declare int parameter : %s\n", $2);
        creationSymb($2,0);
        // printf("POP %d\n", getLast());
        char result[120];
        sprintf(result, "POP %d", getLast());
        creationInstr(result, 0, 0);
    }
    | /* empty */
     ;

Compound_stmt: tLBRACE {prof++;} Local_declarations Statement_list tRBRACE {supprProfAct(); prof--;}
             ;

Local_declarations: Local_declarations Var_declaration
                   | /* empty */
                   ;

Statement_list: Statement_list Statement
              | /* empty */
              ;

Print_stmt: tPRINT Simple_expression tSEMI {
                // printf("Printing a value\n");
                // printf("PRI %d\n", getLast());
                char result[120];
                sprintf(result, "PRI %d", getLast());
                creationInstr(result, 0, 0);
                supprLast();
            }
            ;

Statement: Print_stmt
         | Expression_stmt
         | Compound_stmt
         | Selection_stmt
         | Iteration_stmt
         | Return_stmt
         ;

Expression_stmt: Expression tSEMI
               | tSEMI
               ;

Selection_stmt: tIF tLPAR Simple_expression tRPAR {
    supprLast();
    creationInstr("JMF", 0, 0);
    creationInstrVal(getLastInstr(), 0, "0notAfunc");
} Compound_stmt {
    modifNomInstr(getLastInstrVal(0, "0notAfunc"), getLastInstr(), 0);
    // printf("%s\n", getNameInstr(getLastInstrVal(0, "0notAfunc")));
    supprLastInstrVal(0, "0notAfunc");
} Selection_stmt_suite {
            // printf("If Statement\n");
        }
               ;

Selection_stmt_suite : tELSE {
    creationInstr("JMT", 0, 0);
    creationInstrVal(getLastInstr(), 0, "0notAfunc");
} Compound_stmt {
    modifNomInstr(getLastInstrVal(0, "0notAfunc"), getLastInstr(), 1);
    // printf("%s\n", getNameInstr(getLastInstrVal(0, "0notAfunc")));
    supprLastInstrVal(0, "0notAfunc");
} {
    // printf("If Else Statement\n");
}
        | /* Empty */{
            creationInstr("NOP", 0, 0);
        }

Iteration_stmt: tWHILE tLPAR Simple_expression tRPAR {
    supprLast();
    creationInstr("JMF", 0, 0);
    creationInstrVal(getLastInstr(), 0, "0notAfunc");
} Compound_stmt {
    modifNomInstr(getLastInstrVal(0, "0notAfunc"), getLastInstr(), 0);
    // printf("%s\n", getNameInstr(getLastInstrVal(0, "0notAfunc")));
    char result[120];
    sprintf(result, "JMT %d", getLastInstrValIndex(0, "0notAfunc")-3);
    creationInstr(result, 0, 0);
    supprLastInstrVal(0, "0notAfunc");
} {
    // printf("While Statement\n");
}
               ;

Return_stmt: tRETURN Expression tSEMI {
    // printf("RET %d\n", getLast());
    char result[120];
    sprintf(result, "RET %d", getLast());
    creationInstr(result, 0, 0);
    // printf("Returning a value\n");
}
            | tRETURN tSEMI
            ;

Expression: Var tASSIGN Expression {
                // printf("J'assigne une valeur\n");
                // printf("COP %d %d\n", recupSymb($1, prof), getLast());
                char result[120];
                sprintf(result, "COP %d %d", recupSymb($1, prof), getLast());
                creationInstr(result, 0, 0);
                modifInit($1);
                supprLast();
            }
          | Simple_expression
          ;

Var: tID {$$ = $1;};

Simple_expression: Additive_expression tLT Additive_expression {
                // printf("LT %d %d %d\n", getPreviousLast(), getPreviousLast(), getLast());
                char result[120];
                sprintf(result, "LT %d %d %d", getPreviousLast(), getPreviousLast(), getLast());
                creationInstr(result, 0, 0);
                supprLast();
            }
                 | Additive_expression tGT Additive_expression {
                // printf("GT %d %d %d\n", getPreviousLast(), getPreviousLast(), getLast());
                char result[120];
                sprintf(result, "GT %d %d %d", getPreviousLast(), getPreviousLast(), getLast());
                creationInstr(result, 0, 0);
                supprLast();
            }
                 | Additive_expression tLE Additive_expression {
                // printf("LE %d %d %d\n", getPreviousLast(), getPreviousLast(), getLast());
                char result[120];
                sprintf(result, "LE %d %d %d", getPreviousLast(), getPreviousLast(), getLast());
                creationInstr(result, 0, 0);
                supprLast();
            }
                 | Additive_expression tGE Additive_expression {
                // printf("GE %d %d %d\n", getPreviousLast(), getPreviousLast(), getLast());
                char result[120];
                sprintf(result, "GE %d %d %d", getPreviousLast(), getPreviousLast(), getLast());
                creationInstr(result, 0, 0);
                supprLast();
            }
                 | Additive_expression tEQ Additive_expression {
                // printf("EQ %d %d %d\n", getPreviousLast(), getPreviousLast(), getLast());
                char result[120];
                sprintf(result, "EQ %d %d %d", getPreviousLast(), getPreviousLast(), getLast());
                creationInstr(result, 0, 0);
                supprLast();
            }
                 | Additive_expression tNE Additive_expression {
                // printf("NE %d %d %d\n", getPreviousLast(), getPreviousLast(), getLast());
                char result[120];
                sprintf(result, "NE %d %d %d", getPreviousLast(), getPreviousLast(), getLast());
                creationInstr(result, 0, 0);
                supprLast();
            }
                 | Additive_expression
                 ;

Additive_expression: Additive_expression tADD Term {
                // printf("ADD %d %d %d\n", getPreviousLast(), getPreviousLast(), getLast());
                char result[20];
                sprintf(result, "ADD %d %d %d", getPreviousLast(), getPreviousLast(), getLast());
                creationInstr(result, 0, 0);
                supprLast();
            }
                | Additive_expression tSUB Term {
                // printf("SUB %d %d %d\n", getPreviousLast(), getPreviousLast(), getLast());
                char result[20];
                sprintf(result, "SUB %d %d %d", getPreviousLast(), getPreviousLast(), getLast());
                creationInstr(result, 0, 0);
                supprLast();
            }
                | Term
                ;

Term: Term tMUL Factor {
                // printf("MUL %d %d %d\n", getPreviousLast(), getPreviousLast(), getLast());
                char result[20];
                sprintf(result, "MUL %d %d %d", getPreviousLast(), getPreviousLast(), getLast());
                creationInstr(result, 0, 0);
                supprLast();
            }
    | Term tDIV Factor {
                // printf("DIV %d %d %d\n", getPreviousLast(), getPreviousLast(), getLast());
                char result[20];
                sprintf(result, "DIV %d %d %d", getPreviousLast(), getPreviousLast(), getLast());
                creationInstr(result, 0, 0);
                supprLast();
            }
    | Factor
    ;

Factor: tLPAR Expression tRPAR
      | tNB {
                creationSymb("_",1);
                // printf("AFC %d %d\n", getLast(), $1);
                char result[120];
                sprintf(result, "AFC %d %d", getLast(), $1);
                creationInstr(result, 0, 0);
            }
      | Var {
                creationSymb("_",1);
                // printf("COP %d %d\n", getLast(), recupSymb($1, prof));
                char result[120];
                sprintf(result, "COP %d %d", getLast(), recupSymb($1, prof));
                creationInstr(result, 0, 0);
            }
      | Call
      ;

Call: tID {
    modifyCurrentFunction($1);
} tLPAR Args tRPAR {
        // printf("Calling a function : %s\n", $1);

        creationSymb("_",1);

        // printf("CALL %d %d\n", getFunctionDetailsAdresseDebut(getFunctionDetails($1)), getLast());
        char result2[120];
        sprintf(result2, "CALL %d %d", getFunctionDetailsAdresseDebut(getFunctionDetails($1)), getLast());
        creationInstr(result2, 0, 0);

        modifNomInstr(getLastInstrVal(1, $1), getLastInstr(), 2);
        // printf("%s\n", getNameInstr(getLastInstrVal(1, $1)));
        supprLastInstrVal(1, $1);
        modifFunctionDetails($1, getLastIndex());
        creationInstr("NOP", 0, 0);
    }
    ;

Args: Arg_list
    | /* empty*/
    ;

Arg_list: Arg_list tCOMMA Expression {
            // printf("PUSH %d\n", getLast());
            char result[120];
            sprintf(result, "PUSH %d", getLast());
            creationInstr(result, 0, 0);
            supprLast();
        }
        | Expression {
            // printf("PUSH %d\n", getLast());
            char result[120];
            sprintf(result, "PUSH %d", getLast());
            creationInstr(result, 0, 0);
            supprLast();
        }
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
        writeInFile("output_interpreteur");
        afficherInstr();
    } else{
        yyparse();
        writeInFile("output_interpreteur");
        afficherInstr();
    }
    return 0;
}
