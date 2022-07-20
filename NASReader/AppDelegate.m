//
//  AppDelegate.m
//  NASReader
//
//  Created by oneko on 2022/6/30.
//

#import "AppDelegate.h"
#import "NASReader-Swift.h"

@interface AppDelegate ()

@property (nonatomic, strong) DYReaderCoordinator *readerCoordinator;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    window.backgroundColor = UIColor.whiteColor;
    DYReaderCoordinator *readerCoordinator = [[DYReaderCoordinator alloc] initWithNavigationController:[UINavigationController new]];
    [readerCoordinator start];
    window.rootViewController = readerCoordinator.navigationController;
    
//    window.rootViewController =
    [window makeKeyAndVisible];
    self.readerCoordinator = readerCoordinator;
    self.window = window;
    
    return YES;
}


@end
