module Ast = Ast

module Es = Es

module Parser = Ez_parser

module Lexer = Ez_lexer

let compile str =
  str
  |> Lexing.from_string
  |> Parser.prog Lexer.read
  |> Es.from_ez
  |> Es.to_json_ast
