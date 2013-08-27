//
//  CCLExampleDefaults.m
//  Cocode
//
//  Created by Kyle Fuller on 27/08/2013.
//  Copyright (c) 2013 Kyle Fuller. All rights reserved.
//

#import "CCLExampleDefaults.h"

@implementation CCLExampleDefaults

- (NSDictionary *)defaultsDictionary {
    return @{
        @"name": @"Kyle Fuller",
    };
}

- (void)setName:(NSString *)name {
    [self setObject:name forKey:@"name"];
}

- (NSString *)name {
    return [self objectForKey:@"name"];
}

@end
