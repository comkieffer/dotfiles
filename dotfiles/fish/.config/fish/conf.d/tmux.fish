if status is-interactive; and type -q tmux
    function tmux-ls --description 'List running tmux sessions with name, uptime, and active command'
        if not tmux list-sessions &>/dev/null
            echo "No tmux sessions running"
            return 0
        end

        set -l now (date +%s)

        printf "%-20s %-8s %-12s %-14s %s\n" SESSION WINDOWS STATUS UPTIME "ACTIVE COMMAND"
        printf '%s\n' (string repeat -n 72 -)

        # list-panes -a exposes session + pane variables together; filter to the
        # active pane of the active window so we get exactly one row per session.
        tmux list-panes -a -F "#{session_name}\t#{session_windows}\t#{?session_attached,attached,detached}\t#{session_created}\t#{pane_current_command}\t#{pane_active}\t#{window_active}" \
            | while read -l line
            set -l p (string split \t $line)
            # $p[6] = pane_active, $p[7] = window_active
            test "$p[6]" = 1 -a "$p[7]" = 1 || continue

            set -l elapsed (math "$now - $p[4]")
            set -l days    (math --scale=0 "$elapsed / 86400")
            set -l hours   (math --scale=0 "$elapsed % 86400 / 3600")
            set -l minutes (math --scale=0 "$elapsed % 3600 / 60")

            set -l uptime
            if test $days -gt 0
                set uptime "$days"d" $hours"h" $minutes"m
            else if test $hours -gt 0
                set uptime "$hours"h" $minutes"m
            else
                set uptime "$minutes"m
            end

            printf "%-20s %-8s %-12s %-14s %s\n" $p[1] $p[2] $p[3] $uptime $p[5]
        end
    end
end
