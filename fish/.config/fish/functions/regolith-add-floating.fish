
function regolith-add-floating --description "Float a window by default"
    if ! type -q regolith-look ;
        echo "It seems that regolith desktop is not installed. Cannot proceed."
        return 1
    end

    set floating_windows_file $HOME/.config/regolith2/i3/config.d/90-floating-windows
    if [ ! -f "$floating_windows_file" ];
        echo "Floating windows file $floating_windows_file does not exist."
        echo "If this is the correct path, create it with: touch $floating_windows_file"
        return 1
    end

    echo "Click on the window to make floating by default"
    set window_class (xprop WM_CLASS | cut -f 2 -d "=" | cut -f 2 -d ",")
    echo "for_window [class=$window_class] floating enable" >> ~/.config/regolith2/i3/config.d/90-floating-windows
    echo "Entry added to $floating_windows_file"
end
