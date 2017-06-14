FROM ocaml/opam:ubuntu-16.04_ocaml-4.04.0

ENV OPAM_PKGS ocamlfind ocamlbuild oasis core_kernel menhir cmdliner yojson ounit opium
USER opam
ENV TERM xterm

RUN opam config exec -- opam install $OPAM_PKGS

ADD . ez
RUN sudo chown -R opam.nogroup /home/opam/ez
WORKDIR /home/opam/ez

RUN opam config exec -- make configure
RUN opam config exec -- make

FROM ocaml/ocaml:alpine-3.4

COPY --from=0 /home/opam/ez/_build/src/compiler_service/ez_cs.native /ez_cs
ENTRYPOINT ["/ez_cs"]
