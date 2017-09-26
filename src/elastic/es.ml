open Yojson
open Core_kernel.Std
open Ast

exception UnsupportedError of string

type id = string [@@deriving sexp]

type number =
  | Float of float
  | Int of int
  [@@deriving sexp]

type value =
  | String of string
  | Bool of bool
  | Int of int
  | Float of float
  [@@deriving sexp]

type t =
  | Term of id * value
  | Terms of id * value list
  | Range of id * string * number
  | Bool of bool_expr
  | Nested of id * t
  | Raw of string
  | Adjecent of t * t list
  [@@deriving sexp]

and bool_expr =
  | Must of t list
  | Should of t list
  | Must_not of t list
  [@@deriving sexp]

let rec from_ez = function
  | And (expr_l, expr_r) -> Bool (Must [from_ez expr_l; from_ez expr_r])
  | Or (expr_l, expr_r) -> Bool (Should [from_ez expr_l; from_ez expr_r])
  | EQ (Var id, expr_r) -> Term (id, to_value expr_r)
  | LT (Var id, expr_r) -> Range (id, "lt", to_number expr_r)
  | GT (Var i, expr_r) -> Range (i, "gt", to_number expr_r)
  | LTEQ (Var i, expr_r) -> Range (i, "lteq", to_number expr_r)
  | GTEQ (Var i, expr_r) -> Range (i, "gteq", to_number expr_r)
  | Scope (i, expr_r) -> Nested (i, from_ez expr_r)
  | Raw (json_str) -> Raw json_str
  | Not (expr) -> Bool (Must_not [from_ez expr])
  | In (Var id, vl) -> Terms (id, List.map ~f:to_value vl)
  | Inline(expr_l, expr_r) -> Adjecent (from_ez expr_l, List.map ~f:from_ez expr_r)
  | value -> raise (UnsupportedError ("Unsupported value: " ^ Ast.pp_ast value))

and to_value = function
  | Ast.String s -> String s
  | Ast.Bool b -> Bool b
  | Ast.Int i -> Int i
  | Ast.Float f -> Float f
  | value -> raise (UnsupportedError ("Unsupported value: " ^ Ast.pp_ast value))

and to_number = function
  | Ast.Int i -> Int i
  | Ast.Float f -> Float f
  | value -> raise (UnsupportedError ("Unsupported value: " ^ Ast.pp_ast value))

let rec (to_json_ast : t -> Yojson.Basic.json) = function
  | Term (id, value) ->
    `Assoc [
      "term", `Assoc [
        id, to_json_ast_value value
      ]
    ]
  | Terms (id, vl) ->
    `Assoc [
      "terms", `Assoc [
        id, `List (List.map ~f:to_json_ast_value vl)
      ]
    ]
  | Bool expr -> to_json_ast_bool expr
  | Range (id, typename, range) ->
    `Assoc [
      "range", `Assoc [
        id, `Assoc [
          typename, to_json_ast_number range
        ]
      ]
    ]
  | Nested (id, expr) ->
    `Assoc [
      "nested", `Assoc [
        "path", `String id;
        "query", to_json_ast expr;
      ]
    ]
  | Raw json_str -> Yojson.Basic.from_string json_str
  | Adjecent (expr_l, expr_r) -> Yojson.Basic.Util.combine (to_json_ast expr_l) (`List (List.map ~f:to_json_ast expr_r))
and to_json_ast_bool expr =
  let bool_expr = match expr with
  | Must list_t -> ("must", list_t)
  | Should list_t  -> ("should", list_t)
  | Must_not list_t  -> ("must_not", list_t) in
  let exprs = match bool_expr with
    | (_, []) -> `List ([])
    | (_, h :: []) -> to_json_ast h
    | (_, h :: tl) -> `List (List.map ~f:to_json_ast ([h] @ tl) ) in
  `Assoc [
    "bool", `Assoc [
      fst bool_expr,
      exprs
    ]
  ]

and to_json_ast_value = function
  | String s -> `String s
  | Bool b -> `Bool b
  | Int i -> `Int i
  | Float f -> `Float f

and (to_json_ast_number : number -> Yojson.Basic.json) = function
  | Int i -> `Int i
  | Float f -> `Float f

let pp_ast ast =
  ast
  |> sexp_of_t
  |> Sexp.to_string_hum ~indent: 2

let to_string ast =
  ast
  |> to_json_ast
  |> Yojson.Basic.to_string

let json_to_string json =
  Yojson.Basic.pretty_to_string json

let wrap_json str json =
  `Assoc [str, json]
