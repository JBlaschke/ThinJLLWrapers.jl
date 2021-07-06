module ThinJLLWrapers

using Base.Libc.Libdl


"""
    jll_open(lib_path, load_flags)
    jll_open(lib_path)

Load the shared library stored in `lib_path` using the `load_flags`. If
`load_flags` are not supplied, default to  `load_flags = RTLD_LAZY |
RTLD_DEEPBIND`.
"""
function jll_open(lib_path, load_flags)
    lib_handle = dlopen(lib_path, load_flags)
    return lib_handle
end

jll_open(lib_path) = jll_open(lib_path, RTLD_LAZY | RTLD_DEEPBIND)


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
    return false
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


"""
    find_path(file_name::AbstractString)

Find the path of `file_name` is in `JLL_LIBRARY_PATH`.

"""
function find_path(file_name::AbstractString)
    for ld in split(ENV["JLL_LIBRARY_PATH"], ":")
        lib_path = joinpath(ld, file_name)
        if isfile(lib_path)
            return lib_path
        end
    end
    return nothing
end



export jll_open, ensure_path, ensure_jll_path, in_ldpath, find_path

end # module
