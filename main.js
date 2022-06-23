const nearley = require('nearley')
const grammar = require('./grammar.js')
const evaluate = require('./eval')

const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar))

try {
	parser.feed(`lambda X . lambda Y . X + Y . 1 . ( lambda X . X * X . 5 )`)
	// console.log(Array.from(new Set(parser.results.map(x => JSON.stringify(x)))).map(x => JSON.stringify(JSON.parse(x), null, 4)))
	console.log(JSON.stringify(parser.results[0], null, 4))
	console.log(evaluate(parser.results[0]))
} catch (e) {
	console.log(e.message, e)
}