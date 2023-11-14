/** Seccion de Definiciones **/
%{
#include <stdio.h>
#include <stdlib.h>
#include "2.tab.h"
%}
/** Seccion de Reglas **/
/** Analisis lexico basado en expresiones regulares **/
digito          [0-9]
%%
int                     {yylval.str = strdup(yytext);return TYPE_INT;}
bl                      {yylval.str = strdup(yytext);return TYPE_BL;}
str                     {yylval.str = strdup(yytext);return TYPE_STR;}
flt                     {yylval.str = strdup(yytext);return TYPE_FLT;}
cycle                   {return FOR;}
whilst                  {return WHILE;}
if                      {return IF;}
ifelse                  {return ELSE;}
true|false              {return VAL_BOOL;}
pub|pri                 {return VISIBILITY;}
feedback                {return FEEDBACK;}
{digito}+(\.{digito}+)? {yylval.num = atoi(yytext);return NUM;}
[A-Z]+[a-z]?[A-Z]*      {yylval.str = strdup(yytext);return ID_FUNCTION;}
[a-zA-Z_][a-zA-Z0-9_]*  {yylval.str = strdup(yytext);return IDENTIFIER;}

=                       {return IGU;}
\+                      {return MAS;}
\-                      {return MEN;}
\/                      {return DIV;}
\*                      {return MUL;}
;                       {return EOL;}
\,                      {return COMMA;}
\(                      {return PARENTHESIS_OPEN;}
\)                      {return PARENTHESIS_CLOSE;}
\{                      {return SQUARE_BRAKET_OPEN;}
\}                      {return SQUARE_BRAKET_CLOSE;}
\[                      {return RECTANGLE_BRAKET_OPEN;}
\]                      {return RECTANGLE_BRAKET_CLOSE;}
\<                      {return LESS_THAN;}
\>                      {return GREATER_THAN;}
\!                      {return EXCLAMATION;}
[ \t\n]                 {/*Ignorar espacioess*/}
.                       {printf("Error Léxico: %s\n" ,yytext);}
%%
/** Seccion de código de usuario **/
