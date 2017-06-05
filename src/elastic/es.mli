type id = string

type value =
  | String of string
  | Bool of bool
  | Int of int
  | Float of float

type t =
  | Term of id * value
  | Bool of bool_expr
  | Nested of id * t
  | Raw of string
and bool_expr =
  | Must of t list
  | Should of t list
  | Must_not of t list

val from_ez : Ast.expr -> t

val pp_ast : t -> string

val to_json_ast : t -> Yojson.Basic.json

val to_json_string : t ->  string
