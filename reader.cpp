// reader.cpp
// Sample emscripten driver to print the Exif metadata of an image
#include <exiv2/exiv2.hpp>
#include <iostream>
#include <iomanip>
#include <cassert>

#include <emscripten/emscripten.h>
#include <emscripten/val.h>
#include <emscripten/bind.h>

emscripten::val reader(std::string d)
try {
    auto sz = d.length();
    auto data = reinterpret_cast<const Exiv2::byte*>(d.data());
    Exiv2::Image::UniquePtr image = Exiv2::ImageFactory::open(data, sz);
    assert(image.get() != 0);
    image->readMetadata();

    // exif data
    Exiv2::ExifData &exifData = image->exifData();
    if (!exifData.empty()) {
    Exiv2::ExifData::const_iterator end = exifData.end();
    for (Exiv2::ExifData::const_iterator i = exifData.begin(); i != end; ++i) {
        const char* tn = i->typeName();
        std::cout << std::setw(44) << std::setfill(' ') << std::left
                  << i->key() << " "
                  << "0x" << std::setw(4) << std::setfill('0') << std::right
                  << std::hex << i->tag() << " "
                  << std::setw(9) << std::setfill(' ') << std::left
                  << (tn ? tn : "Unknown") << " "
                  << std::dec << std::setw(3)
                  << std::setfill(' ') << std::right
                  << i->count() << "  "
                  << std::dec << i->value()
                  << "\n";
    }
    } else std::cout << "No EXIF Data Found" << std::endl;

    // xmp data
    Exiv2::XmpParser::initialize();
    ::atexit(Exiv2::XmpParser::terminate);
    Exiv2::XmpData &xmpData = image->xmpData();
    if (!xmpData.empty()) {
    for (Exiv2::XmpData::const_iterator md = xmpData.begin();
         md != xmpData.end(); ++md) {
        std::cout << std::setfill(' ') << std::left
                  << std::setw(44)
                  << md->key() << " "
                  << std::setw(9) << std::setfill(' ') << std::left
                  << md->typeName() << " "
                  << std::dec << std::setw(3)
                  << std::setfill(' ') << std::right
                  << md->count() << "  "
                  << std::dec << md->toString()
                  << std::endl;
    }
    } else std::cout << "No XMP Data Found" << std::endl;
    Exiv2::XmpParser::terminate();

    // iptc data
    Exiv2::IptcData &iptcData = image->iptcData();
    if (!iptcData.empty()) {
      Exiv2::IptcData::iterator end = iptcData.end();
      for (Exiv2::IptcData::iterator md = iptcData.begin(); md != end; ++md) {
        std::cout << std::setw(44) << std::setfill(' ') << std::left
                  << md->key() << " "
                  << "0x" << std::setw(4) << std::setfill('0') << std::right
                  << std::hex << md->tag() << " "
                  << std::setw(9) << std::setfill(' ') << std::left
                  << md->typeName() << " "
                  << std::dec << std::setw(3)
                  << std::setfill(' ') << std::right
                  << md->count() << "  "
                  << std::dec << md->value()
                  << std::endl;
      }
    } else std::cout << "No IPTC Data Found" << std::endl;

    return emscripten::val(0);
}
catch (Exiv2::Error& e) {
    std::cout << "Caught Exiv2 exception '" << e.what() << "'\n";
    return emscripten::val(-1);
}

using namespace emscripten;
EMSCRIPTEN_BINDINGS(my_module)
{
  function("reader", &reader, allow_raw_pointers());
}
