%{
#include "parser.tab.h"
#include <string.h>
%}

%%

"form"          { return FORM; }
"end"           { return END; }
"section"       { return SECTION; }
"field"         { return FIELD; }
"label"         { return LABEL; }
"type"          { return TYPE; }
"validate"      { return VALIDATE; }
"required"      { return REQUIRED; }
"options"       { return OPTIONS; }
"default"       { return DEFAULT; }
"pattern"       { return PATTERN; }
"min"           { return MIN; }
"max"           { return MAX; }
"rows"          { return ROWS; }
"cols"          { return COLS; }
"accept"        { return ACCEPT; }


\"([^\\\"]|\\.)*\"  {
                    yylval.str = strdup(yytext + 1);
                    yylval.str[strlen(yylval.str) - 1] = '\0';
                    return STRING;
                  }

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str = strdup(yytext);
    return IDENTIFIER;
}

[ \t\r\n]+     

"#".*       

.               { return yytext[0]; }

%%

int yywrap() {
    return 1;
}
