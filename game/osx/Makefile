# Ta generate an empty plist.
# pkgbuild --analyze --root ./build/${APP}.app Info.plist

APP=cse441

cse441.pkg : 
	mkdir -p build/${APP}.app/Contents/MacOS
	mkdir -p build/${APP}.app/Contents/Resources
	mkdir -p build/${APP}.app/Contents/Frameworks

	cp Info.plist build/${APP}.app/Contents/
	cp ../working/a.out build/${APP}.app/Contents/MacOS/

	cp -f /usr/local/lib/libSDL2-2.0.0.dylib \
		build/${APP}.app/Contents/Frameworks
	
	cp -f /usr/local/lib/libSDL2_ttf-2.0.0.dylib \
        	build/${APP}.app/Contents/Frameworks
	
	cp -f /opt/X11/lib/libfreetype.6.dylib \
        	build/${APP}.app/Contents/Frameworks

	install_name_tool                                                             \
		-change                                                               \
		/usr/local/lib/libSDL2-2.0.0.dylib                                    \
        	/Applications/${APP}.app/Contents/Frameworks/libSDL2-2.0.0.dylib      \
        	build/${APP}.app/Contents/Frameworks/libSDL2_ttf-2.0.0.dylib

	install_name_tool                                                             \
		-change                                                               \
		/opt/X11/lib/libfreetype.6.dylib                                      \
        	/Applications/${APP}.app/Contents/Frameworks/libfreetype.6.dylib      \
        	build/${APP}.app/Contents/Frameworks/libSDL2_ttf-2.0.0.dylib

	install_name_tool                                                             \
		-change                                                               \
		/usr/local/lib/libSDL2_ttf-2.0.0.dylib                                \
		/Applications/${APP}.app/Contents/Frameworks/libSDL2_ttf-2.0.0.dylib  \
		build/${APP}.app/Contents/MacOS/a.out 

	install_name_tool                                                             \
		-change                                                               \
		/usr/local/lib/libSDL2-2.0.0.dylib                                    \
        	/Applications/${APP}.app/Contents/Frameworks/libSDL2-2.0.0.dylib      \
		build/${APP}.app/Contents/MacOS/a.out

	cp -r ../working/* build/${APP}.app/Contents/Resources/
	rm build/${APP}.app/Contents/Resources/a.out
	pkgbuild --root ./build                                            \
		 --identifier "edu.csusb.cse441"                           \
		 --version "1.0"                                           \
		 --install-location "/Applications"                        \
		 '${APP}.pkg'

clean :
	rm -rf build ${APP}.pkg

