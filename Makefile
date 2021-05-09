build: 
	nix-shell --pure -p cabal2nix --run "cabal2nix ." > random-walker.nix
	nix-build release.nix


run:
	./result/bin/random-walker

environment: build
	nix-shell --pure release.nix

clean: 
	rm -rf result
	rm -f random-walker.nix

rebuild: clean build
