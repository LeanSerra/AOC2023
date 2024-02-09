open Printf

let read_file filename = 
  let lines = ref[] in
  let chan = open_in filename in
  try
    while true; do
      lines:= input_line chan :: !lines
    done; !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines ;;

let list = read_file "smallinput";;
List.iter print_endline list;;