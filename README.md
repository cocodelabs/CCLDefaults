CCLDefaults
===========

[![Build Status](https://travis-ci.org/cocodelabs/CCLDefaults.png?branch=master)](https://travis-ci.org/cocodelabs/CCLDefaults)

A simple NSUserDefaults wrapper which optionally syncs to iCloud.

## Usage

You can either use CCLDefaults directly, or subclass it to provide methods for
your application to use.

```objective-c
@implementation CCLExampleDefaults : CCLDefaults

- (NSDictionary *)defaultsDictionary {
    return @{
        @"name": @"Kyle Fuller",
        @"featureXEnabled": @NO,
    };
}

- (void)setName:(NSString *)name {
    [self setObject:name forKey:@"name"];
}

- (NSString *)name {
    return [self objectForKey:@"name"];
}

- (BOOL)hasFeatureXEnabled {
    return [[self objectForKey:@"featureXEnabled"] boolValue];
}

- (void)setFeatureXEnabled:(BOOL)featureXEnabled {
    [self setObject:@(featureXEnabled) forKey:@"featureXEnabled"];
}

@end
```

Now you can get hold of an instance and use the created getter and setter:

```objective-c
CCLExampleDefaults *defaults = [[CCLExampleDefaults alloc] init];
[defaults setName:@"Kyle"];
```

### Default values

If you want to have initial values for your keys, then you can either create a
plist called `CCLDefaults.plist` or override `defaultsDictionary`.

#### CCLDefaults.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>name</key>
    <string>Kyle</string>
    <key>featureXEnabled</key>
    </false>
</dict>
</plist>
```

#### defaultsDictionary

```objective-c
- (NSDictionary *)defaultsDictionary {
    return @{
        @"name": @"Kyle Fuller",
        @"featureXEnabled": @NO,
    };
}
```

### Key-value observing

CCLDefaults already implements KVO so you can simply observe for notifications
when a value changes.

### Application update callback

When your application is upgraded by the user, CCLDefaults provides a callback
so you can do any maintenance on the user defaults that you need.

The versions are simply your version number (CFBundleVersion).

```objective-c
- (void)upgradeFromVersion:(NSUInteger)existingVersion toVersion:(NSUInteger)newVersion {
    // In version 32, we renamed a key
    if (existingVersion < 32 && newVersion >= 32) {
        id renamedObject = [self objectForKey:@"renamedKey"];

        if (renamedObject) {
            [self setObject:renamedObject forKey:@"newKey"];
        }
    }
}
```

## Installation

[CocoaPods](http://cocoapods.org) is the recommended way to add
CCLDefaults to your project.

Here's an example podfile that installs CCLDefaults.

### Podfile

```ruby
platform :ios, '5.0'

pod 'CCLDefaults'
```

## License

CCLDefaults is released under the BSD license. See [LICENSE](LICENSE).

