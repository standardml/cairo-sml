signature CAIRO =
sig
    val run_time_version : unit -> int
    val run_time_version_string : unit -> string
    val compile_time_version : unit -> int
    val compile_time_version_string : unit -> string
end
