open OUnit
open Ast

let parse_expr expr =
  expr
  |> Lexing.from_string
  |> Ez_parser.prog Ez_lexer.read

let compare_expr expr expected =
  let parsed = parse_expr expr in
  assert_equal parsed expected

let test_parse_var () = compare_expr "foo" (Var "foo")
let test_parse_bool () = compare_expr "true" (Bool true)
let test_parse_int () = compare_expr "1" (Int 1)
let test_parse_string () = compare_expr "\"foo\"" (String "foo")
let test_parse_and () = compare_expr "foo == 10 and bar == 5" (And ((EQ (Var "foo", Int 10)), (EQ (Var "bar", Int 5))))
let test_parse_or () = compare_expr "foo == 10 or bar == 5" (Or ((EQ (Var "foo", Int 10)), (EQ (Var "bar", Int 5))))
let test_parse_not () = compare_expr "foo != 10" (Not (EQ (Var "foo", Int 10)))
let test_parse_lteq () = compare_expr "foo <= 10" (LTEQ (Var "foo", Int 10))
let test_parse_gteq () = compare_expr "foo >= 10" (GTEQ (Var "foo", Int 10))
let test_parse_scope () = compare_expr "foo { foo.bar == 10 }" (Scope ("foo", (EQ(Var "foo.bar", Int 10))))
let test_parse_nested_scope () = compare_expr "foo { foo.bar { foo.bar.baz == 10}}" (Scope ("foo", (Scope ("foo.bar", EQ(Var "foo.bar.baz", Int 10)))))
let test_parse_in () = compare_expr "foo in [10]" (In (Var "foo", [Int 10]))

let test_parse_inline () = compare_expr "foo == 10 <- foo == 20" (Inline (EQ (Var "foo", Int 10), [(EQ (Var "foo", Int 20))]))

let tests = "Syntax" >::: [
  "parse_id" >:: test_parse_var;
  "parse_bool" >:: test_parse_bool;
  "parse_int" >:: test_parse_int;
  "parse_string" >:: test_parse_string;
  "parse_and" >:: test_parse_and;
  "parse_or" >:: test_parse_or;
  "parse_not_eq" >:: test_parse_or;
  "parse_lteq" >:: test_parse_lteq;
  "parse_gteq" >:: test_parse_gteq;
  "parse_scope" >:: test_parse_scope;
  "parse_nested_scope" >:: test_parse_nested_scope;
  "parse_in_op" >:: test_parse_in;
  "parse_inline_op" >:: test_parse_inline;
]
