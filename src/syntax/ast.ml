(* AST *)
open Core_kernel.Std

type label = string [@@deriving sexp]

type expr =
  | Var of string
  | Bool of bool
  | Int of int
  | Float of float
  | String of string
  | And of expr * expr
  | Or of expr * expr
  | In of expr * expr list
  | Not of expr
  | EQ of expr * expr
  | LT of expr * expr
  | GT of expr * expr
  | LTEQ of expr * expr
  | GTEQ of expr * expr
  | Scope of label * expr
  | Raw of string
[@@deriving sexp]

let pp_ast ast =
  ast
  |> sexp_of_expr
  |> Sexp.to_string_hum ~indent: 2

let to_string expr =
  Sexp.to_string (sexp_of_expr expr)
