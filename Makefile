all: reader writer

writer: writer.js
	deno check writer.ts

reader: reader.js
	deno check reader.ts

writer.js: writer.cpp
	EM_CACHE=.emcache emcc -fexceptions $(shell pkg-config --cflags exiv2) $(shell pkg-config --libs exiv2 expat zlib) -lembind writer.cpp -s EXPORT_ES6=1 -s MODULARIZE=1 -s EXPORT_NAME=WriterMain -s SINGLE_FILE=1  -o writer.js

reader.js: reader.cpp
	EM_CACHE=.emcache emcc -fexceptions $(shell pkg-config --cflags exiv2) $(shell pkg-config --libs exiv2 expat zlib) -lembind reader.cpp -s EXPORT_ES6=1 -s MODULARIZE=1 -s EXPORT_NAME=ReaderMain -s SINGLE_FILE=1  -o reader.js

