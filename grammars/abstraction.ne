@include "./whitespace.ne"
@include "./literals.ne"
@include "./application.ne"

abstraction -> "lambda" __ variable _ "." _ abstraction
	    {% data => makeAbstraction(data[2].name, data[6]) %}
	    | "lambda" __ variable _ "." _ operation
	    {% data => makeAbstraction(data[2].name, data[6]) %}
