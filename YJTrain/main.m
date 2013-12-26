//
//  main.m
//  YJTrain
//
//  Created by zhongyy on 13-12-24.
//  Copyright (c) 2013年 szfore.  All rights reserved.
//

#import <UIKit/UIKit.h>

#import "wax.h"
#import "wax_http.h"
#import "wax_json.h"
#import "wax_filesystem.h"
int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    wax_start("AppDelegate", luaopen_wax_http, luaopen_wax_json,luaopen_wax_filesystem, nil);
    int retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate");
    [pool release];
    return retVal;
}
