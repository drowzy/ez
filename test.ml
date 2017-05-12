#directory "_build/src";;
#require "yojson" ;;
#require "core";;
#load "lexer.cmo";;
#load "parser.cmo";;
#load "elastic_compiler.cmo";;
#load "rql_parser.cmo";;
open Ast
open Elastic_compiler
