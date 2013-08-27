test-osx:
	xctool -scheme 'OS X Tests' build -sdk macosx -configuration Release
	xctool -scheme 'OS X Tests' build-tests -sdk macosx -configuration Release
	xctool -scheme 'OS X Tests' test -test-sdk macosx -sdk macosx -configuration Release

test-podspec:
	pod spec lint CCLDefaults.podpec

test: test-osx test-podspec
