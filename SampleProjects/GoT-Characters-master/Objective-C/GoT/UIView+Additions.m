//
//  UIView+Additions.m
//  ParallaxDemo
//
//  Created by Paciej on 18/10/15.
//  Copyright (c) 2015 Paciej. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

+ (void)addEdgeConstraint:(NSLayoutAttribute)edge
                superview:(UIView *)superview
                  subview:(UIView *)subview {
    [superview
     addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                attribute:edge
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:superview
                                                attribute:edge
                                               multiplier:1
                                                 constant:0]];
}

+ (void)addConstraintsFromStrings:(NSArray *)strings
                      withMetrics:(NSDictionary *)metrics
                         andViews:(NSDictionary *)views
                           toView:(UIView *)view {
    NSMutableArray *constraints = [NSMutableArray new];
    for (NSString *string in strings) {
        [constraints addObjectsFromArray:[NSLayoutConstraint
                                          constraintsWithVisualFormat:string
                                          options:0
                                          metrics:metrics
                                          views:views]];
    }
    [view addConstraints:constraints];
}

+ (instancetype)autolayoutView {
    UIView *view = [[[self class] alloc] initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
