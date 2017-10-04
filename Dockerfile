FROM ocaml/opam:ubuntu-16.04_ocaml-4.04.0

ENV OPAM_PKGS ocamlfind ocamlbuild jbuilder core_kernel menhir cmdliner yojson ounit opium
USER opam
ENV TERM xterm

RUN opam config exec -- opam update
RUN opam config exec -- opam depext -i $OPAM_PKGS

ADD . ez
RUN sudo chown -R opam.nogroup /home/opam/ez
WORKDIR /home/opam/ez

RUN opam config exec -- make

FROM ocaml/ocaml:ubuntu-16.04

COPY --from=0 /home/opam/ez/_build/default/bin/compiler_service/ez_cs.exe /ez_cs.exe
RUN chmod +x /ez_cs.exe
EXPOSE 3000
ENTRYPOINT ["/ez_cs.exe"]
CMD ["-v"]
