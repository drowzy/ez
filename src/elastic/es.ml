open Core_kernel.Std
open Ast

exception SyntaxError of string
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
  | Range of id * string * number
  | Bool of bool_expr
  | Nested of id * t
  | Raw of string
  [@@deriving sexp]

and bool_expr =
  | Must of t list
  | Should of t list
  | Must_not of t list
  [@@deriving sexp]

let rec from_ez = function
  | And (expr_l, expr_r) -> Bool (Must [from_ez expr_l; from_ez expr_r])
  | Or (expr_l, expr_r) -> Bool (Should [from_ez expr_l; from_ez expr_r])
  | EQ (Var i, expr_r) -> Term (i, to_value expr_r)
  | LT (Var i, expr_r) -> Range (i, "lt", to_number expr_r)
  | GT (Var i, expr_r) -> Range (i, "gt", to_number expr_r)
  | LTEQ (Var i, expr_r) -> Range (i, "lteq", to_number expr_r)
  | GTEQ (Var i, expr_r) -> Range (i, "gteq", to_number expr_r)
  | Scope (i, expr_r) -> Nested (i, from_ez expr_r)
  | Raw (json_str) -> Raw json_str
  | value -> raise (SyntaxError ("Unsupported value: " ^ Ast.debug_str_of_expr value))

and to_value = function
  | Ast.String s -> String s
  | Ast.Bool b -> Bool b
  | Ast.Int i -> Int i
  | Ast.Float f -> Float f
  | value -> raise (SyntaxError ("Unsupported value: " ^ Ast.debug_str_of_expr value))

and to_number = function
  | Ast.Int i -> Int i
  | Ast.Float f -> Float f
  | value -> raise (SyntaxError ("Unsupported value: " ^ Ast.debug_str_of_expr value))
