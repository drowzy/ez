opam switch install ez_switch -A 4.04.1
opam pin add ez . --no-action
opam install ez --deps-only
sh deps.sh
