use crate::ffi::CstrToRust;
use std::ffi::c_char;

#[no_mangle]
pub extern "C" fn fibonacci(n: u64) -> u64 {
    match n {
        0 => 0,
        1 => 1,
        _ => fibonacci(n - 1) + fibonacci(n - 2),
    }
}

#[no_mangle]
pub extern "C" fn heavy_computation(iterations: u64) -> u64 {
    let mut sum: u64 = 0;
    for i in 0..iterations {
        sum = sum.wrapping_add(i * i);
    }
    sum
}

#[no_mangle]
pub extern "C" fn process_large_data(data: *const c_char, repeat: u32) -> u64 {
    let input = data.to_native();
    let mut result: u64 = 0;

    for _ in 0..repeat {
        result = result.wrapping_add(input.len() as u64);
        for c in input.chars() {
            result = result.wrapping_add(c as u64);
        }
    }

    result
}

#[no_mangle]
pub extern "C" fn simulate_slow_operation(seconds: u32) -> bool {
    std::thread::sleep(std::time::Duration::from_secs(seconds as u64));
    true
}
