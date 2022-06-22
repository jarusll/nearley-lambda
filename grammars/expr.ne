@include "./literals.ne"
@include "./abstraction.ne"
@include "./application.ne"
@include "./functions.ne"
@include "./calculator.ne"

expr -> literal {% id %}
     | variable {% data => makeVariable(data[0]) %}
     | abstraction {% id %}
     | application {% id %}
     | calculator {% id %}
