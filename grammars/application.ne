@include "./whitespace.ne"
@include "./literals.ne"

application -> abstraction _ "." _ application
	    {% data => makeApplication(data[0], data[4]) %}
		| abstraction _ "." _ arguments
	    {% data => makeApplication(data[0], data[4]) %}

arguments -> argument _ "." _ arguments
	{% data => [data[0], ...data[4]] %}
	| argument
	{% data => [data[0]] %}

argument -> literal {% id %}
	| "(" _ application _ ")" {% data => data[2]%}