@include "./expr.ne"
@include "./whitespace.ne"
@include "./functions.ne"

program -> statements {% data => makeStatements(data[0]) %}

statements -> statement _ "\n" _ statements 
    {% data => [data[0], ...data[4]] %}
    | statement {% data => [data[0]] %}
    | "\n" _ statement {% data => [data[2]] %}
    | _ {% data => [] %}

statement -> expr {% id %}