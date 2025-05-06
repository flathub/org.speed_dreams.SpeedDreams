# Based on https://raw.githubusercontent.com/rhash/RHash/e601748b1c166791429944e2f4233ba6ba62988f/CMakeLists.txt

cmake_minimum_required(VERSION 3.1)
project(rhash)
include(rhash-tohex.cmake)

file(READ "version.h" versionfile)
string(REGEX MATCH "#define VERSION \"([0-9]*)\.([0-9]*)\.([0-9]*)\"" _ ${versionfile})
set(RHASH_VERSION_MAJOR ${CMAKE_MATCH_1})
set(RHASH_VERSION_MINOR ${CMAKE_MATCH_2})
set(RHASH_VERSION_PATCH ${CMAKE_MATCH_3})
set(RHASH_VERSION "${RHASH_VERSION_MAJOR}.${RHASH_VERSION_MINOR}.${RHASH_VERSION_PATCH}")
rhash_tohex(${RHASH_VERSION_MAJOR} RHASH_XVERSION_MAJOR)
rhash_tohex(${RHASH_VERSION_MINOR} RHASH_XVERSION_MINOR)
rhash_tohex(${RHASH_VERSION_PATCH} RHASH_XVERSION_PATCH)
# The last two zeros are equivalent to "printf %02x 0".
set(RHASH_XVERSION "0x${RHASH_XVERSION_MAJOR}${RHASH_XVERSION_MINOR}${RHASH_XVERSION_PATCH}00")

option(USE_GETTEXT "Enable gettext (localization) support")

set(SOURCE_FILES    "calc_sums.c"
                    "hash_print.c"
                    "common_func.c"
                    "hash_update.c"
                    "file.c"
                    "file_mask.c"
                    "file_set.c"
                    "find_file.c"
                    "hash_check.c"
                    "output.c"
                    "parse_cmdline.c"
                    "rhash_main.c"
                    "win_utils.c")

set(HEADER_FILES    "calc_sums.h"
                    "hash_print.h"
                    "common_func.h"
                    "hash_update.h"
                    "file.h"
                    "file_mask.h"
                    "file_set.h"
                    "find_file.h"
                    "hash_check.h"
                    "output.h"
                    "parse_cmdline.h"
                    "rhash_main.h"
                    "win_utils.h"
                    "platform.h"
                    "version.h")

add_subdirectory("librhash")

add_executable(${CMAKE_PROJECT_NAME} ${SOURCE_FILES} ${HEADER_FILES})
target_link_libraries(${CMAKE_PROJECT_NAME} librhash)
target_compile_definitions(librhash PRIVATE RHASH_XVERSION=${RHASH_XVERSION})

if (USE_GETTEXT)
    find_package(Intl REQUIRED)
    target_link_libraries(${CMAKE_PROJECT_NAME} ${Intl_LIBRARIES})
    target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${Intl_INCLUDE_DIRS})
    target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE USE_GETTEXT)
endif()

install(TARGETS ${CMAKE_PROJECT_NAME}
       RUNTIME DESTINATION bin)
