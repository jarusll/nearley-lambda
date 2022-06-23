#!/bin/node

const nearley = require('nearley')
const readFile = require('read-file')
const writeFile = require('write')
const { Command } = require('commander');

const grammar = require('./grammar.js')
const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar))

const program = new Command();

program
    .name('nearley-lambda-parser')
    .description('Generate the syntax tree for execution')
    .version('0.1.0');

program.command('generate')
    .description('Generate the syntax tree for input file')
    .argument('<input>', 'input file for parsing')
    .argument('<output>', 'output file')
    .action((input, output) => {
        try {
            // read file
            const source = readFile.sync(input, 'utf-8')
            parser.feed(source)
            if (parser.results.length == 0)
                throw new Error("No input")
            if (parser.results.length > 1)
                throw new Error("Ambiguity found")
            writeFile.sync(output, JSON.stringify(parser.results[0], null, 4), {
                overwrite: true,
                newline: true
            })
        } catch(e) {
            console.log(e.message)
        }
    });

program.parse();