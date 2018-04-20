require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name           = package['name']
  s.version        = package['version']
  s.summary        = package['description']
  s.requires_arc   = true
  s.author         = { 'Naoufal Kadhom' => 'naoufalkadhom@gmail.com' }
  s.license        = package['license']
  s.homepage       = package['homepage']
  s.source         = { :git => package['repository']['url'] }
  s.platform       = :ios, '7.0'
  s.dependency 'React'
  s.source_files   = '*.{h,m}'
  s.preserve_paths = '*.js'
end
