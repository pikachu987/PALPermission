#
# Be sure to run `pod lib lint PALPermission.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PALPermission'
  s.version          = '0.1.0'
  s.summary          = 'PALPermission'
  s.description      = <<-DESC
My Lib PALPermission
                       DESC
  s.homepage         = 'https://github.com/pikachu987/PALPermission'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pikachu987' => 'pikachu77769@gmail.com' }
  s.source           = { :git => 'https://github.com/pikachu987/PALPermission.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  
  s.subspec 'Gallery' do |sp|
      sp.source_files = 'PALPermission/Classes/PermissionType/Permission+Gallery.swift', 'PALPermission/Classes/*.swift'
  end
  
  s.subspec 'Camera' do |sp|
      sp.source_files = 'PALPermission/Classes/PermissionType/Permission+Camera.swift', 'PALPermission/Classes/*.swift'
  end
  
  s.subspec 'Audio' do |sp|
      sp.source_files = 'PALPermission/Classes/PermissionType/Permission+Audio.swift', 'PALPermission/Classes/*.swift'
  end
  
  s.subspec 'Contact' do |sp|
      sp.source_files = 'PALPermission/Classes/PermissionType/Permission+Contact.swift', 'PALPermission/Classes/*.swift'
  end
end
