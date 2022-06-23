@include "./literals.ne"
@include "./abstraction.ne"
@include "./application.ne"
@include "./functions.ne"
@include "./calculator.ne"

expr -> literal {% id %}
     | abstraction {% id %}
     | application {% id %}
     | calculator {% id %}
