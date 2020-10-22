platform :ios, '12.4'

use_frameworks!


def available_pods
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'Firebase/Analytics'
  pod 'Firebase/Functions'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'
  pod 'Firebase/DynamicLinks'
  pod 'FirebaseFirestoreSwift'
  pod 'MultiSlider'
  pod 'SwiftLinkPreview'
  pod 'ActiveLabel'
  pod 'Cache', '5.3.0'
  pod 'lottie-ios'

end

target 'Dune' do
  available_pods
end

target 'Dune Dev' do
  available_pods
end

post_install do |pi|
   pi.pods_project.targets.each do |t|
       t.build_configurations.each do |bc|
           if bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] == '8.0'
             bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
           end
       end
   end
end
