
# Load __vte_osc7 command for tilix
# We need to do it early beacuse it overwrites `PROMPT_COMMAND`
if [[ $TILIX_ID ]]; then
    if [[ ! -f /etc/profile.d/vte.sh ]]; then
        echo "Missing symbolic link to /etc/profile.d/vte.sh"
        echo "Creating it now ..."
        sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
    fi
    source /etc/profile.d/vte.sh
fi
