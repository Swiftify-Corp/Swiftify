//
//  Article.h
//  GoT
//
//  Created by Paciej on 25/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Article : NSObject <NSCoding>

@property(nonatomic, readonly, nonnull) NSString *title;
@property(nonatomic, readonly, nonnull) NSString *identifier;
@property(nonatomic, readonly, nonnull) NSString *abstract;
@property(nonatomic, readonly, nonnull) NSString *urlString;
@property(nonatomic, readonly, nonnull) NSString *thumbnailURLString;
@property(nonatomic, strong, nullable) NSData *thumbnailData;

- (nonnull instancetype)initWithIdentifier:(nonnull NSString *)identifier
                                     title:(nonnull NSString *)title
                                  abstract:(nonnull NSString *)abstract
                                 urlString:(nonnull NSString *)urlString
                        thumbnailURLString:
(nonnull NSString *)thumbnailURLString;

- (nullable UIImage *)imageFromThumbnailData;

@end
