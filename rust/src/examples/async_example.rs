use crate::ffi::CstrToRust;
use irondash_dart_ffi::DartPort;
use std::ffi::c_char;

#[no_mangle]
pub extern "C" fn fetch_data_async(url: *const c_char, port: i64) {
    let url = url.to_native();
    let dart_port = DartPort::new(port);

    crate::ffi::spawn(async move {
        tokio::time::sleep(tokio::time::Duration::from_millis(500)).await;
        let result = format!("Data fetched from: {}", url);
        dart_port.send(result);
    });
}

#[no_mangle]
pub extern "C" fn process_async(data: *const c_char, port: i64) {
    let data = data.to_native();
    let dart_port = DartPort::new(port);

    crate::ffi::spawn(async move {
        tokio::time::sleep(tokio::time::Duration::from_secs(1)).await;
        let result = format!("Processed: {} (length: {})", data, data.len());
        dart_port.send(result);
    });
}
