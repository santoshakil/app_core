use std::sync::Once;

static INIT: Once = Once::new();

#[no_mangle]
pub extern "C" fn init_dart_api(data: *mut std::ffi::c_void) -> bool {
    INIT.call_once(|| {
        irondash_dart_ffi::irondash_init_ffi(data);
    });
    true
}
