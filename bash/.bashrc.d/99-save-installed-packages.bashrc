
# Save the list of manually installed packages
# This is helpful to track down cruft and figure out what we can remove

rm ~/.installed-packages
apt-mark showmanual > ~/.installed-packages

rm ~/.dconf-state
dconf dump / > ~/.dconf-state
