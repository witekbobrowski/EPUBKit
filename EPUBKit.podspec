Pod::Spec.new do |s|

  s.name         = "EPUBKit"
  s.version      = "0.0.1"
  s.summary      = "A simple swift library to parse and display EPUB files."
  s.description  = <<-DESC
  EPUBKit was created with simplicity in mind. Easily parse EPUB files and display them using a custom view.
                   DESC

  s.homepage     = "https://github.com/witekbobrowski/EPUBKit"
  s.license      = "MIT"
  s.author             = { "witekbobrowski" => "witek@bobrowski.com.pl" }
  s.social_media_url   = "https://github.com/witekbobrowski"
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/witekbobrowski/EPUBKit.git", :tag => "master" }
  s.source_files  = "EPUBKit", "EPUBKit/**/*.{h,m}"

  s.libraries  = "z"
  s.dependency 'Zip', '~> 0.7'
  s.dependency 'AEXML', '~> 4.1'

end
