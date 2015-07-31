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
    self.xmppStream.hostName = @"lasonic.local";
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
    NSError *error;
    if (![self.xmppStream authenticateAnonymously:&error]) {
         NSLog(@"Error: %@", [error localizedDescription]);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    [self joinOrCreateRoom];
}

-(void)disconnect {
    [self.xmppStream disconnect];
}

-(void)joinOrCreateRoom {
    XMPPRoomMemoryStorage *roomMemory = [[XMPPRoomMemoryStorage alloc]init];
    XMPPJID  *roomJID = [XMPPJID jidWithString:@"chat@conference.lasonic.local"];
    self.xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomMemory
                                                      jid:roomJID
                                            dispatchQueue:dispatch_get_main_queue()];
    [self.xmppRoom activate:self.xmppStream];
    [self.xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppRoom joinRoomUsingNickname:[self createUUID]
                                 history:nil
                                password:nil];
}

-(NSString *)createUUID {
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidString;
}

-(void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID {
    NSString *msg = [[message elementForName:@"body"] stringValue];
    
    NSDictionary *messageDict = @{@"message":msg};
    
    if ([msg length]) {
        [self.messageDelegate messageReceived:messageDict];
    }
}

@end
