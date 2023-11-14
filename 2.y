/** Seccion de Definiciones **/
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex(void);
extern FILE *yyin;   
void yyerror(char *s); 



%}
%union {
    int num;
    char* str;
}
%token NUM <str>IDENTIFIER <str>TYPE_INT TYPE_BL TYPE_STR TYPE_FLT VAL_BOOL VISIBILITY FEEDBACK ID_FUNCTION
%token MAS MEN MUL DIV
%token IGU FOR IF ELSE WHILE 
%token EOL COMMA
%token PARENTHESIS_OPEN PARENTHESIS_CLOSE SQUARE_BRAKET_OPEN SQUARE_BRAKET_CLOSE LESS_THAN
%token GREATER_THAN EXCLAMATION RECTANGLE_BRAKET_OPEN RECTANGLE_BRAKET_CLOSE

%type <str> type
%type <str> type_num
%type <str> type_boolean
%type <str> type_str
/** Seccion de Reglas **/
%%
entrada  :                 /* Cadena Vacía */
         |                 entrada linea
         |                 entrada functions {printf("Funcion Correcta \n");}

linea    : EOL
         | exp EOL                     {printf("Expresion Aritmetica con: Sintaxis Correcta\n");}
         | for_loop EOL                {printf("For Con: Sintaxis Correcta\n");}
         | assignment_num EOL          {printf("Asignación: Sintaxis Correcta\n");}
         | assignment_bool EOL         {printf("Asignación: Sintaxis Correcta\n");}
         | assignment_str EOL          {printf("Asignación: Sintaxis Correcta\n");}
         | variable_declaration EOL    {printf("Declaración: Sintaxis Correcta\n");}
         | if_statement EOL            {printf("If con: Sintaxis Correcta\n");}
         | if_else_statement EOL       {printf("If Else con: Sintaxis Correcta\n");}
         | while_loop EOL              {printf("While con: Sintaxis Correcta\n");}

functions:
         VISIBILITY ID_FUNCTION type PARENTHESIS_OPEN parameters PARENTHESIS_CLOSE
         RECTANGLE_BRAKET_OPEN type IDENTIFIER EOL function_body FEEDBACK IDENTIFIER EOL RECTANGLE_BRAKET_CLOSE EOL 
         
         {
    if(strcmp($9, $13) != 0){
            {yyerror("ERROR DE RETORNO \n");exit(EXIT_FAILURE);}
         }
};

parameters:
    /* Cadena Vacía */
    | parameters type IDENTIFIER
    | parameters type IDENTIFIER COMMA 

function_body: linea
             | function_body linea

while_loop:
    WHILE PARENTHESIS_OPEN exp_validate PARENTHESIS_CLOSE RECTANGLE_BRAKET_OPEN linea RECTANGLE_BRAKET_CLOSE

for_loop : FOR PARENTHESIS_OPEN assignment_num EOL exp_validate EOL IDENTIFIER MAS MAS PARENTHESIS_CLOSE RECTANGLE_BRAKET_OPEN
           linea RECTANGLE_BRAKET_CLOSE

if_statement:
    IF PARENTHESIS_OPEN exp_validate PARENTHESIS_CLOSE RECTANGLE_BRAKET_OPEN 
        linea RECTANGLE_BRAKET_CLOSE

if_else_statement:
    IF PARENTHESIS_OPEN exp_validate PARENTHESIS_CLOSE RECTANGLE_BRAKET_OPEN 
        linea RECTANGLE_BRAKET_CLOSE ELSE RECTANGLE_BRAKET_OPEN linea RECTANGLE_BRAKET_OPEN

assignment_num :  type_num IDENTIFIER IGU NUM
               |  type_num IDENTIFIER IGU VAL_BOOL {yyerror("Asignacion de Valor incorrecta\n");exit(EXIT_FAILURE);}
               |  type_num IDENTIFIER IGU IDENTIFIER {yyerror("Asignacion de Valor incorrecta\n");exit(EXIT_FAILURE);}
    
assignment_bool:  type_boolean IDENTIFIER IGU VAL_BOOL
               |  type_boolean IDENTIFIER IGU NUM {yyerror("Asignacion de Valor incorrecta\n");exit(EXIT_FAILURE);}
               |  type_boolean IDENTIFIER IGU IDENTIFIER {yyerror("Asignacion de Valor incorrecta\n");exit(EXIT_FAILURE);}
    
assignment_str :  type_str IDENTIFIER IGU IDENTIFIER
               |  type_str IDENTIFIER IGU NUM {yyerror("Asignacion de Valor incorrecta\n");exit(EXIT_FAILURE);}
               |  type_str IDENTIFIER IGU VAL_BOOL {yyerror("Asignacion de Valor incorrecta\n");exit(EXIT_FAILURE);}
    

variable_declaration: type_num IDENTIFIER
                    | type_boolean IDENTIFIER
                    | type_str IDENTIFIER

exp      : NUM MAS NUM IGU NUM
         | NUM MEN NUM IGU NUM
         | NUM DIV NUM IGU NUM
         | NUM MUL NUM IGU NUM

exp_validate      : NUM IGU IGU NUM
                  | NUM EXCLAMATION IGU NUM
                  | IDENTIFIER IGU IGU IDENTIFIER
                  | IDENTIFIER EXCLAMATION IGU IDENTIFIER
                  | IDENTIFIER IGU IGU NUM
                  | NUM LESS_THAN IGU NUM
                  | NUM GREATER_THAN IGU NUM
                  | NUM LESS_THAN NUM
                  | NUM GREATER_THAN NUM
                  | IDENTIFIER LESS_THAN IGU NUM
                  | IDENTIFIER GREATER_THAN IGU NUM
                  | IDENTIFIER LESS_THAN NUM
                  | IDENTIFIER GREATER_THAN NUM
                  | NUM LESS_THAN IGU IDENTIFIER
                  | NUM GREATER_THAN IGU IDENTIFIER
                  | NUM LESS_THAN IDENTIFIER
                  | NUM GREATER_THAN IDENTIFIER

type : type_num
     | type_boolean
     | type_str


type_num : TYPE_INT
         | TYPE_FLT

type_boolean : TYPE_BL

type_str : TYPE_STR

%%
/** Seccion de código de usuario **/
void yyerror(char *s){
    printf("Error Sintáctico: %s\n",s);
}

int main(int argc, char **argv){
    printf("Inicio del Programa! \n");
    if(argc>1)
        yyin=fopen(argv[1],"rt");
    else
        yyin=stdin;
    yyparse();
return 0;
}
