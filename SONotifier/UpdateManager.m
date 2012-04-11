/*
 * Copyright (C) 2012 Binyamin Sharet
 *
 * This file is part of SONotifier.
 * 
 * SONotifier is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * SONotifier is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with SONotifier. If not, see <http://www.gnu.org/licenses/>.
 */

#import "UpdateManager.h"
#import "UserData.h"
#import "PersistantData.h"

@implementation UpdateManager

@synthesize updateDelegate = updateDelegate;
@synthesize userData = userData;
@synthesize userId;

- (id) init {
    self = [super init];
    if (self) {
        updateTimer = nil;
        userData = [[UserData alloc] init];
    }
    return self;
}

- (void) dealloc {
    [updateTimer invalidate];
    updateTimer = nil;
    [userData release];
    userData = nil;
}

- (void) bgUpdate {
    NSString * urlString;
    NSURLRequest *request;
    NSData * response;
    NSString *responseStr;
    BOOL problem = NO;
    
    NSLog(@"[UpdateManager/bgUpdate] Getting user info");    
    urlString = [NSString stringWithFormat:@"http://api.stackexchange.com/2.0/users/%@?site=stackoverflow", userId];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];    
    response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (response != nil) {
        responseStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@", responseStr);
        if (responseStr != nil){
            [userData updateInfoFromJsonString:responseStr];
            [PersistantData saveItemToPreferences:responseStr withKey:DATA_KEY_USER_INFO];
        } else {
            problem = YES;
        }
        [responseStr release];
    }
    else {
        problem = YES;
    }
    

    NSLog(@"[UpdateManager/bgUpdate] Getting reputation changes");    
    urlString = [NSString stringWithFormat:@"http://api.stackexchange.com/2.0/users/%@/reputation?page=1&pagesize=7&site=stackoverflow&filter=!amIOctbmUQ-Bx0", userId];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];    
    response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (response != nil) {
        responseStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@", responseStr);
        if (responseStr != nil){
            [userData updateLastChangesFromJsonString:responseStr];
            [PersistantData saveItemToPreferences:responseStr withKey:DATA_KEY_REPUTATION_CHANGE];
        } else {
            problem = YES;
        }
        [responseStr release];
    }
    else {
        problem = YES;
    }

    [updateDelegate updateCompletedWithUpdater:self];
    if (problem == YES) {
        [updateDelegate updateFailedForProblem:UPDATE_PROBLEM_CONNECTION];
    }
    NSLog(@"[UpdateManager/bgUpdate] exit");
}

- (void) update {
    [self performSelectorInBackground:@selector(bgUpdate) withObject:nil];
    [self scheduleUpdate];
}

- (void) scheduleUpdate {
    [updateTimer invalidate];
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:updateInterval target:self selector:@selector(update) userInfo:nil repeats:NO];
}

- (void) startRunning {
    NSString * savedData = [PersistantData retrieveFromUserDefaults:DATA_KEY_USER_INFO];
    if (savedData != nil) {
        [userData updateInfoFromJsonString:savedData];
    }
    savedData = [PersistantData retrieveFromUserDefaults:DATA_KEY_REPUTATION_CHANGE];
    if (savedData != nil) {
        [userData updateLastChangesFromJsonString:savedData];
    }
    [updateDelegate updateCompletedWithUpdater:self];
    [updateDelegate updateFailedForProblem:UPDATE_PROBLEM_NOT_ONLINE_YET]; 
    [self update];
}

- (void) setUpdateInterval:(NSTimeInterval)interval {
    NSLog(@"[UpdateManager/setUpdateInterval] %f", interval);
    BOOL reschedule = updateInterval > interval;
    updateInterval = interval;
    if (reschedule) {
        [self scheduleUpdate];
    }
}

@end