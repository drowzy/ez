type t = {expr: Ast.expr; debug: bool;}

let to_ast str =
  str
  |> Lexing.from_string
  |> Ez_parser.prog Ez_lexer.read

let to_elastic ast =
  ast
  |> Compiler.compile
  |> Compiler.with_query

let from_req json =
  let open Ezjsonm in
  { expr = to_ast (get_string (find json ["expr"]));
    debug = (get_bool (find json ["debug"]))
  }

let create_target ~expr ~debug =
  {expr = to_ast expr ; debug;}

let to_response {expr; debug;} =
  let open Ezjsonm in
  dict [
    "data", from_string (expr |> to_elastic |> Compiler.to_string);
    "debug", `String (if debug == true then "there should be a debug string here" else "")
  ]
