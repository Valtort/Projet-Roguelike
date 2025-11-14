run_basegame:
	cd BaseGame && dune exec rogue

run_extensions:
	cd Extensions && dune exec rogue

run_extensions_sb:
	cd Extensions && dune exec rogue_sb

test_basegame:
	cd BaseGame && dune build && dune test && dune clean

test_extensions:
	cd Extensions && dune build && dune test && dune clean

clean:
	cd Extensions && dune clean && cd .. && cd BaseGame && dune clean 
