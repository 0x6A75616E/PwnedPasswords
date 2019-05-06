
Pod::Spec.new do |s|
  s.name             = 'PwnedPasswords'
  s.version          = '0.1.0'
  s.summary          = 'A client for HaveIBeenPwned.com\'s compromised passwords API. Written in Swift, with no dependencies.'

  s.description      = <<-DESC
PwnedPasswords implements a dependency-free, Swift native client for HaveIBeenPwned.com's [Pwned Passwords API v2](https://haveibeenpwned.com/API/v2#PwnedPasswords).
                       DESC

  s.homepage         = 'https://github.com/0x6A75616E/PwnedPasswords'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '0x6A75616E' => 'contact@0x6A75616E.dev' }
  s.source           = { :git => 'https://github.com/0x6A75616E/PwnedPasswords.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'src/**/*'

end
