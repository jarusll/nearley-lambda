@{%

function makeVariable(name){
	 return {
	 	type: "variable",
		name
	 }
}

function makeOperation(op, left, right){
	 return {
	 	type: "operation",
		operation: op,
		left,
		right
	 }
}

function makeLiteral(type, value){
	 return {
	 	type,
		value
	 }
}

function makeAbstraction(argument, body){
	 return {
	 	type: "abstraction",
		argument,
		body
	 }
}

function makeApplication(fn, arguments){
	 return {
	 	type: "application",
		function: fn,
		arguments
	 }
}

%}