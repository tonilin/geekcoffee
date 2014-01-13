Airbrake.configure do |config|
  config.api_key = '443965aa490a34ddc1ca5f15c1b3058c'
  config.host    = 'errbit.roachking.net'
  config.port    = 80
  config.secure  = config.port == 443
end
