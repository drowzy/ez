open Core.Std
open Ast
open Elastic_compiler

let get_inchan = function
  | "-" -> In_channel.stdin
  | filename -> In_channel.create ~binary: true filename
(* Parse a string into an ast *)
let parse s =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast

let parse_stream ch =
  let lexbuf = Lexing.from_channel ch in
  let ast = Parser.prog Lexer.read lexbuf in
  ast

(* compile ast to elastic json ast *)

let compile filename =
  get_inchan filename
  |> parse_stream
  |> Elastic_compiler.compile

let cmd =
  Command.basic
    ~summary: "RQL Compile - Compiles the given string to elasticsearch json"
    Command.Spec.(
      empty
      +> flag "-q" no_arg ~doc: "wraps output in a `query` object"
      +> anon (maybe_with_default "-" ("filename" %: file))
    )
    (fun use_query filename () ->
       let ast = compile filename in
       let out = match use_query with
       | true -> Elastic_compiler.with_query ast
       | false -> ast in
       out
       |> Elastic_compiler.to_string
       |> print_endline
    )

let () =
  Command.run ~version: "0.1" ~build_info:"beta1" cmd
