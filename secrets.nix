let
  ageKey = "age10qhzl4m6h2u6a9ankqdahuj2pexsj2f44af09g5q2w9sntupssyq96skej";
in {
  "secrets/ssh_private_key.age".publicKeys = [ageKey];
  "secrets/restic.env.age".publicKeys = [ageKey];
}
