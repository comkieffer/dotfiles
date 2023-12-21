# Dotfiles management command.
#
# See https://mitxela.com/projects/dotfiles_management

function dot
    if test (count $argv) -eq 0
        begin
            cd "$HOME"
            for i in (dotfiles ls-files);
                echo -n (dotfiles -c color.status=always status $i -s | sed "s#$i##")
                echo -e "¬/$i¬\e[0;33m"(dotfiles -c color.ui=always log -1 --format="%s" -- $i)"\e[0m"
            end
        end | column -t --separator=¬ -T2
    else
        dotfiles $argv
    end
end
