//
//  Reachability+Methods.m
//  Primo
//
//  Created by Jarrett Chen on 6/11/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "Reachability+Methods.h"

@implementation Reachability (Methods)

- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired = [curReach connectionRequired];
    
    switch (netStatus)
    {
        case NotReachable:{
            NSString *statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            NSLog(@"%@",statusString);
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            
            
            break;
        }
        default:{
            NSLog(@"Has internet");
            break;
        }
            
    }
    
}




@end
