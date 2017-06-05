#directory "_build/src/syntax";;
#directory "_build/src/elastic";;
#require "yojson" ;;
#require "core_kernel";;
#load "ast.cmo";;
#load "compiler.cmo";;
#load "ez_parser.cmo";;
#load "ez_lexer.cmo";;
open Ast
open Compiler
