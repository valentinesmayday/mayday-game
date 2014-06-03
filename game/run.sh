if [ ! -f working/a.out ] 
then 
	./build.sh
else
	cd working
	./a.out
fi

