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

#import "SettingsWindowController.h"
#import "PersistantData.h"
#import "Utils.h"

@implementation SettingsWindowController

@synthesize delegate;

- (id)init
{
    self = [super initWithWindowNibName:@"SettingsWindow"];
    if (self) 
    {
        [super windowDidLoad];
        [[self window] setDelegate:self];
        NSString * temp = [PersistantData retrieveFromUserDefaults:DATA_KEY_LAUNCH_AT_STARTUP];
        storedLaunchState = ([@"YES" compare:temp] == NSOrderedSame) ? NSOnState : NSOffState;
        [launchAtStartUp setState:storedLaunchState];
        intervals = [PersistantData retrieveFromUserDefaults:DATA_KEY_UPDATE_INTERVAL];
        intervals = [NSNumber numberWithInt:[intervals intValue] / 60];
        [updateIntervals setStringValue:[intervals stringValue]];
        storedUserId = [PersistantData retrieveFromUserDefaults:DATA_KEY_USER_ID];
        [[self window] center];
        [[self window] setLevel:NSFloatingWindowLevel];
    }
    
    return self;
}

- (void)windowDidLoad
{
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)showWindow:(id)sender
{
    [super showWindow:sender];
}

- (IBAction)saveAndClose:(id)sender 
{
    [[self window] performClose:self];
    [[self window] close];
}

- (NSInteger) updateFromFields 
{
    NSInteger flags = 0;
    NSString * str;
    str = [updateIntervals stringValue];
    if (str) 
    {
        int intVal = [str intValue];
        // avoid access to persistant data when no change happens
        if (intVal > 0)
        {
            if (intVal != [intervals intValue]) 
            {
                NSLog(@"Setting update interval to: %d minutes, the string is: %@", intVal, str);
                NSNumber * num = [NSNumber numberWithDouble:intVal * 60.];
                [PersistantData saveItemToPreferences:num withKey:DATA_KEY_UPDATE_INTERVAL];
                flags |= SETTINGS_UPDATE_INTERVAL_CHANGED;
            }
        }
    }
    str = [userId stringValue];
    if (str) 
    {
        int intVal = [str intValue];
        // avoid access to persistant data when no change happens
        if (intVal > 0) 
        {
            if (intVal != [storedUserId intValue])
            {
                NSNumber * num = [NSNumber numberWithInt:intVal];
                NSLog(@"Setting user id to: %d , the string is: %@", intVal, str);
                [PersistantData saveItemToPreferences:num withKey:DATA_KEY_USER_ID];
                flags |= SETTINGS_USER_ID_CHANGED;
            }
        }
    }
    NSInteger choice = [launchAtStartUp state];
    // avoid access to persistant data when no change happens
    if (choice != storedLaunchState) 
    {
        NSString * value;
        if (choice == NSOnState) 
        {
            [Utils addAppAsLoginItem];
            value = @"YES";
        }
        else
        {
            [Utils deleteAppFromLoginItem];
            value = @"NO";
        }
        [PersistantData saveItemToPreferences:value withKey:DATA_KEY_LAUNCH_AT_STARTUP];
        storedLaunchState = choice;
        flags |= SETTINGS_LAUNCH_ONSTART_CHANGED;
    }
    return flags;
}

- (BOOL)windowShouldClose:(id)sender 
{
    NSLog(@"Should close called");
    [delegate dataUpdated:[self updateFromFields]];
    return YES;
}
@end
