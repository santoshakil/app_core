cmake_minimum_required(VERSION 3.10)

project(app_core_library VERSION 0.0.1 LANGUAGES C)

add_library(app_core SHARED
  "rust_core.c"
)

set_target_properties(app_core PROPERTIES
  PUBLIC_HEADER rust_core.h
  OUTPUT_NAME "app_core"
)

target_compile_definitions(app_core PUBLIC DART_SHARED_LIB)