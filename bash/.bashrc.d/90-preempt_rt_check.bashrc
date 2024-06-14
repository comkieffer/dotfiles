
if [ -f ~/.config/ck/preempt_rt ]; then
    uname -a | grep "PREEMPT RT" > /dev/null
    not_preempt_rt=$?

    if [ $not_preempt_rt -ne 0 ]; then
        echo -e '  \e[1;31m✘\e[0m PREEMPT RT not enabled.'
    else
        echo -e "  \e[1;32m✔\e[0m PREEMPT RT detected."
    fi

    unset not_preempt_rt
fi
