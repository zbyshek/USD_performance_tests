# 1. Requirements
cmake_minimum_required(VERSION 3.26.5)

# 2.Configuration
set(BIN_DIR "${CMAKE_SOURCE_DIR}/bin")
file(MAKE_DIRECTORY ${BIN_DIR})
set(CMAKE_INSTALL_PREFIX ${BIN_DIR})
message(STATUS "CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")

project(usd_creating_prims)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 2.Configuration
list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_SOURCE_DIR}/cmake")

# 3. Packages and src
find_package(PythonLibs 3.9 REQUIRED)
find_package(USD 0.23.11 REQUIRED)
add_subdirectory(src)
