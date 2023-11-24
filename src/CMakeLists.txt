# 4. Include/Link everything
set(EXEC_NAME USD_Creating_Prims)

add_executable(${EXEC_NAME} 
    main.cpp
)

# Adding libraries
find_library(USD_TF_LIBRARY
    NAMES
        ${USD_LIB_PREFIX}tf${USD_LIB_SUFFIX}
    HINTS
        ${PXR_USD_LOCATION}
        $ENV{PXR_USD_LOCATION}
    PATH_SUFFIXES
        lib
    DOC
        "USd Tf library"
)

find_library(USD_SDF_LIBRARY
    NAMES
        ${USD_LIB_PREFIX}sdf${USD_LIB_SUFFIX}
    HINTS
        ${PXR_USD_LOCATION}
        $ENV{PXR_USD_LOCATION}
    PATH_SUFFIXES
        lib
    DOC
        "Usd Sdf library"
)

find_library(USD_ARCH_LIBRARY
    NAMES
        ${USD_LIB_PREFIX}arch${USD_LIB_SUFFIX}
    HINTS
        ${PXR_USD_LOCATION}
        $ENV{PXR_USD_LOCATION}
    PATH_SUFFIXES
        lib
    DOC
        "Usd Arch library"
)

find_library(TBB_LIBRARY
    NAMES
        tbb
    HINTS
         ${PXR_USD_LOCATION}
         $ENV{PXR_USD_LOCATION}
    PATH_SUFFIXES
        lib
    DOC
        "TBB library"
)

file(GLOB BOOST_PYTHON_LIBRARY "${PXR_USD_LOCATION}/lib/boost_python*.lib")
file(GLOB BOOST_DIR "${USD_INCLUDE_DIR}/boost-*")

# Printing output
message(STATUS "PXR_USD_LOCATION: ${PXR_USD_LOCATION}")
message(STATUS "USD_LIBRARY Library: ${USD_LIBRARY}")
message(STATUS "PYTHON_INCLUDE_PATH Library: ${PYTHON_INCLUDE_PATH}")
message(STATUS "PYTHON_LIBRARY Library: ${PYTHON_LIBRARY}")
message(STATUS "USD_TF_LIBRARY: ${USD_TF_LIBRARY}")
message(STATUS "USD_SDF_LIBRARY: ${USD_SDF_LIBRARY}")
message(STATUS "USD_ARCH_LIBRARY: ${USD_ARCH_LIBRARY}")
message(STATUS "BOOST_PYTHON_LIBRARY: ${BOOST_PYTHON_LIBRARY}")
message(STATUS "TBB_LIBRARY: ${TBB_LIBRARY}")
message(STATUS "BOOST_DIR: ${BOOST_DIR}")


# Including and linking
target_include_directories(${EXEC_NAME} 
	PRIVATE
		${USD_INCLUDE_DIR}
		${PYTHON_INCLUDE_PATH}
		${BOOST_DIR}
)

target_link_libraries(${EXEC_NAME}
	PRIVATE
		${PYTHON_LIBRARY}
		${USD_LIBRARY}
		${USD_TF_LIBRARY}
		${USD_SDF_LIBRARY}
        ${USD_ARCH_LIBRARY}
        ${BOOST_PYTHON_LIBRARY}
        ${TBB_LIBRARY}
)

# Install

install(
    TARGETS
        ${EXEC_NAME}
    DESTINATION
        .
)
