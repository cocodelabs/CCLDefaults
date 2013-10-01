//
//  CCLDefaults.m
//  Cocode
//
//  Created by Kyle Fuller on 12/08/2012.
//  Copyright (c) 2012-2013 Cocode. All rights reserved.
//

#import "CCLDefaults.h"

NSString * const CCLStoreVersionKey = @"CCLStoreVersion";

@implementation CCLDefaults

- (instancetype)init {
    return [self initWithUserDefaults:[NSUserDefaults standardUserDefaults] ubiquitousKeyValueStore:[NSUbiquitousKeyValueStore defaultStore] bundle:[NSBundle mainBundle]];
}

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults ubiquitousKeyValueStore:(NSUbiquitousKeyValueStore *)ubiquitousKeyValueStore bundle:(NSBundle *)bundle {
    NSParameterAssert(userDefaults != nil);
    NSParameterAssert(bundle != nil);

    if (self = [super init]) {
        _userDefaults = userDefaults;
        _ubiquitousKeyValueStore = ubiquitousKeyValueStore;
        _bundle = bundle;

        NSString *defaultsFile = [self defaultsFile];
        if (defaultsFile != nil) {
            NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:defaultsFile];
            [userDefaults registerDefaults:defaults];
        }

        if (ubiquitousKeyValueStore) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateKVStoreItems:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:ubiquitousKeyValueStore];
            [ubiquitousKeyValueStore synchronize];
        }

        if ([self automaticallyUpgradesStore]) {
            [self upgradeStore];
        }
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:_ubiquitousKeyValueStore];

    if ([[self userDefaults] synchronize] == NO) {
        NSLog(@"CLLDefaults: Failed to synchronize user defaults");
    }
}

- (NSString *)defaultsFile {
    NSString *defaultsFile = [_bundle pathForResource:@"CCLDefaults" ofType:@"plist"];
    return defaultsFile;
}

- (NSDictionary *)defaultsDictionary {
    NSString *defaultsFile = [self defaultsFile];
    NSDictionary *defaults;

    if (defaultsFile) {
        defaults = [NSDictionary dictionaryWithContentsOfFile:defaultsFile];
    }

    return defaults;
}

- (void)updateKVStoreItems:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];

    if (reasonForChange) {
        NSInteger reason = [reasonForChange integerValue];
        if ((reason == NSUbiquitousKeyValueStoreServerChange) || (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
            NSArray *changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
            NSUserDefaults *userDefaults = [self userDefaults];

            for (NSString *key in changedKeys) {
                id value = [_ubiquitousKeyValueStore objectForKey:key];
                [self willChangeValueForKey:key];
                [userDefaults setObject:value forKey:key];
                [self didChangeValueForKey:key];
            }
        }
    }
}

- (BOOL)automaticallyUpgradesStore {
    return YES;
}

- (void)upgradeStore {
    NSUserDefaults *userDefaults = [self userDefaults];

    NSNumber *versionNumber = [userDefaults objectForKey:CCLStoreVersionKey];

    NSDictionary *infoDictionary = [_bundle infoDictionary];
    NSUInteger currentVersion = (NSUInteger)[[infoDictionary valueForKey:@"CFBundleVersion"] unsignedIntegerValue];

    if (versionNumber) {
        NSUInteger version = [versionNumber unsignedIntegerValue];

        if (version != currentVersion) {
            [self upgradeFromVersion:version toVersion:currentVersion];
        }
    } else {
        [self upgradeFromVersion:0 toVersion:currentVersion];
    }

    [userDefaults setObject:@(currentVersion) forKey:CCLStoreVersionKey];
}

- (void)upgradeFromVersion:(NSUInteger)existingVersion toVersion:(NSUInteger)newVersion {
    NSLog(@"CCLDefaults: Upgrading from version %lu to %lu", (unsigned long)existingVersion, (unsigned long)newVersion);
}

- (void)setObject:(id)object forKey:(NSString *)key {
    [self willChangeValueForKey:key];
    [[self userDefaults] setObject:object forKey:key];
    [[self ubiquitousKeyValueStore] setObject:object forKey:key];
    [self didChangeValueForKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    [[self userDefaults] removeObjectForKey:key];
    [[self ubiquitousKeyValueStore] removeObjectForKey:key];
}

#pragma mark - Getters

- (id)objectForKey:(NSString *)key {
    return [[self userDefaults] objectForKey:key];
}

- (id)objectOfClass:(Class)aClass forKey:(NSString *)key {
    id value = [[self userDefaults] objectForKey:key];
    id object;

    if ([value isKindOfClass:aClass]) {
        object = value;
    }

    return object;
}

- (BOOL)boolForKey:(NSString *)key {
    return [[self userDefaults] boolForKey:key];
}

#pragma mark - Object subscripting

- (id)objectForKeyedSubscript:(id <NSCopying>)key {
    id object;

    if ([(NSObject *)key isKindOfClass:[NSString class]]) {
        object = [[self userDefaults] objectForKey:(NSString *)key];
    }

    return object;
}

- (void)setObject:(id)object forKeyedSubscript:(id <NSCopying>)key {
    if ([(NSObject *)key isKindOfClass:[NSString class]]) {
        [self willChangeValueForKey:(NSString *)key];
        [[self userDefaults] setObject:object forKey:(NSString *)key];
        [[self ubiquitousKeyValueStore] setObject:object forKey:(NSString *)key];
        [self didChangeValueForKey:(NSString *)key];
    }
}

@end
