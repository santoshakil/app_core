#ifndef RUST_CORE_H
#define RUST_CORE_H

/* Generated with cbindgen:0.29.0 */

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct Point {
    double x;
    double y;
} Point;

typedef struct Rect {
    double x;
    double y;
    double width;
    double height;
} Rect;

typedef struct User {
    uint64_t id;
    uint32_t age;
    double score;
} User;

typedef struct LargeStruct {
    uint64_t data[100];
} LargeStruct;

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

struct Point create_point(double x, double y);

double point_distance(struct Point a, struct Point b);

struct Rect create_rect(double x, double y, double width, double height);

double rect_area(struct Rect rect);

bool rect_contains_point(struct Rect rect, struct Point point);

struct User create_user(uint64_t id, uint32_t age, double score);

uint32_t user_level(struct User user);

uint64_t fibonacci(uint64_t n);

uint64_t heavy_computation(uint64_t iterations);

uint64_t process_large_data(const char *data, uint32_t repeat);

bool simulate_slow_operation(uint32_t seconds);

struct LargeStruct create_large_struct(uint64_t seed);

uint64_t sum_large_struct(struct LargeStruct s);

uint64_t allocate_many_structs(uint32_t count);

bool init_dart_api(void *data);

void free_c_string(char *s);

void init_runtime(void);

#endif  /* RUST_CORE_H */
