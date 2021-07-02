module ThinJLLWrapers

using Base.Libc.Libdl


"""
    open(lib_path, load_flags)
    open(lib_path)

Load the shared library stored in `lib_path` using the `load_flags`. If
`load_flags` are not supplied, default to  `load_flags = RTLD_LAZY |
RTLD_DEEPBIND`.
"""
function open(lib_path, load_flags)
    lib_handle = dlopen(lib_path, load_flags)
end

open(lib_path) = open(lib_path, RTLD_LAZY | RTLD_DEEPBIND)


"""
    ensure_path(target::String)
    ensure_path(list_of_targets:Vector{String})


"""
ensure_path(target::String) = in(target, split(ENV["LD_LIBRARY_PATH"]))
ensure_path(targets::Vector{String}) = any(
   map(target->in(target, split(ENV["LD_LIBRARY_PATH"])), targets)
)


export open

end # module
