test-osx:
	xcodebuild -workspace CCLDefaults.xcworkspace -scheme 'OS X Tests' test | xcpretty -c; exit ${PIPESTATUS[0]}

test-ios:
	xcodebuild -workspace CCLDefaults.xcworkspace -scheme 'iOS Tests' test | xcpretty -c; exit ${PIPESTATUS[0]}

test-podspec:
	pod lib lint

test: test-osx test-podspec
