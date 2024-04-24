function meeting --description 'Create a new jrnl entry for a meeting'
    argparse p/project= -- $argv

    # The meeting name is all of the un-consumed arguments
    set meeting_name (string join " " $argv)

    if not string length -q $meeting_name
        read --local --prompt-str="What is the name of the meeting ? " meeting_name
    end

    set -l timew_args "#meeting"

    if not set -ql $_flag_project
        set -a timew_args "#project:$_flag_project"
    end

    if type -q timew
        echo "starting meeting: timew '$meeting_name' $timew_args"
        timew start "$meeting_name" $timew_args :quiet
    end

    # Make a copy of the meeting template in /tmp.
    cp $XDG_DATA_HOME/jrnl/templates/meeting.md /tmp/jrnl-meeting.md

    # And edit it so that it contains the meeting name we just got from the user
    set meeting_name_escaped (string escape --style=regex $meeting_name)
    sed -i "s/Meeting Name/$meeting_name/" /tmp/jrnl-meeting.md

    jrnl --template /tmp/jrnl-meeting.md

    echo "Currently tracking time under '$meeting_name'."
    echo "  - Use '"(set_color --bold)"timew stop"(set_color normal) \
        "' to stop time tracking."
    echo "  - Use '"(set_color --bold)"jrnl -1 -edit"(set_color normal) \
        "'to continue editing the meeting minutes."
    echo ""

    # Print the current activity + time spent
    timew
end
