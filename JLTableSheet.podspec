Pod::Spec.new do |s|
  s.name         = "JLTableSheet"
  s.version      = "1.3"
  s.summary      = "JLTableSheet"
  s.homepage     = "https://github.com/jangsy7883/JLTableSheet"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "hmhv" => "jangsy7883@gmail.com" }
  s.source       = { :git => "https://github.com/jangsy7883/JLTableSheet.git", :tag => s.version }
  s.source_files = 'JLTableSheet/*.{h,m}'
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.dependency 'STPopup'
end
