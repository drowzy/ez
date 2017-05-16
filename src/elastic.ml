open Yojson
open Ast

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
    | LT(Project (label, path), er) -> nested (`String label) (LT(Var path, er) |> compile)
    | GT(Var el, er) -> range el (`Assoc[("gt", compile er)])
    | GT(Project (label, path), er) -> nested (`String label) (GT(Var path, er) |> compile)
    | GTEQ(Var el, er) -> range el (`Assoc[("gteq", compile er)])
    | GTEQ(Project (label, path), er) -> nested (`String label) (GTEQ(Var path, er) |> compile)
    | LTEQ(Var el, er) -> range el (`Assoc[("lteq", compile er)])
    | LTEQ(Project (label, path), er) -> nested (`String label) (LTEQ(Var path, er) |> compile)

  and bool_expr json =
    `Assoc[("bool", json)]
  and range prop json =
    `Assoc[("range", `Assoc[(prop, json)])]
  and nested path json =
    `Assoc[("nested", `Assoc[("path", path); ("query", json)])]
end

let with_query json =
  `Assoc[("query", json)]

let to_string ?(pretty=false) json =
  match pretty with
  | false -> Yojson.Basic.to_string json
  | true -> Yojson.Basic.pretty_to_string json
