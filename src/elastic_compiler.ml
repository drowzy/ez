open Yojson
open Ast

let rec compile = function
  | Var i -> `String i
  | Int i -> `Int i
  | String s -> `String s
  | Bool b -> `Bool b
  | And(el, er) -> `Assoc[("must", `List[ (compile el); (compile er) ])]
  | EQ(Var el, er) -> `Assoc[ ("term", `Assoc[(el, compile er)])]

let with_query json =
  `Assoc[("query", json)]

let to_string json =
  Yojson.Basic.pretty_to_string json
