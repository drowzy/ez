open Opium.Std
open Lwt.Infix

(* TODO this is used like everywhere maybe its own lib instead of exposing everything everywhere? *)
let ez_compile str =
  str
  |> Lexing.from_string
  |> Ez_parser.prog Ez_lexer.read
  |> Compiler.compile
  |> Compiler.with_query
  |> Compiler.to_string

let compile = put "/compile" begin fun req ->
    req
    |> App.string_of_body_exn >>= fun res ->
    `Json (Ezjsonm.from_string (ez_compile res)) |> respond'
end

let _ =
  App.empty
  |> middleware Ez_log.req_log
  |> compile
  |> App.run_command
