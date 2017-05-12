open Core.Std

let get_inchan = function
  | "-" -> In_channel.stdin
  | filename -> In_channel.create ~binary: true filename

(* compile ast to elastic json ast *)
let compile filename =
  get_inchan filename
  |> Rql_parser.from_channel
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
