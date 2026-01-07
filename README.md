# dotfiles

Personal dotfiles managed with Nix Home Manager.

## Setup on a new machine

1. **Install Nix**

   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

   Restart your shell or run:
   ```bash
   . /etc/profile.d/nix.sh
   ```

1. **Enable flakes**

   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

1. **Add yourself to trusted users**

   ```bash
   echo "trusted-users = root $(whoami)" | sudo tee -a /etc/nix/nix.conf
   sudo systemctl restart nix-daemon
   ```

1. **Clone this repository**

   ```bash
   git clone https://github.com/vjrasane/dotfiles.git ~/dotfiles
   ```

1. **Set up age key for secrets decryption**

   Create the age key directory and add your private key:

   ```bash
   mkdir -p ~/.config/age
   ```

   Add your age private key to `~/.config/age/key.txt`. The file should contain:

   ```
   # created: <date>
   # public key: age1...
   AGE-SECRET-KEY-...
   ```

   This key is used by agenix to decrypt secrets (SSH keys, etc.) stored in `secrets/`.

1. **Apply Home Manager configuration**

   ```bash
   nix run home-manager/master -- switch --impure --flake ~/dotfiles
   ```

   This installs all packages, creates symlinks, and decrypts secrets.

1. **Set zsh as default shell**

   ```bash
   echo "$(which zsh)" | sudo tee -a /etc/shells
   chsh -s $(which zsh)
   ```

## Updating

```bash
# After editing home.nix (or use the alias)
hms
# or: home-manager switch --impure --flake ~/dotfiles

# Update flake inputs
nix flake update ~/dotfiles
hms
```

Home Manager also auto-switches on login via a systemd user service.

## Optional: Work configuration

Create `work.nix` (gitignored) for work-specific git settings:

```nix
{
  user = "Your Name";
  email = "you@company.com";
  remotes = [
    "git@github.com:company"
    "https://github.com/company"
  ];
}
```

This adds conditional git includes for work repositories.

## Secrets management

Secrets are encrypted with [age](https://age-encryption.org/) and managed by [agenix](https://github.com/ryantm/agenix).

```
secrets/
  ssh_private_key.age   # SSH private key
  restic.env.age        # Restic backup credentials
```

To add/edit secrets:

```bash
# Encrypt a new secret
age -r "$(cat ~/.config/age/key.txt | grep 'public key' | cut -d: -f2 | tr -d ' ')" \
  -o secrets/mysecret.age /path/to/plaintext

# Decrypt a secret
age -d -i ~/.config/age/key.txt secrets/mysecret.age
```

Then add the secret to `home.nix`:

```nix
age.secrets.mysecret = {
  file = ./secrets/mysecret.age;
  path = "${homeDirectory}/.config/mysecret";
  mode = "0600";
};
```
