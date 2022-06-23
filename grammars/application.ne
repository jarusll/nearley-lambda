@include "./whitespace.ne"

application -> abstraction _ "." _ application
	    {% data => makeApplication(data[0], data[4]) %}
		| abstraction _ "." _ arguments
	    {% data => makeApplication(data[0], data[4]) %}

arguments -> expr _ "." _ arguments
	{% data => [data[0], ...data[4]] %}
	| expr {% data => [data[0]] %}
