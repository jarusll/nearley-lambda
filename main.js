const nearley = require('nearley')
const grammar = require('./grammar.js')
const evaluate = require('./evaluate')

const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar))

try {
	parser.feed(`lambda x . x * x . (lambda x . x * x . 5)`)
	console.log(JSON.stringify(parser.results[0], null, 4))
	console.log(evaluate(parser.results[0]))
} catch (e) {
	console.log(e.message, e)
}