@include "./whitespace.ne"

application -> abstraction _ "." _ expr
	    {% data => makeApplication(data[0], data[4]) %}