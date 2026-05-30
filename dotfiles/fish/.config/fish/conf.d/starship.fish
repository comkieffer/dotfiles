# Required `starship` package install with
#   sh (curl -sS https://starship.rs/install.sh | psub) --bin-dir $HOME/.local/bin
#
# Provides the `starship` command to decorate the prompt

if type -q starship;
    starship init fish | source

    # React to STARSHIP_JOBS changes to export job names for the prompt.
    function __update_fish_job_names --on-variable STARSHIP_JOBS
        if test "$STARSHIP_JOBS" -gt 0 2>/dev/null
            set -gx FISH_JOB_NAMES (jobs 2>/dev/null | awk 'NR>1 {print $5}' | string join ', ')
        else
            set -e FISH_JOB_NAMES
        end
    end
end
