opam switch install ez_switch -A 4.04.0+mingw64c -y
opam pin add ez . --no-action -y
opam install ez --deps-only -y
sh deps.sh
