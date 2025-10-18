use rust_core::ffi::{CstrToRust, RustToCstr};
use std::ffi::c_char;

#[test]
fn test_string_conversion() {
    let test_str = "Hello, Rust!";
    let c_str = test_str.to_cstr();

    let converted = (c_str as *const c_char).to_native_no_free();
    assert_eq!(converted, test_str);

    unsafe {
        rust_core::ffi::free_c_string(c_str);
    }
}

#[test]
fn test_sum() {
    let result = rust_core::examples::basic::sum(10, 20);
    assert_eq!(result, 30);
}

#[test]
fn test_multiply() {
    let result = rust_core::examples::basic::multiply(5, 6);
    assert_eq!(result, 30);
}
