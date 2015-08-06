use std::ffi::CString;

#[no_mangle]
pub extern "C" fn hello() -> *const i8 {
  let message = "Hello from Rust! Nice to C you!";
  CString::new(message)
    .unwrap()
    .as_ptr()
}
