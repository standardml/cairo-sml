structure Test =
struct

fun run () =
    (print ("run: " ^ Int.toString (Cairo.run_time_version ()) ^ "\n");
     print ("run: " ^ Cairo.run_time_version_string () ^ "\n");
     print ("comp: " ^ Int.toString (Cairo.compile_time_version ()) ^ "\n");
     print ("comp: " ^ Cairo.compile_time_version_string () ^ "\n"))

end
