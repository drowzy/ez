open Opium_kernel.Rock
open Lwt.Infix

let get_status_code res =
  res
  |> Response.code
  |> Cohttp.Code.code_of_status

let get_method req =
  req
  |> Request.meth
  |> Cohttp.Code.string_of_method

let format_error req res =
  let code = get_status_code res in
  let meth = get_method req in
  let path = req |> Request.uri |> Uri.to_string in

  Lwt_log.ign_info_f "%s [%d] %s" meth code path

let req_log =
  let filter handler req =
    handler req >|= fun res ->
    format_error req res;
    res
  in
  Middleware.create ~name:"Request_log" ~filter
