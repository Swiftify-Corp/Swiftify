//
//  NSData+JSON.m
//  GoT
//
//  Created by Paciej on 24/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import "NSData+JSON.h"

@implementation NSData (JSON)

- (id)JSONObject {
    return [NSJSONSerialization JSONObjectWithData:self
                                           options:NSJSONReadingAllowFragments
                                             error:nil];
}

@end
