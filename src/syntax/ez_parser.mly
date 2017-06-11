%{
open Ast
%}

%token <int> INT
%token <float> FLOAT
%token <bool> BOOL
%token <string> ID
%token <string> STRING

%token LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE

%token TRUE
%token FALSE
%token EXCLAIMATION
%token COMMA
%token EQ
%token NEQ
%token LT
%token GT
%token LTEQ
%token GTEQ
%token RAW

%token IN
%token AND
%token OR
%token EOF

%left AND
%left OR

%nonassoc EQ
%nonassoc IN
%nonassoc NEQ

%nonassoc GT LT LTEQ GTEQ
%left EXCLAIMATION

%start <Ast.expr> prog
%%

prog:
  | e = expr; EOF { e }
	;

expr:
  | i = INT { Int i }
  | x = ID { Var x }
  | f = FLOAT { Float f }
  | s = STRING { String s }
  | b = BOOL { Bool b }
  | TRUE { Bool true }
  | FALSE { Bool false}
  | LPAREN; e = expr RPAREN { e }
  | id = ID LBRACK e = expr RBRACK { Scope(id, e) }
  | RAW s = STRING { Raw(s) }
  | EXCLAIMATION; e = expr { Not (e) }
  | e = expr; IN; LBRACE; vl = separated_list(COMMA, expr); RBRACE { In (e, vl) }
  | el = expr; AND; er = expr { And (el, er) }
  | el = expr; OR; er = expr { Or (el, er) }
  | el = expr; EQ; er = expr { EQ (el, er) }
  | el = expr; NEQ; er = expr { Not(EQ (el, er)) }
  | el = expr; LT; er = expr { LT (el, er) }
  | el = expr; LTEQ; er = expr { LTEQ (el, er) }
  | el = expr; GT; er = expr { GT (el, er) }
  | el = expr; GTEQ; er = expr { GTEQ (el, er) }
	;
