# muller2020/nixos - Repo with all the Nix(OS)

## Aktuell administrierte Hosts

- apollon.marlenawan.de

## Nützliche links

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Manual](https://nixos.org/manual/nix/stable/)
  - besonders: [Text zu `nix flake`](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html)
- [NixOS Search](https://search.nixos.org/)

## (Neu-)Installation auf hosts mit

Aus dem [NixOS Manual](https://nixos.org/manual/nixos/stable/#sec-installation):

- Boote auf Live CD
- (Partitioniere, )Mounte Datenträger

Jetzt auf dem System per Hand:

```bash
HOSTNAME=[hostname]

git clone https://github.com/muller2002/nixos
cd nixos

# `--root /mnt` ist natürlich der mount-point des Zielsystems
# falls der mount-point /mnt ist, kann es weg-gelassen werden.
nixos-generate-config --root /mnt --show-hardware-config > ./hosts/$HOSTNAME/hardware-configuration.nix
# alternativ: nixos-generate-config --root /mnt --dir ./hosts/$HOSTNAME

# Bei bedarf die ./configuration.nix anpassen
#vi ./hosts/$HOSTNAME/configuration.nix

# stelle sicher, deine Änderungen in der hardware-configuration.nix zu speichern
git add ./hosts/$HOSTNAME/
git commit -m "(Re-)Install $HOSTNAME"
git push

nixos-install --root /mnt --flake .#$HOSTNAME
# alternativ, wenn du auf Nummer sicher gehen willst, dass auf dem
# Zielsystem das läuft, was im Repo beschrieben ist
# nixos-install --root /mnt --flake git+https://github.com/muller2002/nixos#$HOSTNAME
```

Jetzt solltest du eigentlich fertig sein.

## Ändern der Konfiguration (oder update)

In NixOS führt man `nixos-rebuild` aus um das System auf andere Konfigurationen zu aktualisieren.

```bash
# Arbeite auf einer aktuellen Kopie des Repos:
# git clone https://github.com/muller2002/nixos
# git pull
cd nixos # oder wo auch immer du das repo hast

EDITOR=nano
HOSTNAME=[hostname]

# update (wenn du willst:)
nix flake update

# while not happy {
$EDITOR ./hosts/$HOSTNAME/configuration.nix # Änderung machen
# oder: $EDITOR ./irgendwas
nixos-rebuild switch --flake .#$HOSTNAME # Änderung betrachten
# }

# Änderung committen
git add ./hosts/$HOSTNAME/configuration.nix
git commit -m "Ändere [irgendwas] auf $HOSTNAME"
git push

# auf Nummer sicher gehen, dass auf dem Zielsystem das läuft, was im Repo beschrieben ist
nixos-rebuild switch --flake git+https://github.com/muller2002/nixos#$HOSTNAME

```
