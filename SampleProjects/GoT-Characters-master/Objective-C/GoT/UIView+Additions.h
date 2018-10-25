//
//  UIView+Additions.h
//  ParallaxDemo
//
//  Created by Paciej on 18/10/15.
//  Copyright (c) 2015 Paciej. All rights reserved.
//

#import <UIKit/UIView.h>

@interface UIView (Additions)

/** Creates constraints from array of visual format language strings and adds
 * them to the view*/
+ (void)addConstraintsFromStrings:(NSArray *)strings
                      withMetrics:(NSDictionary *)metrics
                         andViews:(NSDictionary *)views
                           toView:(UIView *)view;

/** Creates view ready-to-use with auto layout */
+ (instancetype)autolayoutView;

@end
