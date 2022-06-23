programs
    -> statements {% data => ({type: "statements", statements: data[0]})%}

statements 
    -> statement {% data => [data[0]] %}
    | statement "\n" statements {% data => [data[0], ...data[2]] %}
    | "\n" statements {% data => [data[1]] %}
    | _ {% data => [] %}

statement
    -> assignment {% id %}
    | expr {% id %}

assignment  
    -> "let" _ variable _ "=" _ expr {% data => ({type: "assignment", variable: data[2], value: data[6]}) %}
    
expr 
    -> literal {% id %}
    | variable {% data => ({type: "variable", name: data[0]}) %}
    | primitive {% id %}

primitive
    -> list_operation _ array {% data => ({type: "operation", operator: data[0], argument: data[2]}) %}

list_operation
    -> "FIRST"
    | "REST"
    | "CONS"
