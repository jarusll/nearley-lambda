const nearley = require('nearley')
const grammer = require('./grammer.js')

const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammer))

function copy(json){
	return JSON.parse(JSON.stringify(json))
}

function BinOp(operation, leftVal, rightVal) {
	switch (operation) {
		case "+":
			return leftVal + rightVal
		case "-":
			return leftVal - rightVal
		case "*":
			return leftVal * rightVal
		case "/":
			return Math.floor(leftVal / rightVal)
		default:
			return new Error(`Unknown operation: ${operation}`)
	}
}

let env = {}
function evaluate(ast) {
	switch (ast.type) {
		case "statements":
			return ast.statements.map(statement => evaluate(statement))	
		case "assignment":
			const variable = ast.variable
			const value = evaluate(ast.value)
			env[variable] = value
			return value
		case "operation":
			const leftVal = evaluate(ast.left)
			const rightVal = evaluate(ast.right)
			const operation = ast.operator
			return BinOp(operation, leftVal, rightVal)
		case "application":
			const fn = evaluate(ast.function)
			if (ast.argument) {
				const argument = evaluate(ast.argument)
				return fn(argument)
			}
			if (ast.arguments) {
				const args = ast.arguments.map(x => evaluate(x))
				return args.slice(1).reduce((acc, curr) => acc(curr), fn(args[0]))
			}
			return fn
		case "argument":
			return ast.value
		case "arguments":
			return ast.map(x => evaluate(x))
		case "number":
			return ast.value
		case "string":
			return ast.value
		case "boolean":
			return ast.value
		case "variable":
			if (ast?.block?.includes(ast.name))
				return ast.name
			if (env[ast.name])
				return env[ast.name]
			return "Cannot resolve ast.name"
		case "variable_expression":
			const block = copy(ast.block || [])
			ast.left.block = block
			ast.right.block = block
			const left = evaluate(ast.left)
			const right = evaluate(ast.right)
			const op = ast.op
			return left.toString() + op + right.toString()
		case "abstraction":
			const arg = ast.arg
			ast.return.block = [arg]
			const returnValue = 'return ' + evaluate(ast.return)
			return Function(arg, returnValue)
		default:
			throw new Error(`Unknown AST type: ${ast.type}`)
	}
}

try {
	parser.feed(`let S = lambda X . X * X
S . 100`)
	console.log(JSON.stringify(parser.results[0], null, 4))
	console.log(evaluate(parser.results[0]))
} catch (e) {
	console.log(e.message, e)
}

// {% data => new Function(`${data[2]}`, `return ${data[6]}`) %}

