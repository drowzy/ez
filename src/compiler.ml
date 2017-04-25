open Yojson
open Ast

let extract_value = function
  | Var i -> i
  | _ -> failwith "Unsupported"

let rec compile = function
  | Var i -> `String i
  | Int i -> `Int i
  | String s -> `String s
  | Bool b -> `Bool b
  | And(el, er) -> `Assoc[("must", `List[ (compile el); (compile er) ])]
  | EQ(Var el, er) -> `Assoc[ ("term", `Assoc[(el, compile er)])]

let to_string json =
  Yojson.Basic.pretty_to_string json
