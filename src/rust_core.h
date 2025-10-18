#ifndef RUST_CORE_H
#define RUST_CORE_H

/* Generated with cbindgen:0.29.0 */

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

void fetch_data_async(const char *url, int64_t port);

void process_async(const char *data, int64_t port);

int32_t sum(int32_t a, int32_t b);

int32_t multiply(int32_t a, int32_t b);

char *hello_world(void);

char *reverse_string(const char *input);

char *to_uppercase(const char *input);

char *concatenate(const char *a, const char *b);

int32_t string_length(const char *input);

char *get_version(void);

uint64_t fibonacci(uint64_t n);

uint64_t heavy_computation(uint64_t iterations);

uint64_t process_large_data(const char *data, uint32_t repeat);

bool simulate_slow_operation(uint32_t seconds);

bool init_dart_api(void *data);

void free_c_string(char *s);

void init_runtime(void);

#endif  /* RUST_CORE_H */
