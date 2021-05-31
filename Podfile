# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ReDawaga' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ReDawaga

	pod 'ReSwift'
	pod 'ReSwiftThunk'

	pod 'Alamofire'
	pod 'PromiseKit'

	pod 'RealmSwift'
	pod 'SwiftyJSON'

	pod 'SnapKit'

	pod 'GoogleMaps'

  target 'ReDawagaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ReDawagaUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
