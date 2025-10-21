use crate::ffi::{CstrToRust, RustToCstr};
use std::ffi::c_char;

// Sorting large arrays
#[no_mangle]
pub extern "C" fn rust_quicksort(data_ptr: *const i32, len: usize) -> *mut c_char {
    if data_ptr.is_null() || len == 0 {
        return "[]".to_cstr();
    }

    unsafe {
        let data = std::slice::from_raw_parts(data_ptr, len);
        let mut vec = data.to_vec();
        vec.sort_unstable();

        // Return first 10 elements as JSON string
        let preview: Vec<i32> = vec.iter().take(10).copied().collect();
        format!("{:?}", preview).to_cstr()
    }
}

// Bubble sort for comparison
#[no_mangle]
pub extern "C" fn rust_bubble_sort(data_ptr: *const i32, len: usize) -> *mut c_char {
    if data_ptr.is_null() || len == 0 {
        return "[]".to_cstr();
    }

    unsafe {
        let data = std::slice::from_raw_parts(data_ptr, len);
        let mut vec = data.to_vec();

        for i in 0..vec.len() {
            for j in 0..vec.len() - i - 1 {
                if vec[j] > vec[j + 1] {
                    vec.swap(j, j + 1);
                }
            }
        }

        let preview: Vec<i32> = vec.iter().take(10).copied().collect();
        format!("{:?}", preview).to_cstr()
    }
}

// SHA-256 hash computation
#[no_mangle]
pub extern "C" fn rust_sha256(input: *const c_char) -> *mut c_char {
    use sha2::{Sha256, Digest};

    let text = input.to_native();
    let mut hasher = Sha256::new();
    hasher.update(text.as_bytes());
    let result = hasher.finalize();

    format!("{:x}", result).to_cstr()
}

// Prime number generation using Sieve of Eratosthenes
#[no_mangle]
pub extern "C" fn rust_generate_primes(limit: u32) -> *mut c_char {
    if limit < 2 {
        return "[]".to_cstr();
    }

    let mut is_prime = vec![true; (limit + 1) as usize];
    is_prime[0] = false;
    is_prime[1] = false;

    for i in 2..=((limit as f64).sqrt() as u32) {
        if is_prime[i as usize] {
            for j in ((i * i)..=limit).step_by(i as usize) {
                is_prime[j as usize] = false;
            }
        }
    }

    let primes: Vec<u32> = is_prime
        .iter()
        .enumerate()
        .filter_map(|(num, &is_p)| if is_p { Some(num as u32) } else { None })
        .collect();

    let count = primes.len();
    let preview: Vec<u32> = primes.iter().take(10).copied().collect();
    format!("Count: {}, First 10: {:?}", count, preview).to_cstr()
}

// Fibonacci with memoization
#[no_mangle]
pub extern "C" fn rust_fibonacci_sequence(n: u32) -> *mut c_char {
    if n == 0 {
        return "[0]".to_cstr();
    }
    if n == 1 {
        return "[0, 1]".to_cstr();
    }

    let mut fib = vec![0u64, 1u64];
    for i in 2..=n as usize {
        let next = fib[i - 1].saturating_add(fib[i - 2]);
        fib.push(next);
    }

    let preview: Vec<u64> = fib.iter().rev().take(10).rev().copied().collect();
    format!("{:?}", preview).to_cstr()
}

// Matrix multiplication
#[no_mangle]
pub extern "C" fn rust_matrix_multiply(size: usize) -> *mut c_char {
    if size == 0 || size > 500 {
        return "Invalid size".to_cstr();
    }

    // Create two matrices
    let matrix_a: Vec<Vec<f64>> = (0..size)
        .map(|i| (0..size).map(|j| ((i + j) % 10) as f64).collect())
        .collect();

    let matrix_b: Vec<Vec<f64>> = (0..size)
        .map(|i| (0..size).map(|j| ((i * j) % 10) as f64).collect())
        .collect();

    // Multiply matrices
    let mut result = vec![vec![0.0; size]; size];
    for i in 0..size {
        for j in 0..size {
            for k in 0..size {
                result[i][j] += matrix_a[i][k] * matrix_b[k][j];
            }
        }
    }

    // Return a sample element
    format!("Matrix {}x{} multiplied. Sample result[0][0]: {}", size, size, result[0][0]).to_cstr()
}

// JSON parsing and manipulation
#[no_mangle]
pub extern "C" fn rust_json_parse(json_str: *const c_char) -> *mut c_char {
    let input = json_str.to_native();

    match serde_json::from_str::<serde_json::Value>(&input) {
        Ok(mut value) => {
            // Manipulate the JSON - add a processed flag
            if let Some(obj) = value.as_object_mut() {
                obj.insert("processed_by_rust".to_string(), serde_json::json!(true));
                obj.insert("timestamp".to_string(), serde_json::json!(chrono::Utc::now().to_rfc3339()));
            }

            match serde_json::to_string(&value) {
                Ok(s) => s.to_cstr(),
                Err(e) => format!("Error serializing: {}", e).to_cstr(),
            }
        }
        Err(e) => format!("Error parsing JSON: {}", e).to_cstr(),
    }
}

// String manipulation - word count and analysis
#[no_mangle]
pub extern "C" fn rust_text_analysis(text: *const c_char) -> *mut c_char {
    let input = text.to_native();

    let word_count = input.split_whitespace().count();
    let char_count = input.chars().count();
    let line_count = input.lines().count();
    let unique_words: std::collections::HashSet<&str> = input
        .split_whitespace()
        .map(|w| w.trim_matches(|c: char| !c.is_alphanumeric()))
        .filter(|w| !w.is_empty())
        .collect();

    format!(
        "Words: {}, Chars: {}, Lines: {}, Unique: {}",
        word_count, char_count, line_count, unique_words.len()
    )
    .to_cstr()
}

// Compute-intensive task: Calculate Pi using Monte Carlo method
#[no_mangle]
pub extern "C" fn rust_calculate_pi(iterations: u32) -> f64 {
    use rand::Rng;

    let mut rng = rand::thread_rng();
    let mut inside_circle = 0u32;

    for _ in 0..iterations {
        let x: f64 = rng.gen();
        let y: f64 = rng.gen();

        if x * x + y * y <= 1.0 {
            inside_circle += 1;
        }
    }

    4.0 * (inside_circle as f64) / (iterations as f64)
}

// Data compression - simple run-length encoding
#[no_mangle]
pub extern "C" fn rust_compress_rle(input: *const c_char) -> *mut c_char {
    let text = input.to_native();

    if text.is_empty() {
        return "".to_cstr();
    }

    let mut result = String::new();
    let chars: Vec<char> = text.chars().collect();
    let mut i = 0;

    while i < chars.len() {
        let current = chars[i];
        let mut count = 1;

        while i + count < chars.len() && chars[i + count] == current {
            count += 1;
        }

        if count > 1 {
            result.push_str(&format!("{}{}", count, current));
        } else {
            result.push(current);
        }

        i += count;
    }

    result.to_cstr()
}
