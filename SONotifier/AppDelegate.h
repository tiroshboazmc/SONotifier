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
#import "BaseMenu.h"
#import "UpdateManager.h"
#import "SettingsWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, BaseMenuDelegate, SettingsWindowDelegate> {
    BaseMenu * menus;
    UpdateManager * updateManager;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) SettingsWindowController * settingWindow;

- (void) showSettings;
- (void) dataUpdated:(NSInteger)updateFlags;

@end
