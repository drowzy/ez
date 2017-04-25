open Yojson
open Ast

let extract_value = function
  | Var i -> i
  | _ -> failwith "Unsupported"

let compile = function
  | EQ(Var el, Int er) -> `Assoc[ ("term", `Assoc[(el, `Int er)])]
  | _ -> failwith "Unsupported for now"

let to_string json =
  Yojson.Basic.pretty_to_string json
