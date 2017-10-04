(* AST *)
open Core_kernel.Std

type label = string [@@deriving sexp]
type uid = string [@@deriving sexp] (* local id *)

type ty =
  | Bool of bool
  | Int of int
  | Float of float
  | String of string
  [@@deriving sexp]

type expr =
  | And of expr * expr
  | Or of expr * expr
  | In of uid * ty list
  | Inline of expr * expr
  | Not of expr
  | EQ of uid * ty
  | LT of uid * ty
  | GT of uid * ty
  | LTEQ of uid * ty
  | GTEQ of uid * ty
  | Scope of label * expr
  | Raw of string
[@@deriving sexp]

let pp_ast ast =
  ast
  |> sexp_of_expr
  |> Sexp.to_string_hum ~indent: 2

let pp_ast_value ast =
  ast |> sexp_of_ty |> Sexp.to_string_hum ~indent: 2

let to_string expr =
  Sexp.to_string (sexp_of_expr expr)
