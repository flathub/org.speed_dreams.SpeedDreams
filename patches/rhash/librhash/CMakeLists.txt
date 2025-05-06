# Based on https://raw.githubusercontent.com/rhash/RHash/e601748b1c166791429944e2f4233ba6ba62988f/librhash/CMakeLists.txt

cmake_minimum_required(VERSION 3.1)
project(librhash LANGUAGES C)

include(GNUInstallDirs)

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON CACHE BOOL "Export all symbols when building shared library on Windows")

option(USE_OPENSSL "Enable OpenSSL (optimized hash functions) support")
option(OPENSSL_RUNTIME "Load OpenSSL at runtime if present")

set(SOURCE_FILES    "aich.c"
                    "algorithms.c"
                    "blake2b.c"
                    "blake2s.c"
                    "byte_order.c"
                    "crc32.c"
                    "ed2k.c"
                    "edonr.c"
                    "gost12.c"
                    "gost94.c"
                    "has160.c"
                    "hex.c"
                    "md4.c"
                    "md5.c"
                    "plug_openssl.c"
                    "rhash.c"
                    "rhash_torrent.c"
                    "ripemd-160.c"
                    "sha1.c"
                    "sha256.c"
                    "sha3.c"
                    "sha512.c"
                    "snefru.c"
                    "tiger.c"
                    "tiger_sbox.c"
                    "torrent.c"
                    "tth.c"
                    "util.c"
                    "whirlpool.c"
                    "whirlpool_sbox.c")

set(HEADER_FILES    "aich.h"
                    "algorithms.h"
                    "blake2b.h"
                    "blake2s.h"
                    "byte_order.h"
                    "crc32.h"
                    "ed2k.h"
                    "edonr.h"
                    "gost12.h"
                    "gost94.h"
                    "has160.h"
                    "hex.h"
                    "md4.h"
                    "md5.h"
                    "plug_openssl.h"
                    "rhash.h"
                    "rhash_torrent.h"
                    "ripemd-160.h"
                    "sha1.h"
                    "sha256.h"
                    "sha3.h"
                    "sha512.h"
                    "snefru.h"
                    "tiger.h"
                    "torrent.h"
                    "tth.h"
                    "ustd.h"
                    "util.h"
                    "whirlpool.h")

add_library(${PROJECT_NAME} ${SOURCE_FILES} ${HEADER_FILES})

if(USE_OPENSSL)
    find_package(OpenSSL REQUIRED)
    target_link_libraries(${PROJECT_NAME} OpenSSL::Crypto)
    target_compile_definitions(${PROJECT_NAME} PUBLIC USE_OPENSSL)
endif()

if(OPENSSL_RUNTIME)
    target_link_libraries(${PROJECT_NAME} PUBLIC ${CMAKE_DL_LIBS})
    target_compile_definitions(${PROJECT_NAME} PRIVATE OPENSSL_RUNTIME)
endif()

if(MSVC)
    target_compile_definitions(${PROJECT_NAME} PRIVATE _CRT_SECURE_NO_DEPRECATE)
endif()

set_target_properties(${PROJECT_NAME} PROPERTIES
                      COMPILE_DEFINITIONS IN_RHASH
                      DEFINE_SYMBOL RHASH_EXPORTS
                      PREFIX ""
                      IMPORT_PREFIX ""
                      VERSION ${RHASH_VERSION}
                      SOVERSION ${RHASH_VERSION_MAJOR})

export(TARGETS ${PROJECT_NAME}
       NAMESPACE ${CMAKE_PROJECT_NAME}::
       FILE "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake")

install(TARGETS ${PROJECT_NAME}
       EXPORT ${CMAKE_PROJECT_NAME}Config
       RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
       LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
       ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})

install(FILES "rhash.h" "rhash_torrent.h"
        DESTINATION include)

install(EXPORT ${CMAKE_PROJECT_NAME}Config
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/${CMAKE_PROJECT_NAME}/cmake"
        NAMESPACE ${CMAKE_PROJECT_NAME}::)
