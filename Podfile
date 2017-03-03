# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'
use_frameworks!
inhibit_all_warnings!

workspace 'RxAppDemo.xcworkspace'

# reactive programming
pod 'RxSwift'
pod 'RxCocoa'

target 'ReactiveBegining' do
	project 'ReactiveBegining/ReactiveBegining.xcodeproj'
end

target 'ReactiveLogin' do
	project 'ReactiveLogin/ReactiveLogin.xcodeproj'
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
end

target 'ReactiveCocoa' do
	project 'ReactiveCocoa/ReactiveCocoa.xcodeproj'
end