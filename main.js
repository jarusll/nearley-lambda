const nearley = require('nearley')
const grammer = require('./grammer.js')

const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammer))

function evaluate(ast){
    switch(ast.type){
        case "application":
            const fn = evaluate(ast.function)
            if (ast.argument){
                const argument = evaluate(ast.argument)
                return argument
            }
            if (ast.arguments){
                const arguments = ast.arguments.map(x => evaluate(x))
                return arguments.slice(1).reduce((acc, curr) => acc(curr), fn(arguments[0]))
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
            return ast.name
        case "variable_expression":
            const left = evaluate(ast.left)
            const right = evaluate(ast.right)
            const op = ast.op
            return left.toString() + op + right.toString()
        case "abstraction":
            const arg = ast.arg
            const returnValue = 'return ' + evaluate(ast.return)
            return Function(arg, returnValue)
        default:
            throw new Error(`Unknown AST type: ${ast.type}`)
    }
}

try {
    parser.feed(`lambda X . lambda Y . X * Y + 1 . 7 . 8`)
    console.log(parser.results[0])
    console.log(evaluate(parser.results[0]))
} catch (e) {
    console.log(e.message, e)
}

// {% data => new Function(`${data[2]}`, `return ${data[6]}`) %}