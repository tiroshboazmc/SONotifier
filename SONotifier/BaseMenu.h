/*
 * Copyright (C) 2012 Binyamin Sharet
 *
 * This file is part of SecurityExchangeNotifier.
 * 
 * SecurityExchangeNotifier is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * SecurityExchangeNotifier is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with SecurityExchangeNotifier. If not, see <http://www.gnu.org/licenses/>.
 */

#import <Foundation/Foundation.h>
#import "UpdateManager.h"

@protocol BaseMenuDelegate <NSObject> 

- (void) showSettings;

@end

@interface BaseMenu : NSObject<UpdateDelegate, NSMenuDelegate> {
    NSStatusItem * statusItem;
    NSNumber * lastViewedRep;
    NSNumber * lastSetRep;
    NSInteger connect_status;
    unsigned long lastConnectionAttempt;
}

@property (nonatomic, retain) NSObject<BaseMenuDelegate> * delegate;
@property (nonatomic, retain) UpdateManager * updateManager;

- (void) buildUi;
- (void) setUpdateManager:(UpdateManager *)manager;
- (void) updateCompletedWithUpdater:(id)updater;
- (void) updateFailedForProblem:(UPDATE_PROBLEMS)problem;
- (void) menuWillOpen:(NSMenu *)menu;
- (void) menu:(NSMenu *)menu willHighlightItem:(NSMenuItem *)item;
@end
