(* AST *)
type label = string
type expr =
  | Var of string
  | Bool of bool
  | Int of int
  | Float of float
  | String of string
  | And of expr * expr
  | Or of expr * expr
  | Not of expr
  | EQ of expr * expr
  | LT of expr * expr
  | GT of expr * expr
  | LTEQ of expr * expr
  | GTEQ of expr * expr
  | Project of label * label
  | Scope of label * expr
