open OUnit
open Ez.Ast

let parse_expr expr =
  expr
  |> Lexing.from_string
  |> Ez.Parser.prog Ez.Lexer.read

let compare_expr expr expected =
  let parsed = parse_expr expr in
  assert_equal parsed expected

let test_parse_and () = compare_expr "foo == 10 and bar == 5" (And ((EQ ("foo", Int 10)), (EQ ("bar", Int 5))))
let test_parse_or () = compare_expr "foo == 10 or bar == 5" (Or ((EQ ("foo", Int 10)), (EQ ("bar", Int 5))))
let test_parse_not () = compare_expr "foo != 10" (Not (EQ ("foo", Int 10)))
let test_parse_lteq () = compare_expr "foo <= 10" (LTEQ ("foo", Int 10))
let test_parse_gteq () = compare_expr "foo >= 10" (GTEQ ("foo", Int 10))
let test_parse_scope () = compare_expr "foo { foo.bar == 10 }" (Scope ("foo", (EQ("foo.bar", Int 10))))
let test_parse_nested_scope () = compare_expr "foo { foo.bar { foo.bar.baz == 10}}" (Scope ("foo", (Scope ("foo.bar", EQ("foo.bar.baz", Int 10)))))
let test_parse_in () = compare_expr "foo in [10]" (In ("foo", [Int 10]))

let test_parse_inline () = compare_expr "foo == 10 <- foo == 20" (Inline (EQ ("foo", Int 10), (EQ ("foo", Int 20))))

let tests = "Syntax" >::: [
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
