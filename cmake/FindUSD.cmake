# Module to find USD.

find_path(USD_INCLUDE_DIR
    NAMES
        pxr/pxr.h
    HINTS
        ${PXR_USD_LOCATION}
        $ENV{PXR_USD_LOCATION}
    PATH_SUFFIXES
        include
    DOC
        "USD Include directory"
)

find_file(USD_CONFIG_FILE
    NAMES 
        pxrConfig.cmake
    PATHS 
        ${PXR_USD_LOCATION}
        $ENV{PXR_USD_LOCATION}
    DOC "USD cmake configuration file"
)

get_filename_component(PXR_USD_LOCATION "${USD_CONFIG_FILE}" DIRECTORY)

include(${USD_CONFIG_FILE})

if(NOT DEFINED PXR_VERSION)
    message(FATAL_ERROR "Expected PXR_VERSION defined in pxrConfig.cmake")
endif()

set(USD_VERSION ${PXR_MAJOR_VERSION}.${PXR_MINOR_VERSION}.${PXR_PATCH_VERSION})

set(USD_LIB_PREFIX "${CMAKE_SHARED_LIBRARY_PREFIX}usd_"
    CACHE STRING "Prefix of USD libraries; generally matches the PXR_LIB_PREFIX used when building core USD")

if (WIN32)
    # ".lib" on Windows
    set(USD_LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX}
        CACHE STRING "Extension of USD libraries")
else ()
    # ".so" on Linux, ".dylib" on MacOS
    set(USD_LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX}
        CACHE STRING "Extension of USD libraries")
endif ()

find_library(USD_LIBRARY
    NAMES
        ${USD_LIB_PREFIX}usd${USD_LIB_SUFFIX}
    HINTS
        ${PXR_USD_LOCATION}
        $ENV{PXR_USD_LOCATION}
    PATH_SUFFIXES
        lib
    DOC
        "Main USD library"
)

get_filename_component(USD_LIBRARY_DIR ${USD_LIBRARY} DIRECTORY)

# Get the boost version from the one built with USD
if(USD_INCLUDE_DIR)
    file(GLOB _USD_VERSION_HPP_FILE "${USD_INCLUDE_DIR}/boost-*/boost/version.hpp")
    list(LENGTH _USD_VERSION_HPP_FILE found_one)
    if(${found_one} STREQUAL "1")
        list(GET _USD_VERSION_HPP_FILE 0 USD_VERSION_HPP)
        file(STRINGS
            "${USD_VERSION_HPP}"
            _usd_tmp
            REGEX "#define BOOST_VERSION .*$")
        string(REGEX MATCH "[0-9]+" USD_BOOST_VERSION ${_usd_tmp})
        unset(_usd_tmp)
        unset(_USD_VERSION_HPP_FILE)
        unset(USD_VERSION_HPP)
    endif()
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(USD
    REQUIRED_VARS
        PXR_USD_LOCATION
        USD_INCLUDE_DIR
        USD_LIBRARY_DIR
        USD_CONFIG_FILE
        USD_VERSION
        PXR_VERSION
        VERSION_VAR
        USD_VERSION
)

if (USD_FOUND)
    message(STATUS "   USD include dir: ${USD_INCLUDE_DIR}")
    message(STATUS "   USD library dir: ${USD_LIBRARY_DIR}")
    message(STATUS "   USD version: ${USD_VERSION}")
    if(DEFINED USD_BOOST_VERSION)
        message(STATUS "   USD Boost::boost version: ${USD_BOOST_VERSION}")
    endif()
endif()