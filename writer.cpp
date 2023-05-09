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

emscripten::val writer(std::string d, const emscripten::val &kv)
try {
    auto sz = d.length();
    auto data = reinterpret_cast<const Exiv2::byte*>(d.data());
    Exiv2::Image::UniquePtr image = Exiv2::ImageFactory::open(data, sz);
    assert(image.get() != 0);

    // read any existing xmp data and register the midjourney namespace
    Exiv2::XmpParser::initialize();
    ::atexit(Exiv2::XmpParser::terminate);
    Exiv2::XmpData &xmpData = image->xmpData();
    Exiv2::XmpProperties::registerNs("midjourneyNamespace", "midjourney");

    // read kv into xmp
    const emscripten::val keys = emscripten::val::global("Object").call<emscripten::val>("keys", kv);
    int length = keys["length"].as<int>();
    for (int i = 0; i < length; ++i) {
      const auto k = keys[i].as<std::string>();
      const emscripten::val v = kv[k];
      // TODO check for string type
      if (v.typeOf().as<std::string>() != "string") {
        std::cout << "skipping non-string value for key " << k << std::endl;
        continue;
      }
      xmpData["Xmp." + k] = v.as<std::string>();
    }

    // write
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
