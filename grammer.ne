programs
    -> statements {% data => ({type: "statements", statements: data[0]})%}

statements 
    -> statement {% data => [data[0]] %}
    | statement "\n" statements {% data => [data[0], ...data[2]] %}
    | "\n" statements {% data => [data[1]] %}
    | _ {% data => [] %}

statement
    -> expr {% id %}
    | assignment {% id %}
    
assignment  
    -> "let" _ variable _ "=" _ expr {% data => ({type: "assignment", variable: data[2][0], value: data[6]}) %}

expr 
    -> literal {% id %}
    | multiplicative {% id %}
    | additive {% id %}
    | function {% id %}
    | application {% id %}
    | variable_expression {% id %}
    
additive  
    -> multiplicative _ [+-] _ additive 
    {%
    (data) => {
        switch(data[2]){
            case "+":
                return {type: "operation", operator: "+", left: data[0], right: data[4]}
            case "-":
                return {type: "operation", operator: "-", left: data[0], right: data[4]}
        }
    }
    %}
    | multiplicative {% id %}
    
multiplicative
    -> unary_expression _ [*/] _ multiplicative
    {%
    (data) => {
        switch(data[2]){
            case "*":
                return {type: "operation", operator: "*", left: data[0], right: data[4]}
            case "/":
                return {type: "operation", operator: "/", left: data[0], right: data[4]}
        }
    }
    %}
    | unary_expression {% id %}
    
unary_expression
    -> application {% id %}
    | number {% (data) => ({type: "number", value: data[0]}) %}
    | "(" _ additive _ ")" {% data => data[2] %}

function 
    -> "lambda" _ variable _ "." _ variable_expression {% data => ({type: "abstraction", arg: data[2][0], return: data[6] }) %} 
    | "lambda" _ variable _ "." _ function {% data => ({type: "abstraction", arg: data[2][0], return: data[6] }) %} 

variable_expression
    -> additive {% id %}
    | variable _ operator _ variable_expression {% (data) => ({type: "variable_expression", op: data[2], left: {type: "variable", name: data[0][0]}, right: data[4]}) %}
    | number _ operator _ variable_expression {% (data) => ({type: "variable_expression", op: data[2], left: data[0][0], right: data[4]}) %}
    | variable {% data => ({type: "variable", name: data[0][0]}) %}

operator
    -> "+" {% id %}
    | "-" {% id %}
    | "*" {% id %}
    | "/" {% id %}

application
    -> function _ "." _ argument {% (data) => ({type: "application", function: data[0], argument: data[4]}) %}
    | function _ "." _ arguments {% (data) => ({type: "application", function: data[0], arguments: data[4]}) %}
    | variable _ "." _ argument {% (data) => ({type: "application", function: {type: "variable", name: data[0][0]}, argument: data[4]}) %}

arguments
    -> argument _ "." _ arguments {% (data) => [data[0], data[4]]%}
    | argument {% id %}
    | additive {% id %}

argument
    -> literal {% id %}

literal
    -> boolean {% data => ({type: "boolean", value: data[0]}) %}
    | number {% data => ({type: "number", value: data[0]}) %}
    | string {% data => ({type: "string", value: data[0]}) %}
    | myNull {% data => ({type: "null", value: data[0]}) %}
    
boolean 
    -> "true" {% () => true %}
    | "false" {% () => false %}

myNull
    -> "null" {% () => null %}
    
number 
    -> digits "." digits {% data => Number(data[0] + "." + data[2]) %}
    | digits {% data => Number(data[0]) %}
    
digits 
    -> digit {% id %}
    | digit digits {% data => data.join("") %}
    
digit 
    ->  [0-9] {% id %}

_ -> [ \t]:?

string -> "\"" characters "\"" {% data => data[1] %}

characters
    -> character {% id %}
    | character characters {% data => data[0] + data[1] %}
    
character
    -> [^\"]:+ {% id %}

variable
    -> [A-Z]:+ {% id %}