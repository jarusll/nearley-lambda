@include "./whitespace.ne"
@include "./literals.ne"

calculator -> operation {% id %}

variable -> [A-Z]:+ {% data => makeVariable(String(data).replace(/,/g, "")) %}

variable_expression
    -> variable _ operation _ variable_expression
       {% data => makeOperation(data[2], data[0], data[4]) %}
    | number _ operation _ variable_expression
       {% data => makeOperation(data[2], data[0], data[4]) %}
    | variable {% id %}
    | number {% data => makeLiteral("number", data[0]) %}

operation -> unary {% id %}
	  | binary {% id %}

unary -> negation {% id %}
      | grouping {% id %}
      | number {% data => makeLiteral("number", data[0]) %}
      | variable {% id %}

negation -> "-" _ number
	 {% data => -data[2] %}
grouping -> "(" operation ")"
	 {% data => data[1] %}

binary -> additive {% id %}
	| comparative {% id %}
comparative -> additive _ comparative_op _ additive
	    {% data => makeOperation(data[2], data[0], data[4]) %}
	| additive {% id %}
comparative_op -> ">" {% id %}
	       | "<" {% id %}
additive -> multiplicative _ additive_op _ multiplicative
	    {% data => makeOperation(data[2], data[0], data[4]) %}
	| multiplicative {% id %}
additive_op -> "+" {% id %}
	    | "-" {% id %}
multiplicative -> exponent _ multiplicative_op _ exponent
	    {% data => makeOperation(data[2], data[0], data[4]) %}
	| exponent {% id %}
multiplicative_op -> "*" {% id %}
		  | "/" {% id %}
exponent -> unary _ "**" _ unary
	{% data => makeOperation(data[2], data[0], data[4]) %}
	 | unary {% id %}