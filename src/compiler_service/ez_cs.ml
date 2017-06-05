open Opium.Std
open Lwt.Infix

let is_json s = s |> String.lowercase_ascii |> String.equal "application/json"

let compile = put "/compile" begin fun req ->
    match Cohttp.Header.get (Request.headers req) "content-type" with
    | Some s when is_json s -> App.json_of_body_exn req >>= fun json ->
      `Json (
        json
        |> Ezjsonm.value
        |> Ez_target.from_req
        |> Ez_target.to_response
      )
      |> respond'
    | _ -> req |> App.string_of_body_exn >>= fun res ->
      let target = Ez_target.create_target ~expr:res ~debug:false in
      `Json (Ez_target.to_response target) |> respond'
end

let _ =
  App.empty
  |> middleware Ez_log.req_log
  |> compile
  |> App.run_command
