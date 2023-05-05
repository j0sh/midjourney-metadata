// ***************************************************************** -*- C++ -*-
// writer.cpp
// Sample emscripten driver to write Exif metadata to an image
#include <exiv2/exiv2.hpp>
#include <iostream>
#include <iomanip>
#include <cassert>

#include <emscripten/emscripten.h>
#include <emscripten/val.h>
#include <emscripten/bind.h>

emscripten::val writer(std::string d)
try {
    auto sz = d.length();
    auto data = reinterpret_cast<const Exiv2::byte*>(d.data());
    Exiv2::Image::UniquePtr image = Exiv2::ImageFactory::open(data, sz);
    assert(image.get() != 0);

    // xmp data
    Exiv2::XmpParser::initialize();
    ::atexit(Exiv2::XmpParser::terminate);
    Exiv2::XmpData &xmpData = image->xmpData();

    xmpData["Xmp.dc.foo"] = "Rubber Ducky";
    image->setXmpData(xmpData);
    image->writeMetadata();

    auto &raw = image->io();
    raw.seek(0,Exiv2::BasicIo::beg);
    auto rawData = raw.read(raw.size());
    assert(raw.size() == rawData.size());

    emscripten::val view{ emscripten::typed_memory_view(rawData.size(), rawData.data()) };
    auto result = emscripten::val::global("Uint8Array").new_(rawData.size());
    result.call<void>("set", view);

    return result;
}
catch (Exiv2::Error& e) {
    std::cout << "Caught Exiv2 exception '" << e.what() << "'\n";
    return emscripten::val(emscripten::val::null());
}

using namespace emscripten;
EMSCRIPTEN_BINDINGS(my_module)
{
  function("writer", &writer, allow_raw_pointers());
}
