use once_cell::sync::Lazy;
use std::future::Future;
use tokio::runtime::Runtime;

static RUNTIME: Lazy<Runtime> = Lazy::new(|| {
    tokio::runtime::Builder::new_multi_thread()
        .worker_threads(num_cpus::get())
        .thread_name("app_core")
        .enable_all()
        .build()
        .expect("Failed to create Tokio runtime")
});

pub fn spawn<F>(future: F)
where
    F: Future<Output = ()> + Send + 'static,
{
    RUNTIME.spawn(future);
}

pub fn spawn_blocking<F, R>(f: F)
where
    F: FnOnce() -> R + Send + 'static,
    R: Send + 'static,
{
    RUNTIME.spawn_blocking(f);
}

pub fn block_on<F>(future: F) -> F::Output
where
    F: Future,
{
    RUNTIME.block_on(future)
}

#[no_mangle]
pub extern "C" fn init_runtime() {
    Lazy::force(&RUNTIME);
}
