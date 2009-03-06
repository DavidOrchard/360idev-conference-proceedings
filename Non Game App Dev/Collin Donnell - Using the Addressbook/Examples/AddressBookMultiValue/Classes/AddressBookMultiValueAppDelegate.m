//
//  AddressBookMultiValueAppDelegate.m
//  AddressBookMultiValue
//
//  Created by Collin Donnell on 2/23/09.
//  Copyright Collin Donnell 2009. All rights reserved.
//

#import "AddressBookMultiValueAppDelegate.h"
#import <AddressBook/AddressBook.h>

@implementation AddressBookMultiValueAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    NSInteger identifier;
    ABMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue, CFSTR("(123) 456-6789"), kABHomeLabel, &identifier);
    
    ABRecordRef person = ABPersonCreate();
    ABRecordSetValue(person, kABPersonFirstNameProperty, CFSTR("Benjamin"), NULL);
    ABRecordSetValue(person, kABPersonLastNameProperty, CFSTR("Linus"), NULL);
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, NULL);
    
    ABMultiValueRef personPhoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSInteger indexForValue = ABMultiValueGetIndexForIdentifier(personPhoneNumbers, identifier);
    CFStringRef label = ABMultiValueCopyLabelAtIndex(personPhoneNumbers, indexForValue);
    NSString *labelName = (NSString *)ABAddressBookCopyLocalizedLabel(label);
    NSString *value = (NSString *)ABMultiValueCopyValueAtIndex(personPhoneNumbers, indexForValue);
    
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView setTitle:labelName];
    [alertView setMessage:value];
    [alertView addButtonWithTitle:@"Alright"];
    [alertView show];
    [alertView release];
 
    CFRelease(label);   
    CFRelease(personPhoneNumbers);
    CFRelease(phoneNumberMultiValue);
    CFRelease(person);
    [labelName release];
    [value release];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
