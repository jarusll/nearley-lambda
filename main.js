const nearley = require('nearley')
const grammar = require('./grammar.js')
const evaluate = require('./eval')

const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar))

try {
	parser.feed(`lambda x . x * x . (lambda x . x * x . 5)`)
	// console.log(Array.from(new Set(parser.results.map(x => JSON.stringify(x)))).map(x => JSON.stringify(JSON.parse(x), null, 4)))
	console.log(parser.results.length)
	// console.log(JSON.stringify(parser.results[0], null, 4))
	console.log(evaluate(parser.results[0]))
} catch (e) {
	console.log(e.message, e)
}