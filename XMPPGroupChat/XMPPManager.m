//
//  XMPPManager.m
//  XMPPGroupChat
//
//  Created by Dylan Shine on 7/30/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "XMPPManager.h"

@implementation XMPPManager

+ (instancetype)sharedManager {
    static XMPPManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(BOOL)connect {
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream setHostName:@"localhost"];
    [self.xmppStream addDelegate:self
                   delegateQueue:dispatch_get_main_queue()];
    
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:@"chat@lasonic.local"]];
    
    NSError *error;
    if (![self.xmppStream connectWithTimeout:10 error:&error]) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return NO;
    }
    
    return YES;
    
}

-(void)xmppStreamDidConnect:(XMPPStream *)sender {
    self.isOpen = YES;
    NSError *error;
    if (![self.xmppStream authenticateAnonymously:&error]) {
         NSLog(@"Error: %@", [error localizedDescription]);
    }
}



@end
