signature CAIRO =
sig
    (**
     * Get the Cairo runtime version as an integer
     *)
    val run_time_version : unit -> int

    (**
     * Get the Cairo runtime version as a string
     *)
    val run_time_version_string : unit -> string

    (**
     * Get the Cairo compile time version as an integer
     *)
    val compile_time_version : unit -> int

    (**
     * Get the Cairo compile time version as a string
     *)
    val compile_time_version_string : unit -> string
end
