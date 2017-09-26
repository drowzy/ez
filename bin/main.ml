(* module Std = Core_kernel.Std
 *
 * let get_inchan = function
 *   | "-" -> Std.In_channel.stdin |> Std.In_channel.input_all
 *   | filename ->
 *     match Sys.file_exists filename with
 *     | true -> Std.In_channel.create ~binary: true filename |> Std.In_channel.input_all
 *     | false -> filename
 *
 * let maybe_append_query use_query ast =
 *   match use_query with
 *   | true -> Es.wrap_json "query" ast
 *   | false -> ast
 *
 * let compile str =
 *   str
 *   |> Lexing.from_string
 *   |> Ez_parser.prog Ez_lexer.read
 *   |> Es.from_ez
 *   |> Es.to_json_ast
 *
 * let ez_cli filename has_query debug =
 *   let str = get_inchan filename in
 *   let ast = compile str |> maybe_append_query has_query in
 *   let res = match debug with
 *     | true -> `Assoc [
 *         "ez", `String str;
 *         "elastic", ast
 *       ]
 *     | false -> ast in
 *   res
 *   |> Es.json_to_string
 *   |> print_endline
 *
 * (\* Command line interface *\)
 *
 * open Cmdliner
 *
 * let input =
 *   Arg.(
 *     value &
 *     pos 0 string "-" &
 *     info [] ~docv:"FILE" ~doc: "Input, stdin, file or string"
 *   )
 *
 * let use_query =
 *   Arg.(
 *     value &
 *     flag &
 *     info ["q"; "query"] ~docv: "QUERY" ~doc: "Wraps output in a `query` object"
 *   )
 *
 * let debug =
 *   Arg.(
 *     value &
 *     flag &
 *     info ["d"; "debug"] ~docv: "DEBUG" ~doc: "Inlines the original Ez query in JSON output"
 *   )
 *
 * let ez_t = Term.(const ez_cli $ input $ use_query $ debug)
 *
 * let info =
 *   let doc = "A less verbose dsl for elasticsearch" in
 *   let man = [
 *     `S Manpage.s_bugs;
 *     `P "No bugs present, only unintended features" ]
 *   in
 *   Term.info "ez" ~version:"%%VERSION%%" ~doc ~exits:Term.default_exits ~man
 *
 * let () = Term.exit @@ Term.eval (ez_t, info) *)

let () =
  ()
