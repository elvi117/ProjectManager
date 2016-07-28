//
//  MyInfo.m
//  ZTI
//
//  Created by Lukasz Matuszczak on 13/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import "MyInfo.h"

@implementation MyInfo

+(BOOL) setToken:(NSString*) sha1Result{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sha1Result forKey:@"Token"];
    [defaults synchronize];
    return true;
}
+(NSString*) getToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"Token"];

}

+(BOOL) setID:(NSString*) idToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:idToken forKey:@"Name"];
    [defaults synchronize];
    return true;
}
+(NSString*) getID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"Name"];
    
}
+(void) delAllInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"Name?Surname"];
    [defaults synchronize];
    [defaults setObject:@"" forKey:@"Token?Surname"];
    [defaults synchronize];


}
@end
