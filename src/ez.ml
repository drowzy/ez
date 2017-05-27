module Std = Core_kernel.Std

let get_inchan = function
  | "-" -> Std.In_channel.stdin |> Std.In_channel.input_all
  | filename ->
    match Sys.file_exists filename with
    | true -> Std.In_channel.create ~binary: true filename |> Std.In_channel.input_all
    | false -> filename

let maybe_append_query use_query ast =
  match use_query with
  | true -> Compiler.with_query ast
  | false -> ast

let compile str =
  str
  |> Lexing.from_string
  |> Parser.prog Lexer.read
  |> Compiler.compile

let ez_cli filename has_query debug =
  let str = get_inchan filename in
  let ast = compile str |> maybe_append_query has_query in
  let res = match debug with
    | true -> `Assoc[("ez", `String str); ("elastic", ast)]
    | false -> ast in
  res
  |> Compiler.to_string ~pretty: true
  |> print_endline

(* Command line interface *)

open Cmdliner

let input =
  let doc = "Input, stdin, file or string" in
  Arg.(value & pos 0 string "-" & info [] ~docv:"FILE" ~doc)

let use_query =
  let doc = "Wraps output in a `query` object" in
  Arg.(value & flag & info ["q"; "query"] ~docv: "QUERY" ~doc)

let debug =
  let doc = "a `debug` json string with the original Ez query inlined in the JSON output" in
  Arg.(value & flag & info ["d"; "debug"] ~docv: "DEBUG" ~doc)

let ez_t = Term.(const ez_cli $ input $ use_query $ debug)

let info =
  let doc = "A less verbose dsl for elasticsearch" in
  let man = [
    `S Manpage.s_bugs;
    `P "Email bug reports to <hehey at example.org>." ]
  in
  Term.info "ez" ~version:"%%VERSION%%" ~doc ~exits:Term.default_exits ~man

let () = Term.exit @@ Term.eval (ez_t, info)
