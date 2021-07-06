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
    return lib_handle
end

open(lib_path) = open(lib_path, RTLD_LAZY | RTLD_DEEPBIND)


"""
    ensure_path(target::AbstractString)
    ensure_path(list_of_targets:Vector{T}) where T<:AbstractString

Make sure that the `LD_LIBRARY_PATH` contains the path in `larget`, or a list
of paths.
"""
ensure_path(target::AbstractString) = in(
    target, split(ENV["LD_LIBRARY_PATH"], ":")
)

ensure_path(targets::Vector{T}) where T<:AbstractString = any(map(
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
    return true
end


"""
    in_ldpath(file_name::AbstractString)
    in_ldpath(list_of_targets:Vector{T}) where T <: AbstractString

Checks if `file_name` is in `LD_LIBRARY_PATH`.

"""
function in_ldpath(file_name::AbstractString)
    for ld in split(ENV["LD_LIBRARY_PATH"], ":")
        if isfile(joinpath(ld, file_name))
            return true
        end
    end
    return false
end

in_ldpath(files::Vector{T}) where T<:AbstractString = all(map(
    t->in_ldpath(t), files
))

export open, ensure_path, ensure_jll_path, in_ldpath

end # module
