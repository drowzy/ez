OCB_FLAGS = -use-ocamlfind -I src
OCB = 		ocamlbuild $(OCB_FLAGS)

all: 		native byte

clean:
			$(OCB) -clean

native: 	sanity
			$(OCB) rql.native

byte:		sanity
			$(OCB) rql.byte

profile: 	sanity
			$(OCB) -tag profile rql.native

debug: 		sanity
			$(OCB) -tag debug rql.byte

sanity:
			ocamlfind query core


.PHONY: 	all clean byte native profile debug sanity
