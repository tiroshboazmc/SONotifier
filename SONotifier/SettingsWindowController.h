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

#import <Cocoa/Cocoa.h>

enum SETTING_UPDATE_FLAGS 
{
    SETTINGS_USER_ID_CHANGED            = 0x00000001,
    SETTINGS_UPDATE_INTERVAL_CHANGED    = 0x00000002,
    SETTINGS_LAUNCH_ONSTART_CHANGED     = 0x00000004,
};
@protocol SettingsWindowDelegate <NSObject>

- (void) dataUpdated:(NSInteger)updateFlags;

@end
@interface SettingsWindowController : NSWindowController <NSWindowDelegate>{
    IBOutlet NSButton *launchAtStartUp;
    IBOutlet NSTextField *favoriteTags;
    IBOutlet NSTextField *userId;
    IBOutlet NSTextField *updateIntervals;
    IBOutlet NSWindow *window;
    NSInteger storedLaunchState;
    NSNumber * intervals;
    NSNumber * storedUserId;
}

@property (nonatomic, retain) NSObject<SettingsWindowDelegate> * delegate;

- (BOOL)windowShouldClose:(id)sender;

@end
