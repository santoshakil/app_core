cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "app_core")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "app_core_plugin")

add_library(${PLUGIN_NAME} SHARED
  "../src/rust_core.c"
)

set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden
)

target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)

include(../cargokit/cmake/cargokit.cmake)
apply_cargokit(${PLUGIN_NAME} ${CMAKE_CURRENT_SOURCE_DIR}/../rust rust_core)