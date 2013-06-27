//
//  AppDelegate.h
//  frontpage
//
//  Created by Gabriel O'Flaherty-Chan on 2013-06-27.
//  Copyright (c) 2013 Gabrieloc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "frontpageIncrementalStore.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
