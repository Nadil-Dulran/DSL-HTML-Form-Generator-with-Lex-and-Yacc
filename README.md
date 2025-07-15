# DSL-HTML-Form-Generator-with-Lex-and-Yacc
Domain-Specific Language (DSL) named FormLang++ for form specification. Using Lex and Yacc to parse the DSL and generate equivalent HTML forms with validation.

To Generate and Open HTML Form (On Mac) -  flex lexer.l && bison -d parser.y && gcc lex.yy.c parser.tab.c -o form_parser && ./form_parser < example.form && open output.html
I created demo video for walkthrough of code structure - https://mysliit-my.sharepoint.com/:v:/g/personal/it23161788_my_sliit_lk/EcICqXvuvv9Kv6TItq8bzmsB3X0JM_xH6NPJGwuY_cS2MA?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=XS2lN4
