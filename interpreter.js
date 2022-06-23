#!/bin/node
const readline = require('readline-sync')
const nearley = require('nearley')
const exprGrammar = require('./expr.js')
const evaluate = require('./evaluate')

let input
while (input != "quit") {
    input = readline.question('nl>');
    const parser = new nearley.Parser(nearley.Grammar.fromCompiled(exprGrammar))
    try {
        parser.feed(input)
        console.log(evaluate(parser.results[0]))
    } catch (e){
        console.log(e.message)
    }
}