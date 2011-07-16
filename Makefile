include $(shell rospack find mk)/cmake.mk

all: wiic

TARBALL = build/wiic_0.53.zip
TARBALL_URL = http://sourceforge.net/projects/wiic/files/WiiC/0.53/wiic_0.53.zip/download
SOURCE_DIR = build/WiiC
UNPACK_CMD = unzip
include $(shell rospack find mk)/download_unpack_build.mk

wiic: $(SOURCE_DIR)/unpacked
	mkdir -p lib
	mkdir -p include
	mkdir -p include/wiic
	cd $(SOURCE_DIR)/src && cmake .
	cd $(SOURCE_DIR)/src && make
	cp $(SOURCE_DIR)/src/wiicpp/wiicpp.h include/wiic
	cp $(SOURCE_DIR)/src/wiic/*.h include/wiic
	mv $(SOURCE_DIR)/src/wiicpp/libwiicpp.dylib lib/
	mv $(SOURCE_DIR)/src/wiic/libwiic.dylib lib/
	install_name_tool -id `rospack find wiic`/lib/libwiicpp.dylib lib/libwiicpp.dylib
	install_name_tool -change `rospack find wiic`/build/WiiC/src/wiic/libwiic.dylib `rospack find wiic`/lib/libwiic.dylib lib/libwiicpp.dylib
	install_name_tool -id `rospack find wiic`/lib/libwiic.dylib lib/libwiic.dylib
	touch wiic
clean:
	-rm -rf lib bin $(SOURCE_DIR) wiic
wipe: clean
	-rm -rf build include