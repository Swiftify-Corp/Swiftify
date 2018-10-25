//
//  Article.m
//  GoT
//
//  Created by Paciej on 25/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import "Article.h"

static NSString *kArticleIdentifier = @"privateIdentifier";
static NSString *kArticleTitle = @"privateTitle";
static NSString *kArticleAbstract = @"privateAbstract";
static NSString *kArticleThumbnailURL = @"privateThumbnailURLString";
static NSString *kArticleThumbnailData = @"thumbnailData";

@interface Article ()

@property(nonatomic, copy, nonnull) NSString *privateIdentifier;
@property(nonatomic, copy, nonnull) NSString *privateTitle;
@property(nonatomic, copy, nonnull) NSString *privateAbstract;
@property(nonatomic, copy, nonnull) NSString *privateThumbnailURLString;
@property(nonatomic, copy, nonnull) NSString *privateUrlString;

@end

@implementation Article

- (nonnull instancetype)initWithIdentifier:(nonnull NSString *)identifier
                                     title:(nonnull NSString *)title
                                  abstract:(nonnull NSString *)abstract
                                 urlString:(nonnull NSString *)urlString
                        thumbnailURLString:
(nonnull NSString *)thumbnailURLString {
    self = [super init];
    if (self) {
        self.privateIdentifier = identifier;
        self.privateTitle = title;
        self.privateAbstract = abstract;
        self.privateUrlString = urlString;
        self.privateThumbnailURLString = thumbnailURLString;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.privateIdentifier forKey:kArticleIdentifier];
    [aCoder encodeObject:self.privateTitle forKey:kArticleTitle];
    [aCoder encodeObject:self.privateAbstract forKey:kArticleAbstract];
    [aCoder encodeObject:self.privateThumbnailURLString
                  forKey:kArticleThumbnailURL];
    [aCoder encodeObject:self.thumbnailData forKey:kArticleThumbnailData];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.privateIdentifier = [aDecoder decodeObjectForKey:kArticleIdentifier];
        self.privateTitle = [aDecoder decodeObjectForKey:kArticleTitle];
        self.privateAbstract = [aDecoder decodeObjectForKey:kArticleAbstract];
        self.privateThumbnailURLString =
        [aDecoder decodeObjectForKey:kArticleThumbnailURL];
        self.thumbnailData = [aDecoder decodeObjectForKey:kArticleThumbnailData];
    }
    return self;
}

- (nullable UIImage *)imageFromThumbnailData {
    return [UIImage imageWithData:self.thumbnailData];
}

- (NSString *)identifier {
    return self.privateIdentifier;
}

- (NSString *)title {
    return self.privateTitle;
}

- (NSString *)abstract {
    return self.privateAbstract;
}

- (NSString *)thumbnailURLString {
    return self.privateThumbnailURLString;
}

- (NSString *)urlString {
    return self.privateUrlString;
}
@end
