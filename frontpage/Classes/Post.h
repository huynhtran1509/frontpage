//
//  Post.h
//  frontpage
//
//  Created by Gabriel O'Flaherty-Chan on 2013-06-28.
//  Copyright (c) 2013 Gabrieloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * postID;
@property (nonatomic, retain) NSString * subreddit;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * thumbnail;

@end
