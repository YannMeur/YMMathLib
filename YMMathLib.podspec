#
# Be sure to run `pod lib lint YMMathLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YMMathLib'
  s.version          = '0.1.0'
  s.summary          = 'Implémentation en Swift des notions de Vecteur et de Matrice.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Implémente en Swift des notions de Vecteur et de Matrice pour pouvoir
faire des études et des calculs sur des séries de données.
Implémentation des principales opérations sur ces modèles mathématiques.
                       DESC

  s.homepage         = 'https://github.com/YannMeur/YMMathLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'YannMeur' => 'yann.meurisse@wanadoo.fr' }
  s.source           = { :git => 'https://github.com/YannMeur/YMMathLib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform = :osx
  s.osx.deployment_target = "10.10"

  s.source_files = 'YMMathLib/Classes/**/*'

  # s.resource_bundles = {
  #   'YMMathLib' => ['YMMathLib/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'Cocoa'
  # s.dependency 'AFNetworking', '~> 2.3'
  
end
