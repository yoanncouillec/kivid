let rec string_of_table_aux table min max i = 
  if i < max then
    ((if Hashtbl.mem table i then
        (string_of_int i) ^ "->" ^ (Hashtbl.find table i)^";"
      else "") ^
       string_of_table_aux table min max (i + 1))
  else ""

let string_of_table table min max = 
  "["^(string_of_table_aux table min max 0)^"]"

let treat table = function
  | Service.Create (k,v) ->
     Table.add table k v
     (*Table.show table*)

let rec receive table inc =
  let msg = Marshal.from_channel inc in
  treat table msg ; 
  receive table inc

let rec accept server table = 
  let inc, outc = Service.accept_client server in
  try
    receive table inc 
  with End_of_file -> accept server table

let main = 
  let port = ref 26000 in
  let min = ref 0 in
  let max = ref 1000 in
  let size = ref 100 in
  let options =
    [
      ("--port", Arg.Set_int port, "port");
      ("--min", Arg.Set_int min, "min");
      ("--max", Arg.Set_int max, "max");
      ("--size", Arg.Set_int size, "size");
    (*("--conf", Arg.Set_string conf, "Configuration file");*)
    ] in
  Arg.parse options (fun _ -> ()) "Options:";
  let table = Table.create !size !min !max in
  let server = Service.create_server !port in
  accept server table
  