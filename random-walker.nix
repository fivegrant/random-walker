{ mkDerivation, base, containers, stdenv }:
mkDerivation {
  pname = "random-walker";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base containers ];
  description = "Implements markov process for decryption";
  license = "GPL";
}
