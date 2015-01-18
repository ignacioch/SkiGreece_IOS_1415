Pod::Spec.new do |s|
  s.name         = 'VTAcknowledgementsViewController'
  s.version      = '0.12'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/ignacioch/VTAcknowledgementsViewController'
  s.author = {
    'Vincent Tourraine' => 'me@vtourraine.net'
  }
  s.summary      = 'Ready to use Acknowledgements/Licenses/Credits view controller for CocoaPods.'
  s.platform     =  :ios
  s.source = {
    :git => 'https://github.com/ignacioch/VTAcknowledgementsViewController.git',
    :tag => 'v0.12'
  }

  s.resources = "VTAcknowledgementsViewController.bundle"

  s.source_files = ['Classes/*.{h,m}']
  s.ios.deployment_target = '5.0'
  s.requires_arc = true
end
