type index = int
type data = string

type operation = 
  | Create of index * data

let create_server port = 
  (*let addr = (Unix.gethostbyname(Unix.gethostname())).Unix.h_addr_list.(0) in*)
  (*let addr = Unix.gethostbyname "192.168.1.83" in*)
  let addr = Unix.inet_addr_any in
  let saddr = Unix.ADDR_INET(addr,port) in
  let socket = Unix.socket (Unix.domain_of_sockaddr saddr) Unix.SOCK_STREAM 0 in
   Unix.bind socket saddr ;
   Unix.listen socket 100 ;
   socket

let accept_client socket =   
  let client = Unix.accept socket in
  let channels = fst client in
  (Unix.in_channel_of_descr channels, Unix.out_channel_of_descr channels)

let connect_to_server hostname port = 
  let socket = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
  let address = Unix.inet_addr_of_string hostname in 
  Unix.connect socket (Unix.ADDR_INET(address, port));
  (Unix.in_channel_of_descr socket, Unix.out_channel_of_descr socket)

let send outc msg =
  Marshal.to_channel outc msg [] ;
  flush outc

