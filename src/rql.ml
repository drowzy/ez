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
    ~summary:"
RRRRRRRRRRRRRRRRR        QQQQQQQQQ     LLLLLLLLLLL
R::::::::::::::::R     QQ:::::::::QQ   L:::::::::L
R::::::RRRRRR:::::R  QQ:::::::::::::QQ L:::::::::L
RR:::::R     R:::::RQ:::::::QQQ:::::::QLL:::::::LL
  R::::R     R:::::RQ::::::O   Q::::::Q  L:::::L
  R::::R     R:::::RQ:::::O     Q:::::Q  L:::::L
  R::::RRRRRR:::::R Q:::::O     Q:::::Q  L:::::L
  R:::::::::::::RR  Q:::::O     Q:::::Q  L:::::L
  R::::RRRRRR:::::R Q:::::O     Q:::::Q  L:::::L
  R::::R     R:::::RQ:::::O     Q:::::Q  L:::::L
  R::::R     R:::::RQ:::::O  QQQQ:::::Q  L:::::L
  R::::R     R:::::RQ::::::O Q::::::::Q  L:::::L         LLLLLL
RR:::::R     R:::::RQ:::::::QQ::::::::QLL:::::::LLLLLLLLL:::::L
R::::::R     R:::::R QQ::::::::::::::Q L::::::::::::::::::::::L
R::::::R     R:::::R   QQ:::::::::::Q  L::::::::::::::::::::::L
RRRRRRRR     RRRRRRR     QQQQQQQQ::::QQLLLLLLLLLLLLLLLLLLLLLLLL
                                 Q:::::Q
                                  QQQQQQ
    \nA less verbose dsl for elasticsearch
"
    Command.Spec.(
      empty
      +> flag "-q" no_arg ~doc: "Query Wraps output in a `query` object"
      +> flag "-d" no_arg ~doc: "Debug a `debug` json string with the original RQL query inlined in the JSON output"
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
