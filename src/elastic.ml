open Yojson
open Ast

let bool_expr json = `Assoc[("bool", json)]
let range prop json = `Assoc[("range", `Assoc[(prop, json)])]
let nested path json = `Assoc[("nested", `Assoc[("path", path); ("query", json)])]
let with_query json = `Assoc[("query", json)]

module Compiler = struct
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
    | LT(Var el, er) -> range el (`Assoc[("lt", compile er)])
    | GT(Var el, er) -> range el (`Assoc[("gt", compile er)])
end

let to_string ?(pretty=false) json =
  match pretty with
  | false -> Yojson.Basic.to_string json
  | true -> Yojson.Basic.pretty_to_string json
