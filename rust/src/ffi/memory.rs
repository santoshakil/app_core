use std::ffi::{c_char, CString};

#[no_mangle]
#[allow(clippy::missing_safety_doc)]
pub unsafe extern "C" fn free_c_string(s: *mut c_char) {
    if s.is_null() {
        return;
    }
    drop(CString::from_raw(s));
}

fn free_dart_string(s: *const c_char) {
    if s.is_null() {
        return;
    }
    unsafe {
        libc::free(s as *mut libc::c_void);
    }
}

pub fn safe_free_dart(s: *const c_char) {
    free_dart_string(s);
}
