Warbler.framework_detection = false

Warbler::Config.new do |config|
  config.features = %w[runnable compiled]
  config.dirs = %w[config exe lib]
  config.jar_extension = "jar"
  config.autodeploy_dir = "dist/"
  config.compile_gems = true
  config.bytecode_version = "1.8"
  config.override_gem_home = true
end
