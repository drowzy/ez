type t = {
  expr: Ez.Ast.expr;
  debug: bool
}
(* parses a string to ast *)
val to_ast : string -> Ez.Ast.expr
(* from Ast to elastic dsl *)
val to_elastic : Ez.Ast.expr -> Ez.Es.t
(* Turns a target t to response obj *)
val to_response : t -> Ezjsonm.t
val create_target : expr:string -> debug:bool -> t
val from_req : Ezjsonm.value -> t
