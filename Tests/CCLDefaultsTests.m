//
//  CCLDefaultsTests.m
//  Cocode
//
//  Created by Kyle Fuller on 12/08/2012.
//  Copyright (c) 2012-2013 Cocode. All rights reserved.
//

#import <XCTest/XCTest.h>

#define EXP_SHORTHAND YES
#import "Expecta.h"

#import "OCMock.h"

#import "CCLDefaults.h"

@interface CCLDefaults (Private)
- (void)upgradeStore;
@end

@interface CCLTestDefaults : CCLDefaults
@end

@implementation CCLTestDefaults

- (NSString *)defaultsFile {
    return nil;
}

- (BOOL)automaticallyUpgradesStore {
    return NO;
}

@end


@interface CCLDefaultsTests : XCTestCase

@end

@implementation CCLDefaultsTests

- (void)testInitUsesDefaultStores {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUbiquitousKeyValueStore *keyValueStore = [NSUbiquitousKeyValueStore defaultStore];
    NSBundle *bundle = [NSBundle mainBundle];

    CCLDefaults *defaults = [[CCLDefaults alloc] init];

    expect([defaults userDefaults]).to.equal(userDefaults);
    expect([defaults ubiquitousKeyValueStore]).to.equal(keyValueStore);
    expect([defaults bundle]).to.equal(bundle);
}

- (void)testInitWithNilUserDefaultsRaisesException {
    expect(^{ (void)[[CCLDefaults alloc] initWithUserDefaults:nil ubiquitousKeyValueStore:[NSUbiquitousKeyValueStore defaultStore] bundle:nil]; }).to.raiseAny();
}

- (void)testInitWithNilUbiquitousKeyValueStoreRaisesException {
    expect(^{ (void)[[CCLDefaults alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults] ubiquitousKeyValueStore:nil bundle:nil]; }).to.raiseAny();
}

- (void)testInitWithNilBundleRaisesException {
    expect(^{ (void)[[CCLDefaults alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults] ubiquitousKeyValueStore:[NSUbiquitousKeyValueStore defaultStore] bundle:nil]; }).to.raiseAny();
}

- (void)testRegistersForUbiquitousKeyValueStoreDidChangeNotification {

}

- (void)testNewInstallCallsUpgradeStoreForExistingVersion0 {
    NSUbiquitousKeyValueStore *keyValueStore = [NSUbiquitousKeyValueStore defaultStore];
    id mockUserDefaults = [OCMockObject partialMockForObject:[NSUserDefaults standardUserDefaults]];
    id mockBundle = [OCMockObject mockForClass:[NSBundle class]];

    [[[mockUserDefaults expect] andReturn:nil] objectForKey:@"CCLStoreVersion"];
    [[[mockBundle expect] andReturn:@{@"CFBundleVersion": @1}] infoDictionary];
    [[mockUserDefaults expect] setObject:@1 forKey:@"CCLStoreVersion"];

    CCLDefaults *defaults = [[CCLTestDefaults alloc] initWithUserDefaults:mockUserDefaults ubiquitousKeyValueStore:keyValueStore bundle:mockBundle];

    id mockDefaults = [OCMockObject partialMockForObject:defaults];
    [[mockDefaults expect] upgradeFromVersion:0 toVersion:1];
    [mockDefaults upgradeStore];

    [mockDefaults verify];
}

- (void)testUpgradeStoreCallsUpgradeStore {
    NSUbiquitousKeyValueStore *keyValueStore = [NSUbiquitousKeyValueStore defaultStore];
    id mockUserDefaults = [OCMockObject partialMockForObject:[NSUserDefaults standardUserDefaults]];
    id mockBundle = [OCMockObject mockForClass:[NSBundle class]];

    [[[mockUserDefaults expect] andReturn:@1] objectForKey:@"CCLStoreVersion"];
    [[[mockBundle expect] andReturn:@{@"CFBundleVersion": @2}] infoDictionary];

    CCLDefaults *defaults = [[CCLTestDefaults alloc] initWithUserDefaults:mockUserDefaults ubiquitousKeyValueStore:keyValueStore bundle:mockBundle];

    id mockDefaults = [OCMockObject partialMockForObject:defaults];
    [[mockDefaults expect] upgradeFromVersion:1 toVersion:2];
    [mockDefaults upgradeStore];

    [mockDefaults verify];
}

- (void)testUpgradeShouldntUpgradeForSameVersion {
    NSUbiquitousKeyValueStore *keyValueStore = [NSUbiquitousKeyValueStore defaultStore];
    id mockUserDefaults = [OCMockObject partialMockForObject:[NSUserDefaults standardUserDefaults]];
    id mockBundle = [OCMockObject mockForClass:[NSBundle class]];

    [[[mockUserDefaults expect] andReturn:@2] objectForKey:@"CCLStoreVersion"];
    [[[mockBundle expect] andReturn:@{@"CFBundleVersion": @2}] infoDictionary];

    CCLDefaults *defaults = [[CCLTestDefaults alloc] initWithUserDefaults:mockUserDefaults ubiquitousKeyValueStore:keyValueStore bundle:mockBundle];

    id mockDefaults = [OCMockObject partialMockForObject:defaults];
    [[mockDefaults reject] upgradeFromVersion:2 toVersion:2];
    [mockDefaults upgradeStore];

    [mockDefaults verify];
}

- (void)testUpgradeStoreSavesNewVersion {
    NSUbiquitousKeyValueStore *keyValueStore = [NSUbiquitousKeyValueStore defaultStore];    
    id mockUserDefaults = [OCMockObject partialMockForObject:[NSUserDefaults standardUserDefaults]];
    id mockBundle = [OCMockObject mockForClass:[NSBundle class]];

    [[[mockBundle expect] andReturn:@{@"CFBundleVersion": @5}] infoDictionary];
    [[mockUserDefaults expect] setObject:@5 forKey:@"CCLStoreVersion"];

    CCLTestDefaults *defaults = [[CCLTestDefaults alloc] initWithUserDefaults:mockUserDefaults ubiquitousKeyValueStore:keyValueStore bundle:mockBundle];
    [defaults upgradeStore];

    [mockUserDefaults verify];
}

@end
