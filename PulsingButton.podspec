Pod::Spec.new do |s|
  s.name         = "PulsingButton"
  s.version      = "1.0.0"
  s.summary      = "Pulsing animation for any UIView layer and a Button with pulsing animation and this layer"
  s.description  = "See README.md for more information"
  s.homepage     = "https://github.com/smakeev/PulsingButton"
  s.license      = { :type => 'MIT' }
  s.author       = { "Sergey Makeev" => "makeev.87@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       =  { :git => "https://github.com/smakeev/PulsingButton.git", :tag => "#{s.version}" }
  s.source_files  = "PulsingButton/PulsingButton/*.{swift}"
  s.exclude_files = "PulsingButton/PulsingButton/*.plist"
  s.swift_version = '5.1'
end
