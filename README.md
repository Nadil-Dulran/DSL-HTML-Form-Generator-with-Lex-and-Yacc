# DSL-HTML-Form-Generator-with-Lex-and-Yacc
Domain-Specific Language (DSL) named FormLang++ for form specification. Using Lex and Yacc to parse the DSL and generate equivalent HTML forms with validation.


To Generate and Open HTML Form (On Mac) -  flex lexer.l && bison -d parser.y && gcc lex.yy.c parser.tab.c -o form_parser && ./form_parser < example.form && open output.html


I created demo video for walkthrough of code structure - https://mysliit-my.sharepoint.com/:v:/g/personal/it23161788_my_sliit_lk/EcICqXvuvv9Kv6TItq8bzmsB3X0JM_xH6NPJGwuY_cS2MA?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=XS2lN4


Grammar Specification (EBNF)


# Form Structure
form ::= "form" STRING section_list "end"
section_list ::= { section }
section ::= "section" STRING field_list
field_list ::= { field }
# Field Declarations
field ::= "field" STRING "label" STRING "type" field_type validation_block
field_type ::= "text" | "email" | "password" | "number" | "textarea" |
"radio" | "dropdown" | "checkbox" | "file" | "date"
# Validation and Attributes
validation_block ::= "validate" attribute_list
attribute_list ::= attribute { attribute }
attribute ::=
"required"
| "pattern" STRING
| "default" STRING
| "min" STRING
| "max" STRING
| "rows" STRING
| "cols" STRING
| "accept" STRING
| "options" STRING
# Option Handling
options for radio and dropdown:
"options" STRING → comma-separated list (e.g., "Male,Female,Other")
# File Support
field "resume" label "Upload Resume" type "file" validate accept "jpeg/pdf"
required
# Date Support
field "dob" label "Date of Birth" type "date" validate min "1950-01-01" max
"2024-12-31" required
# Tokens (Defined in lexical.l)
STRING ::= "." (quoted string)
IDENTIFIER ::= [a-z A-Z_][a-z A-Z 0-9]
NUMBER ::= [0-9]+
# Validation Examples
field "age" label "Age" type "number" validate min "18" max "99"
field "gender" label "Gender" type "radio" validate options
"Male,Female,Other"
field "subscribe" label "Subscribe to Mails" type "checkbox"
# Terminals: -
STRING - A quoted string (e.g., "sample")
IDENTIFIER - Alphanumeric strings (e.g., username)
Keywords - form, end, section, field, label, type, validate, required, default,
options, pattern, min, max, rows, cols, accept
# Non-Terminals: -
Form, SectionList, Section, FieldList, Field, Validation, AttributeList, Attribute
