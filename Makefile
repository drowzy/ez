OCB_FLAGS = -use-ocamlfind -I src
OCB = 		ocamlbuild $(OCB_FLAGS)

all: 		native byte

clean:
			$(OCB) -clean

native: 	sanity
			$(OCB) ez.native

byte:		sanity
			$(OCB) ez.byte

profile: 	sanity
			$(OCB) -tag profile ez.native

debug: 		sanity
			$(OCB) -tag debug ez.byte

sanity:
			ocamlfind query core


.PHONY: 	all clean byte native profile debug sanity
