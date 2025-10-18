Pod::Spec.new do |s|
  s.name             = 'app_core'
  s.version          = '0.1.0'
  s.summary          = 'Production-ready Flutter FFI plugin with Rust backend'
  s.description      = <<-DESC
Production-ready Flutter FFI plugin with Rust backend.
                       DESC
  s.homepage         = 'https://github.com/yourusername/app_core'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Name' => 'your.email@example.com' }
  s.platform = :ios, '12.0'

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'

  s.script_phase = {
    :name => 'Build Rust library',
    :script => 'sh "$PODS_TARGET_SRCROOT/../cargokit/build_pod.sh" ../rust rust_core',
    :execution_position => :before_compile,
    :input_files => ['${BUILT_PRODUCTS_DIR}/cargokit_phony'],
    :output_files => ["${BUILT_PRODUCTS_DIR}/librust_core.a"],
  }

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'OTHER_LDFLAGS' => '-force_load ${BUILT_PRODUCTS_DIR}/librust_core.a',
  }
end