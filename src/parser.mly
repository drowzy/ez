%{
open Ast
%}

%token <int> INT
%token <float> FLOAT
%token <bool> BOOL
%token <string> ID
%token <string> STRING

%token LPAREN RPAREN LBRACK RBRACK

%token TRUE
%token FALSE
%token EXCLAIMATION
%token EQ
%token NEQ
%token LT
%token GT
%token LTEQ
%token GTEQ
%token RAW

%token AND
%token OR
%token EOF

%left AND
%left OR

%nonassoc EQ
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
  | LPAREN expr RPAREN { $2 }
  | id = ID LBRACK e = expr RBRACK { Scope(id, e)}
  | RAW s = STRING { Raw(s) }
  | EXCLAIMATION expr { Not ($2) }
  | expr AND expr { And ($1, $3) }
  | expr OR expr { Or ($1, $3) }
  | expr EQ expr { EQ ($1, $3) }
  | expr NEQ expr { Not(EQ ($1, $3)) }
  | expr LT expr { LT ($1, $3) }
  | expr LTEQ expr { LTEQ ($1, $3) }
  | expr GT expr { GT ($1, $3) }
  | expr GTEQ expr { GTEQ ($1, $3) }
	;
