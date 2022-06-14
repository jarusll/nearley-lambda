const nearley = require('nearley')
const grammer = require('./grammar.js')
const evaluate = require('./eval')

const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammer))

try {
	parser.feed(`let SQR = lambda X . X * X
SQR . 17`)
	console.log(JSON.stringify(parser.results[0], null, 4))
	console.log(evaluate(parser.results[0]))
} catch (e) {
	console.log(e.message, e)
}