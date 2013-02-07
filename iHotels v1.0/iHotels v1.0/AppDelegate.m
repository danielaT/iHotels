//
//  AppDelegate.m
//  iHotels v1.0
//
//  Created by Student14 on 1/30/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "AppDelegate.h"
#import "HotelVisited.h"
#import "Reservation.h"
#import "HotelVisited.h"
#import "Friend.h"

//#import "MasterViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self isVisited];
    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
//        splitViewController.delegate = (id)navigationController.topViewController;
//        
//        UINavigationController *masterNavigationController = splitViewController.viewControllers[0];
//        MasterViewController *controller = (MasterViewController *)masterNavigationController.topViewController;
//        controller.managedObjectContext = self.managedObjectContext;
//    } else {
//        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//        MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
//        controller.managedObjectContext = self.managedObjectContext;
//    }
//    HotelVisited *hotel = [ NSEntityDescription insertNewObjectForEntityForName:@"HotelVisited" inManagedObjectContext:self.managedObjectContext];
//    hotel.hotelName = @"My first visited hotel";
    
    // set the color of the tabbar
    UITabBarController  * controller = (UITabBarController*)self.window.rootViewController;
    if ([controller.tabBar respondsToSelector:@selector(setBackgroundImage:)] )
    {
        UIImage *image = [[UIImage imageNamed:@"iphone_tabbar"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        
        [controller.tabBar setBackgroundImage :image];
        [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithHue:0.1417 saturation:10 brightness:60 alpha:0.5]];
    }
    
    [FBProfilePictureView class];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self isVisited];
}

- (void) isVisited
{
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
    NSArray* orders = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    NSError *error1;
    
    for(Reservation* res in orders)
    {
        //NSLog(@"is visited: %d", (int)res.isVisited);
        if( res.isVisited == YES)
        {
            HotelVisited *hotelVisited = [ NSEntityDescription insertNewObjectForEntityForName:@"HotelVisited" inManagedObjectContext:self.managedObjectContext];
            hotelVisited.startDate = res.startDate;
            hotelVisited.hotelImage = res.hotelImage;
            hotelVisited.hotelName = res.hotelName;
            hotelVisited.friends = res.friends;
            hotelVisited.hotelRate = res.hotelRate;
            //delete from database res
            [self.managedObjectContext deleteObject:res];
            [self.managedObjectContext save:&error1];
        }
    }
    
//    NSFetchRequest *request2 = [[NSFetchRequest alloc] initWithEntityName:@"Friend"];
//    NSArray* orders2 = [self.managedObjectContext executeFetchRequest:request2 error:&error1];
//    
//    for(Friend* fr in orders2)
//    {
//        NSLog(@"fr: %@",fr.name);
//    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iHotels_v1_0" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iHotels_v1_0.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
