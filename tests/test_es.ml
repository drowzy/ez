open OUnit

module Es = Ez.Es
module Ast = Ez.Ast

let compare_expr expr expected =
  let parsed = Ez.Es.from_ez expr in
  assert_equal parsed expected

let test_parse_ez_eq () = compare_expr (Ast.EQ (Ast.Var "foo", Ast.Int 10)) (Es.Term ("foo", Es.Int 10))
let test_parse_ez_in () = compare_expr (Ast.In (Ast.Var "foo", [Ast.Int 10])) (Es.Terms ("foo", [Es.Int 10]))
let test_parse_ez_and () = compare_expr
    (Ast.And
       (Ast.EQ (Ast.Var "foo", Ast.Int 10),
        Ast.EQ (Ast.Var "foo", Ast.Int 10))
    )
    (Bool
       (Es.Must [
           Es.Term ("foo", Es.Int 10);
           Es.Term ("foo", Es.Int 10)
         ]
       )
    )

let test_parse_ez_or () = compare_expr
    (Ast.Or
       (Ast.EQ (Ast.Var "foo", Ast.Int 10),
        Ast.EQ (Ast.Var "foo", Ast.Int 10))
    )
    (Es.Bool
       (Es.Should [
           Es.Term ("foo", Es.Int 10);
           Es.Term ("foo", Es.Int 10)
         ]
       )
    )

let test_parse_ez_not_eq () = compare_expr
    (Ast.Not
       (Ast.EQ
          (Ast.Var "foo", Ast.Int 10)
       )
    )
    (Es.Bool
      (Es.Must_not [
          Es.Term ("foo", Es.Int 10)
        ]
      )
    )

let test_parse_ez_lt () = compare_expr
    (Ast.LT
      (Ast.Var "foo", Ast.Int 10)
    )
    (Es.Range
       ("foo", "lt", Es.Int 10)
    )

let test_parse_ez_lteq () = compare_expr
    (Ast.LTEQ
      (Ast.Var "foo", Ast.Int 10)
    )
    (Es.Range
       ("foo", "lteq", Es.Int 10)
    )

let test_parse_ez_gt () = compare_expr
    (Ast.GT
      (Ast.Var "foo", Ast.Int 10)
    )
    (Es.Range
       ("foo", "gt", Es.Int 10)
    )

let test_parse_ez_gteq () = compare_expr
    (Ast.GTEQ
      (Ast.Var "foo", Ast.Int 10)
    )
    (Es.Range
       ("foo", "gteq", Es.Int 10)
    )

let test_parse_ez_scope () = compare_expr
    (Ast.Scope
       ("foo", (Ast.EQ
                  (Ast.Var "foo", Ast.Int 10)
               )
       )
    )
    (Es.Nested
       ("foo", Es.Term ("foo", Es.Int 10))
    )

let test_parse_ez_inline () = compare_expr
    (Ast.Inline
       (
         Ast.EQ (Ast.Var "foo", Ast.Int 10),
         Ast.EQ (Ast.Var "bar", Ast.Int 10)
       )
     )
     (Es.Adjecent
        (
          Es.Term ("foo", Es.Int 10),
          Es.Term ("bar", Es.Int 10)
        )
     )
let test_parse_ez_raw () = compare_expr (Ast.Raw "foo") (Es.Raw "foo")
let tests = "Syntax" >::: [
  "parse_eq" >:: test_parse_ez_eq;
  "parse_in" >:: test_parse_ez_in;
  "parse_and" >:: test_parse_ez_and;
  "parse_or" >:: test_parse_ez_or;
  "parse_not_eq" >:: test_parse_ez_not_eq;
  "parse_raw" >:: test_parse_ez_raw;
  "parse_lt" >:: test_parse_ez_lt;
  "parse_lteq" >:: test_parse_ez_lteq;
  "parse_gt" >:: test_parse_ez_gt;
  "parse_scope" >:: test_parse_ez_scope;
  "parse_inline" >:: test_parse_ez_inline;
]
