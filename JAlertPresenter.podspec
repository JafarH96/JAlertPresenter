Pod::Spec.new do |s|
  s.name             = 'JAlertPresenter'
  s.version          = '1.0.0'
  s.summary          = 'Present the apps alert controllers with prioritization without any conflicts or missing.'

  s.homepage         = 'https://github.com/JafarH96/JAlertPresenter'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Jafar' => 'jafarheidary75@gmail.com' }
  s.source           = { :git => 'https://github.com/JafarH96/JAlertPresenter.git', :tag => String(s.version) }

  s.ios.deployment_target = '14.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/JAlertPresenter/**/*'
end
