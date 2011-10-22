#include <cairo/cairo.h>

const char* ml_cairo_version_string() {
    return cairo_version_string();
}

const int ml_CAIRO_VERSION() {
    return CAIRO_VERSION;
}

const char* ml_CAIRO_VERSION_STRING() {
    return CAIRO_VERSION_STRING;
}
