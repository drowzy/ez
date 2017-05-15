open Yojson
open Ast

let bool_expr json =
  `Assoc[("bool", json)]

let nested path query=
`Assoc[("nested", `Assoc[("path", path); ("query", query)])]
let with_query json =
  `Assoc[("query", json)]

let rec compile = function
  | Var i -> `String i
  | Int i -> `Int i
  | String s -> `String s
  | Bool b -> `Bool b
  | And(el, er) -> bool_expr (`Assoc[("must", `List[ (compile el); (compile er) ])])
  | Or (el, er) -> bool_expr (`Assoc[("should", `List[ (compile el); (compile er) ])])
  | Not(e) -> bool_expr (`Assoc[("must_not", compile e)])
  | EQ(Var el, er) -> `Assoc[("term", `Assoc[(el, compile er)])]
  | EQ(Project(label, path), er) -> nested (`String label) (EQ(Var path, er) |> compile)

let to_string json =
  Yojson.Basic.to_string json

let to_string_pretty json =
  Yojson.Basic.pretty_to_string json
