all: reader writer showcase

writer: writer.js writer.ts
	deno check writer.ts

reader: reader.js reader.ts
	deno check reader.ts

showcase: writer.js showcase.ts
	deno check showcase.ts

writer.js: writer.cpp
	EM_CACHE=.emcache emcc -fexceptions $(shell pkg-config --cflags exiv2) $(shell pkg-config --libs exiv2 expat zlib) -lembind writer.cpp -s EXPORT_ES6=1 -s MODULARIZE=1 -s EXPORT_NAME=WriterMain -s SINGLE_FILE=1 -s INITIAL_MEMORY=33554432 -o writer.js

reader.js: reader.cpp
	EM_CACHE=.emcache emcc -fexceptions $(shell pkg-config --cflags exiv2) $(shell pkg-config --libs exiv2 expat zlib) -lembind reader.cpp -s EXPORT_ES6=1 -s MODULARIZE=1 -s EXPORT_NAME=ReaderMain -s SINGLE_FILE=1  -o reader.js

