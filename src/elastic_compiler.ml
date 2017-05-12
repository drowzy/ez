open Yojson
open Ast

let bool_expr json =
  `Assoc[("bool", json)]

let with_query json =
  `Assoc[("query", json)]

let rec compile = function
  | Var i -> `String i
  | Int i -> `Int i
  | String s -> `String s
  | Bool b -> `Bool b
  | And(el, er) -> bool_expr (`Assoc[("must", `List[ (compile el); (compile er) ])])
  | Not(e) -> `Assoc[("must_not", compile e)]
  | EQ(Var el, er) -> `Assoc[ ("term", `Assoc[(el, compile er)])]

let to_string json =
  Yojson.Basic.pretty_to_string json
