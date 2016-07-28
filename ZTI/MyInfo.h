//
//  MyInfo.h
//  ZTI
//
//  Created by Lukasz Matuszczak on 13/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyInfo : NSObject
+(BOOL) setToken:(NSString*) sha1Result;
+(NSString*) getToken;
+(void) delAllInfo;

+(BOOL) setID:(NSString*) idToken;
+(NSString*) getID;

@end
