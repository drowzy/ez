open Core.Std

let main () =
  let argv = Array.to_list Sys.argv in
  let args = List.tl_exn argv in
  match args with
  | []        -> Printf.printf "Hello, world!\n"
  | names     -> Printf.printf "Hello, %s!\n" (String.concat ~sep:"\n" names)

let () = main ()
