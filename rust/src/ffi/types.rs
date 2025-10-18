use super::memory::safe_free_dart;
use std::ffi::{c_char, CStr, CString};

pub trait CstrToRust {
    fn to_native(&self) -> String;
    fn to_native_no_free(&self) -> String;
    fn to_native_optional(&self) -> Option<String>;
    fn to_native_optional_no_free(&self) -> Option<String>;
}

impl CstrToRust for *const c_char {
    fn to_native(&self) -> String {
        if self.is_null() {
            return String::new();
        }
        let v = unsafe { CStr::from_ptr(*self).to_string_lossy().into_owned() };
        safe_free_dart(*self);
        v
    }

    fn to_native_no_free(&self) -> String {
        if self.is_null() {
            return String::new();
        }
        unsafe { CStr::from_ptr(*self).to_string_lossy().into_owned() }
    }

    fn to_native_optional(&self) -> Option<String> {
        if self.is_null() {
            return None;
        }
        let v = unsafe { CStr::from_ptr(*self).to_string_lossy().into_owned() };
        safe_free_dart(*self);
        Some(v)
    }

    fn to_native_optional_no_free(&self) -> Option<String> {
        if self.is_null() {
            return None;
        }
        let v = unsafe { CStr::from_ptr(*self).to_string_lossy().into_owned() };
        Some(v)
    }
}

pub trait RustToCstr {
    fn to_cstr(&self) -> *mut c_char;
}

impl RustToCstr for String {
    fn to_cstr(&self) -> *mut c_char {
        if self.is_empty() {
            return std::ptr::null_mut();
        }
        let c_str = CString::new(self.as_str()).unwrap();
        c_str.into_raw()
    }
}

impl RustToCstr for &str {
    fn to_cstr(&self) -> *mut c_char {
        if self.is_empty() {
            return std::ptr::null_mut();
        }
        let c_str = CString::new(*self).unwrap();
        c_str.into_raw()
    }
}
