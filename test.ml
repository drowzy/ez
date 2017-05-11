#directory "_build/src";;
#require "yojson" ;;
#load "lexer.cmo";;
#load "parser.cmo";;
#load "rql.cmo";;
#load "elastic_compiler.cmo";;
open Ast
open Rql
open Elastic_compiler
