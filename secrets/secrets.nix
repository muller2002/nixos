let
  macbook = builtins.readFile ./macbookkey.pub;
  users = [ macbook ];

  aphrodite = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqyIJORJdDY/6FW9IfNpifOfuY3Hlu59ieV7nVXeT0b";
  apollon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNwjGuP8NsQWgNrCe3zXkPEHKXA4AkAI/kyGgnxc2NT";
  hermes = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPkRzyt4MmX8SA3JUGcrFwP8rAGeskgDgpQkqxzpFe1";
  systems = [ 
    aphrodite 
    apollon 
    hermes 
  ];
in
{
  "secret1.age".publicKeys = [ user1 system1 ];
  "secret2.age".publicKeys = users ++ systems;
}
