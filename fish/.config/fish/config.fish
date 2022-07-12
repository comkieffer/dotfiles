
# Add common excutable paths to $PATH
fish_add_path ~/.local/bin/

# Common Abbreviations
abbr --add jrnl " jrnl"  # Make hisotry ignore calls to `jrnl`

function regolith-add-floating
    echo "Click on the window  to make floating by default"
    set window_class (xprop WM_CLASS | cut -f 2 -d "=" | cut -f 2 -d ",")
    echo "for_window [class=$window_class] floating enable" >> ~/.config/regolith2/i3/config.d/90-floating-windows

end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
