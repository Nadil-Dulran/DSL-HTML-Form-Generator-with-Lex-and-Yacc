%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();

FILE *outfile;

char* concat_attrs(char* a, char* b) {
    if (!a) a = strdup("");
    if (!b) b = strdup("");
    char *res = malloc(strlen(a) + strlen(b) + 2);
    sprintf(res, "%s %s", a, b);
    free(a); free(b);
    return res;
}
%}

%union {
    char *str;
}

%token <str> IDENTIFIER STRING
%token FORM END SECTION FIELD LABEL TYPE VALIDATE REQUIRED OPTIONS DEFAULT PATTERN MIN MAX ROWS COLS ACCEPT

%type <str> form section_list section field_list field validation attribute_list attribute

%%

form:
    FORM STRING section_list END {
        fprintf(outfile,
    "<!DOCTYPE html>\n<html>\n<head>\n"
    "    <meta charset=\"UTF-8\">\n"
    "    <title>%s</title>\n"
    "    <link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css\">\n"
    "</head>\n<body>\n"
    "<div class=\"container mt-5\">\n"
    "<form name=\"%s\" method=\"post\" enctype=\"multipart/form-data\">\n%s"
    "<button type=\"submit\" class=\"btn btn-primary\">Submit</button>\n"
    "</form>\n</div>\n</body>\n</html>\n", $2, $2, $3);
        free($2); free($3);
    }
;

section_list:
    /* empty */ { $$ = strdup(""); }
    | section_list section {
        size_t len = strlen($1) + strlen($2) + 1;
        $$ = malloc(len + 1);
        sprintf($$, "%s%s", $1, $2);
        free($1); free($2);
    }
;

section:
    SECTION STRING field_list {
        char *buf = malloc(strlen($2) + strlen($3) + 128);
        sprintf(buf, "  <fieldset>\n    <legend>%s</legend>\n%s  </fieldset>\n", $2, $3);
        $$ = buf;
        free($2); free($3);
    }
;

field_list:
    /* empty */ { $$ = strdup(""); }
    | field_list field {
        size_t len = strlen($1) + strlen($2) + 1;
        $$ = malloc(len + 1);
        sprintf($$, "%s%s", $1, $2);
        free($1); free($2);
    }
;

field:
    FIELD STRING LABEL STRING TYPE STRING validation {
        char *buf = malloc(4096);
        if (strcmp($6, "textarea") == 0) {
            sprintf(buf,
                "    <div class=\"form-group\">\n"
                "        <label for=\"%s\">%s</label>\n"
                "        <textarea class=\"form-control\" name=\"%s\" id=\"%s\" %s></textarea>\n"
                "    </div>\n", $2, $4, $2, $2, $7);
        } else if (strcmp($6, "dropdown") == 0) {
            sprintf(buf,
                "    <div class=\"form-group\">\n"
                "        <label for=\"%s\">%s</label>\n"
                "        <select class=\"form-control\" name=\"%s\" id=\"%s\" %s>\n",
                $2, $4, $2, $2, $7);

            
            char *options_str = strstr($7, "data-options=\"") ? strdup(strchr($7, '\"') + 1) : strdup("");
            char *end_quote = strchr(options_str, '\"');
            if (end_quote) *end_quote = '\0';

            char *option = strtok(options_str, ",");
            while (option) {
                strcat(buf, "            <option value=\"");
                strcat(buf, option);
                strcat(buf, "\">");
                strcat(buf, option);
                strcat(buf, "</option>\n");
                option = strtok(NULL, ",");
            }
            strcat(buf, "        </select>\n    </div>\n");
            free(options_str);
        } else if (strcmp($6, "radio") == 0) {
            sprintf(buf,
                "    <div class=\"form-group\">\n"
                "        <label>%s:</label><br/>\n", $4);

            char *options_str = strstr($7, "data-options=\"") ? strdup(strchr($7, '\"') + 1) : strdup("");
            char *end_quote = strchr(options_str, '\"');
            if (end_quote) *end_quote = '\0';

            char *option = strtok(options_str, ",");
            while (option) {
                strcat(buf,
                    "        <div class=\"form-check form-check-inline\">\n"
                    "            <input class=\"form-check-input\" type=\"radio\" name=\"");
                strcat(buf, $2);
                strcat(buf, "\" value=\"");
                strcat(buf, option);
                strcat(buf, "\" />\n"
                    "            <label class=\"form-check-label\">");
                strcat(buf, option);
                strcat(buf, "</label>\n        </div>\n"); 
                option = strtok(NULL, ",");
            }
            strcat(buf, "    </div>\n");
            free(options_str);

        }  else if (strcmp($6, "checkbox") == 0) {
             sprintf(buf,
        "    <div class=\"form-check\">\n"
        "        <input class=\"form-check-input\" type=\"checkbox\" name=\"%s\" id=\"%s\" %s />\n"
        "        <label class=\"form-check-label\" for=\"%s\">%s</label>\n"
        "    </div>\n"
        "    <br/><br/>\n", $2, $2, $7, $2, $4);
        }

          else {
            sprintf(buf,
                "    <div class=\"form-group\">\n"
                "        <label for=\"%s\">%s</label>\n"
                "        <input class=\"form-control\" type=\"%s\" name=\"%s\" id=\"%s\" %s />\n"
                "    </div>\n", $2, $4, $6, $2, $2, $7);
        }
        $$ = buf;
        free($2); free($4); free($6); free($7);
    }
;

validation:
    /* empty */ { $$ = strdup(""); }
    | VALIDATE attribute_list { $$ = $2; }
;

attribute_list:
    attribute { $$ = $1; }
    | attribute_list attribute {
        $$ = concat_attrs($1, $2);
    }
;

attribute:
    REQUIRED        { $$ = strdup("required"); }
    | PATTERN STRING { 
        $$ = malloc(strlen($2) + 32); 
        sprintf($$, "pattern=\"%s\"", $2); 
        free($2);
    }
    | DEFAULT STRING {
        $$ = malloc(strlen($2) + 32); 
        sprintf($$, "value=\"%s\"", $2); 
        free($2);
    }
    | MIN STRING {
        $$ = malloc(strlen($2) + 16); 
        sprintf($$, "min=\"%s\"", $2); 
        free($2);
    }
    | MAX STRING {
        $$ = malloc(strlen($2) + 16); 
        sprintf($$, "max=\"%s\"", $2); 
        free($2);
    }
    | ROWS STRING {
        $$ = malloc(strlen($2) + 16); 
        sprintf($$, "rows=\"%s\"", $2); 
        free($2);
    }
    | COLS STRING {
        $$ = malloc(strlen($2) + 16); 
        sprintf($$, "cols=\"%s\"", $2); 
        free($2);
    }
    | ACCEPT STRING {
        $$ = malloc(strlen($2) + 20); 
        sprintf($$, "accept=\"%s\"", $2); 
        free($2);
    }
    | OPTIONS STRING {
        $$ = malloc(strlen($2) + 32); 
        sprintf($$, "data-options=\"%s\"", $2); 
        free($2);

// Custom error message - Didn't work because this generate native HTML5 validation, Automatically enforced by the browser and shows a built-in error message — no JavaScript or extra code is needed.

      
    }
;

%%

int main(void) {
    outfile = fopen("output.html", "w");
    if (!outfile) {
        perror("output.html");
        return 1;
    }
    int result = yyparse();
    fclose(outfile);
    return result;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}
