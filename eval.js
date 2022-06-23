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
		case "null":
			return null
		case "operation":
			ast.left.block = ast.block
			ast.right.block = ast.block
			const leftVal = evaluate(ast.left)
			const rightVal = evaluate(ast.right)
			const operation = ast.operation
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
		case "array":
			return ast.value
		case "variable":
			return ast.name
			if (ast && ast.block && ast.block.includes(ast.name))
				return ast.name
			if (env[ast.name])
				return env[ast.name]
			return new Error(`Cannot resolve variable: ${ast.name}`)
		case "variable_expression":
			const block = copy(ast.block || [])
			ast.left.block = block
			ast.right.block = block
			const left = evaluate(ast.left)
			const right = evaluate(ast.right)
			const op = ast.operation
			return left.toString() + op + right.toString()
		case "abstraction":
			const argument = ast.argument
			ast.body.block = [argument]
			// const returnValue = 'return ' + evaluate(ast.body)
			return Function(argument, 'return ' + construct(ast.body))
		default:
			throw new Error(`Unknown AST type: ${ast.type}`)
	}
}

function construct(ast){
	switch(ast.type){
		case "number":
			return String(ast.value)
		case "string":
			return `"${ast.value}"`
		case "boolean":
			return String(ast.value)
		case "variable":
			return String(ast.name)
		case "operation":
			const leftOperand = construct(ast.left)
			const rightOperand = construct(ast.right)
			const operation = ast.operation
			return `(${leftOperand} ${operation} ${rightOperand})`
		case "abstraction":
			const { argument, body } = ast
			return Function(argument, 'return ' + construct(body)).toString()
		default:
			return `Unknown ast type: ${ast.type}`
	}
}

module.exports = evaluate
