@include "./whitespace.ne"
@include "./literals.ne"
@include "./application.ne"

abstraction -> "lambda" __ variable _ "." _ expr
	    {% data => makeAbstraction(data[2], data[6]) %}
	    | "lambda" __ variable _ "." _ variable_expression
	    {% data => makeAbstraction(data[2], data[6]) %}
