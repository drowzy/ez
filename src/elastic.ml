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
    | LT(Var el, er) -> range el (`Assoc[("lt", compile er)])
    | GT(Var el, er) -> range el (`Assoc[("gt", compile er)])
    | GTEQ(Var el, er) -> range el (`Assoc[("gteq", compile er)])
    | LTEQ(Var el, er) -> range el (`Assoc[("lteq", compile er)])
    | Scope(el, er) -> nested (`String el) (compile er)

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
