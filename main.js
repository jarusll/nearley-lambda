const nearley = require('nearley')
const grammer = require('./grammer.js')
const evaluate = require('./eval')

const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammer))

try {
	parser.feed(`let S = 7
let Q = lambda X . X + S
Q . 5`)
	console.log(JSON.stringify(parser.results[0], null, 4))
	console.log(evaluate(parser.results[0]))
} catch (e) {
	console.log(e.message, e)
}