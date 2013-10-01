test-osx:
	xctool -scheme 'OS X Tests' build -sdk macosx -configuration Release
	xctool -scheme 'OS X Tests' build-tests -sdk macosx -configuration Release
	xctool -scheme 'OS X Tests' test -test-sdk macosx -sdk macosx -configuration Release

test-ios:
	xctool -scheme 'iOS Tests' build -sdk iphonesimulator -configuration Release
	xctool -scheme 'iOS Tests' build-tests -sdk iphonesimulator -configuration Release
	xctool -scheme 'iOS Tests' test -test-sdk iphonesimulator -sdk iphonesimulator -configuration Release

test-podspec:
	pod lib lint

test: test-osx test-ios test-podspec
