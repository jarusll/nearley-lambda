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

literal
    -> boolean {% data => ({type: "boolean", value: data[0]}) %}
    | number {% data => ({type: "number", value: data[0]}) %}
    | string {% data => ({type: "string", value: data[0]}) %}
    | atom {% data => ({type: "atom", value: data[0]}) %}
    | myNull {% data => ({type: "null", value: data[0]}) %}
    | array {% id %}

atom -> ":" characters {% data => data[0] + data[1] %}

array 
    -> "[" _ array_elements _ "]" {% data => ({type: "array", value: data[2]}) %}
    | "[" "]" {% data => ({type: "array", value: []}) %}

array_elements
    -> literal _ "," _ array_elements {% (data) => [data[0], ...data[4]] %}
    | literal {% data => [data[0]] %}

boolean 
    -> "true" {% () => true %}
    | "false" {% () => false %}

myNull
    -> "null" {% () => null %}

number 
    -> digits "." digits {% data => Number(data[0] + "." + data[2]) %}
    | digits {% data => Number(data[0]) %}
    | "-" digits {% data => -Number(data[1]) %}

digits 
    -> digit {% id %}
    | digit digits {% data => data.join("") %}

digit 
    ->  [0-9] {% id %}

_ -> [ \t]:*

string -> "\"" characters "\"" {% data => data[1] %}

characters
    -> character {% id %}
    | character characters {% data => data[0] + data[1] %}

character
    -> [^\"] {% id %}

variable
    -> [A-Z]:+ {% data => data.join().replace(/,/g, "") %}
