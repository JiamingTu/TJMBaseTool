#
# Be sure to run `pod lib lint TJMBaseTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TJMBaseTool'
  s.version          = '0.0.16'
  s.summary          = '自己用的基础模块'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    自己用的基础模块，包括AFN封装，等
                       DESC

  s.homepage         = 'https://github.com/JiamingTu/TJMBaseTool'
  # s.screenshots     = ''
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JiamingTu' => 'tujiamingdd@sina.com' }
  s.source           = { :git => 'https://github.com/JiamingTu/TJMBaseTool.git', :tag => s.version.to_s }
  # s.social_media_url = ''

  s.ios.deployment_target = '9.0'
  #s.public_header_files = 'TJMBaseTool/Classes/TJMBaseTool.h', 'TJMBaseTool/Classes/**/*.h','TJMBaseTool/Classes/**/**/*.h'
  
  
  # s.resource_bundles = {
  #   'TJMBaseTool' => ['TJMBaseTool/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'

  s.frameworks = 'UIKit'
  s.dependency 'AFNetworking'
  s.dependency 'MBProgressHUD'

  s.subspec 'Common' do |ss|
      ss.public_header_files = 'TJMBaseTool/Classes/Common/*.h'
      ss.source_files = 'TJMBaseTool/Classes/Common/*.{h,m}'
  end
  
  s.subspec 'JMCategory' do |ss|
      ss.dependency 'TJMBaseTool/Common'
      ss.public_header_files = 'TJMBaseTool/Classes/JMCategory/*.h'
      ss.source_files = 'TJMBaseTool/Classes/JMCategory/*.{h,m}'
  end
  
  s.subspec 'NetworkManager' do |ss|
      ss.dependency 'TJMBaseTool/Common'
      ss.dependency 'TJMBaseTool/JMCategory'
      ss.public_header_files = 'TJMBaseTool/Classes/NetworkManager/*.h'
      ss.source_files = 'TJMBaseTool/Classes/NetworkManager/*.{h,m}'
  end
  
  s.subspec 'HUDManager' do |ss|
      ss.dependency 'TJMBaseTool/Common'
      ss.dependency 'TJMBaseTool/JMCategory'
      ss.public_header_files = 'TJMBaseTool/Classes/HUDManager/*.h'
      ss.source_files = 'TJMBaseTool/Classes/HUDManager/*.{h,m}'
  end
  
  s.subspec 'SandBoxManager' do |ss|
      ss.dependency 'TJMBaseTool/Common'
      ss.dependency 'AFNetworking'
      ss.public_header_files = 'TJMBaseTool/Classes/SandBoxManager/*.h'
      ss.source_files = 'TJMBaseTool/Classes/SandBoxManager/*.{h,m}'
  end
  
  s.source_files = 'TJMBaseTool/Classes/TJMBaseTool.h'
  
end
