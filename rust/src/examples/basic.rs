use crate::ffi::{CstrToRust, RustToCstr};
use std::ffi::c_char;

#[no_mangle]
pub extern "C" fn sum(a: i32, b: i32) -> i32 {
    a + b
}

#[no_mangle]
pub extern "C" fn multiply(a: i32, b: i32) -> i32 {
    a * b
}

#[no_mangle]
pub extern "C" fn hello_world() -> *mut c_char {
    "Hello from Rust!".to_cstr()
}

#[no_mangle]
pub extern "C" fn reverse_string(input: *const c_char) -> *mut c_char {
    let s = input.to_native();
    let reversed: String = s.chars().rev().collect();
    reversed.to_cstr()
}

#[no_mangle]
pub extern "C" fn to_uppercase(input: *const c_char) -> *mut c_char {
    let s = input.to_native();
    s.to_uppercase().to_cstr()
}

#[no_mangle]
pub extern "C" fn concatenate(a: *const c_char, b: *const c_char) -> *mut c_char {
    let s1 = a.to_native();
    let s2 = b.to_native();
    format!("{}{}", s1, s2).to_cstr()
}

#[no_mangle]
pub extern "C" fn string_length(input: *const c_char) -> i32 {
    let s = input.to_native();
    s.len() as i32
}

#[no_mangle]
pub extern "C" fn get_version() -> *mut c_char {
    env!("CARGO_PKG_VERSION").to_cstr()
}
