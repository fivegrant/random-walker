build: 
	nix-shell --pure -p cabal2nix --run "cabal2nix . --enable-profiling" > random-walker.nix
	nix-build release.nix


run:
	./result/bin/random-walker +RTS -xc -RTS

environment: build
	nix-shell --pure release.nix

clean: 
	rm -rf result
	rm -f random-walker.nix

rebuild: clean build
