let do_parse buf =
  Parser.prog Lexer.read buf

let from_string s =
  Lexing.from_string s
  |> do_parse

let from_channel ch =
  Lexing.from_channel ch
  |> do_parse
