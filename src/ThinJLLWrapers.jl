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

Make sure that the `LD_LIBRARY_PATH` contains the path in `larget`, or a list
of paths.
"""
ensure_path(target::AbstractString) = in(
    target, split(ENV["LD_LIBRARY_PATH"], ":")
)
ensure_path(targets::Vector{T}) where T <:AbstractString = any(map(
    t->ensure_path(t), targets
))


"""
    ensure_jll_path()

Ensure that the list of paths specified in the `JLL_LIBRARY_PATH` environment
variable are inlcuded in the `LD_LIBRARY_PATH`.
"""
function ensure_jll_path()
    if in("JLL_LIBRARY_PATH", keys(ENV))
        return ensure_path(split(ENV["JLL_LIBRARY_PATH"], ":"))
    end
    return false
end

export open, ensure_path, ensure_jll_path

end # module
