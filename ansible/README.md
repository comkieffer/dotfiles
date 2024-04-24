# Anisble scripts

We install ansible with `apt` because we need to run it with root permissions. Since `pipx` installs things into our homedir, it makes it harder to use them with `sudo`.

```bash
sudo apt install ansible
```

Then install the required community roles with

```bash
sudo ansible-galaxy install -r requirements.yml
```

Install everything with

```bash
sudo ansible-playbook \
    -i inventory.yaml --ask-become-pass playbooks/install-all.yml
```

## ToDo

- [ ] Add installer for sublime merge
- [ ] Add installer for regolith
- [ ] Add installer for just
- [ ] Add installer for docker
- [ ] Add installer for rust tools (cargo, zoxide, exa, ... )

See `apt-mark showmanual` for the list of installed packages.
