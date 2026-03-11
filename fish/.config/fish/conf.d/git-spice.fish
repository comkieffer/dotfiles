
# If git-spice (gs) is installed, then install completions.

if type -q gs
    eval"$("gs shell completion fish")
end
