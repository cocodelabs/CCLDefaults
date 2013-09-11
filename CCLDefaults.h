//
//  CCLDefaults.h
//  Cocode
//
//  Created by Kyle Fuller on 12/08/2012.
//  Copyright (c) 2012-2013 Cocode. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 CCLDefaults is a class which allows you to user defaults directly to iCloud.
 */
@interface CCLDefaults : NSObject

@property (nonatomic, strong, readonly) NSUserDefaults *userDefaults;
@property (nonatomic, strong, readonly) NSUbiquitousKeyValueStore *ubiquitousKeyValueStore;
@property (nonatomic, strong, readonly) NSBundle *bundle;

/** Initialize CCLDefaults, it will use the standard user defaults, the default ubiquitous key value store and the main bundle. */
- (instancetype)init;

/** Initialize CCLDefaults with custom backing user defaults, ubiquitous key value store and bundle.
 @note Providing nil for ubiquitous key value store will disable iCloud sync for values. */
- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults ubiquitousKeyValueStore:(NSUbiquitousKeyValueStore *)ubiquitousKeyValueStore bundle:(NSBundle *)bundle;

/** A method to return a dictionary of default values.
 By default, this will use the file returned by `defaultsFile`. However, you can overide this method to return custom defaults from code.
 */
- (NSDictionary *)defaultsDictionary;

/** A file to register defaults on initialization of the class.
 By default, this returns `DefaultPreferences.plist` in your bundle.
 */
- (NSString *)defaultsFile;

/** When the store is opened from a new version, call this method allowing a subclass to clean-up any values from previous releases.
 @note The existing version will be 0 if this is a clean install.
 */
- (void)upgradeFromVersion:(NSUInteger)existingVersion toVersion:(NSUInteger)newVersion;

/** Set the value of the defaults key in user defaults, and stores this in the ubiquitous key value store. */
- (void)setObject:(id)object forKey:(NSString *)key;

/** Retrieve the object associated with the key in the user defaults or the defaults dictionary */
- (id)objectForKey:(NSString *)key;

/** Gets a value of a specific type. */
- (id)objectOfClass:(Class)aClass forKey:(NSString *)key;

/** Returns the Boolean value associated with the specified key/ */
- (BOOL)boolForKey:(NSString *)key;

/** Removes the value associated with the specified key from defaults. */
- (void)removeObjectForKey:(NSString *)key;

@end

