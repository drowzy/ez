open Opium.Std
open Lwt.Infix

let is_json s = s |> String.lowercase_ascii |> String.equal "application/json"

let query_params req = req |> Request.uri |> Uri.query

let add_cors_header headers =
  Cohttp.Header.add_list headers [
    ("access-control-allow-origin", "*");
    ("access-control-allow-headers", "Accept, Content-Type");
    ("access-control-allow-methods", "GET, HEAD, POST, DELETE, OPTIONS, PUT, PATCH")
  ]

let allow_cors =
  let filter handler req =
    handler req >|= fun res ->
    res
    |> Response.headers
    |> add_cors_header
    |> Fieldslib.Field.fset Response.Fields.headers res
  in
  Rock.Middleware.create ~name:"allow_cors" ~filter

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

let proxy = put "/proxy/:url" begin fun req ->
   App.json_of_body_exn req >>= fun json ->
     let target  = json |> Ezjsonm.value |> Ez_target.from_req in
     let uri  = "http://" ^ (param req "url") ^ "/_search" |> Uri.of_string in
     let req_body = Ez_target.(target.expr)
                    |> Ez_target.to_elastic
                    |> Es.to_json_ast
                    |> Es.wrap_json "query"
                    |> Es.json_to_string
                    |> Cohttp_lwt_body.of_string in

     Cohttp_lwt_unix.Client.post ~body:req_body uri >>= fun (resp, res_body) ->
     res_body |> Cohttp_lwt_body.to_string >|= fun res ->
     `String res |> Opium.Std.respond
end

let _ =
  App.empty
  |> middleware Ez_log.req_log
  |> middleware allow_cors
  |> compile
  |> proxy
  |> App.run_command
