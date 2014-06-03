# Delete previously generated executable.
if [ -f working/a.out ] 
then 
	rm working/a.out 
fi

# Compile program.
clang -o working/a.out `sdl2-config --libs --cflags` -I /usr/local/include -llua -lSDL2_ttf src/*.c

# Run the program from within the assets folder.
if [ -f working/a.out ] 
then 
	cd working
	./a.out
fi

