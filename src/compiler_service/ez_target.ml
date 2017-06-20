type t = {expr: Ast.expr; debug: bool;}

let to_ast str =
  (Lwt_log.ign_info_f "%s " str);
  str
  |> Lexing.from_string
  |> Ez_parser.prog Ez_lexer.read

let to_elastic ast =
  ast
  |> Es.from_ez

let from_req json =
  let open Ezjsonm in
  { expr = to_ast (get_string (find json ["expr"]));
    debug = (get_bool (find json ["debug"]))
  }

let create_target ~expr ~debug =
  {expr = to_ast expr ; debug;}

let to_response {expr; debug;} =
  let open Ezjsonm in
  let es_t = to_elastic expr in
  dict [
    "data", from_string (
      es_t
      |> Es.to_json_ast
      |> Es.wrap_json "query"
      |> Es.json_to_string
    );
    "debug", `String (
      if debug == true
      then Ast.to_string expr
      else ""
    )
  ]
