type t
(* parses a string to ast *)
val to_ast : string -> Ast.expr
(* from Ast to elastic dsl *)
val to_elastic : Ast.expr -> Yojson.Basic.json
(* Turns a target t to response obj *)
val to_response : t -> Ezjsonm.t
val create_target : expr:string -> debug:bool -> t
val from_req : Ezjsonm.value -> t
