@include "./whitespace.ne"
@include "./functions.ne"

literal
    -> boolean {% data => makeLiteral("boolean", data[0]) %}
    | number {% data => makeLiteral("number", data[0]) %}
    | string {% data => makeLiteral("string", data[0]) %}
    | atom {% data => makeLiteral("atom", data[0]) %}
    | myNull {% data => makeLiteral("null", data[0]) %}
    | array {% data => makeLiteral("array", data[0]) %}

atom -> ":" characters {% data => data[0] + data[1] %}

array 
    -> "[" _ array_elements _ "]" {% data => data[2] %}
    | "[" "]" {% data => [] %}

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

string -> "\"" characters "\"" {% data => data[1] %}

characters
    -> character {% id %}
    | character characters {% data => data[0] + data[1] %}

character
    -> [a-zA-Z] {% id %}