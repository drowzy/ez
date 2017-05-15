open Core.Std
open Yojson

let get_inchan = function
  | "-" -> In_channel.stdin
  | filename -> In_channel.create ~binary: true filename

(* compile ast to elastic json ast *)
let compile str =
  str
  |> Rql_parser.from_string
  |> Elastic.Compiler.compile

let maybe_append_query use_query ast =
  match use_query with
  | true -> Elastic.with_query ast
  | false -> ast

let cmd =
  Command.basic
    ~summary: "RQL Compile - Compiles the given string to elasticsearch json"
    Command.Spec.(
      empty
      +> flag "-q" no_arg ~doc: "wraps output in a `query` object"
      +> flag "-d" no_arg ~doc: "Returns a `debug` json string with the original RQL query inlined in the JSON output"
      +> anon (maybe_with_default "-" ("filename" %: file))
    )
    (fun use_query debug filename () ->
       let str = get_inchan filename |> In_channel.input_all in
       let ast = compile str |> maybe_append_query use_query in
       let res = match debug with
         | true -> `Assoc[("rql", `String str); ("elastic", ast)]
         | false -> ast in
       res
       |> Elastic.to_string ~pretty: true
       |> print_endline
    )

let () =
  Command.run ~version: "0.1" ~build_info:"beta1" cmd
