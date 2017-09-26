type id = string

type number =
  | Float of float
  | Int of int

type value =
  | String of string
  | Bool of bool
  | Int of int
  | Float of float

type t =
  | Term of id * value
  | Terms of id * value list
  | Range of id * string * number
  | Bool of bool_expr
  | Nested of id * t
  | Raw of string
  | Adjecent of t * t list
and bool_expr =
  | Must of t list
  | Should of t list
  | Must_not of t list

val from_ez : Ast.expr -> t

val pp_ast : t -> string

val to_json_ast : t -> Yojson.Basic.json

val to_string : t -> string

val wrap_json : string -> Yojson.Basic.json -> Yojson.Basic.json

val json_to_string : Yojson.Basic.json -> string
