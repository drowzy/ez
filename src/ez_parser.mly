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
%token INLINE
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
%left INLINE

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

ty:
  | i = INT { Int i }
  | f = FLOAT { Float f }
  | s = STRING { String s }
  | b = BOOL { Bool b }
  | TRUE { Bool true }
  | FALSE { Bool false}

expr:
  | LPAREN; e = expr RPAREN { e }
  | id = ID LBRACE e = expr RBRACE { Scope(id, e) }
  | RAW s = STRING { Raw(s) }
  | EXCLAIMATION; e = expr { Not (e) }
  | e = ID; IN; LBRACK; vl = separated_list(COMMA, ty); RBRACK { In (e, vl) }
  | el = expr; INLINE; e_list = expr { Inline (el, e_list) }
  | el = expr; AND; er = expr { And (el, er) }
  | el = expr; OR; er = expr { Or (el, er) }
  | el = ID; EQ; er = ty { EQ (el, er) }
  | el = ID; NEQ; er = ty { Not(EQ (el, er)) }
  | el = ID; LT; er = ty { LT (el, er) }
  | el = ID; LTEQ; er = ty { LTEQ (el, er) }
  | el = ID; GT; er = ty { GT (el, er) }
  | el = ID; GTEQ; er = ty { GTEQ (el, er) }
	;
