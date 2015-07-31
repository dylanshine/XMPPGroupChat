//
//  ViewController.m
//  XMPPGroupChat
//
//  Created by Dylan Shine on 7/30/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "ViewController.h"
#import "XMPPManager.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource,MessageDelegate>
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) XMPPManager *xmppManager;
@property (nonatomic) NSMutableArray *messages;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.xmppManager = [XMPPManager sharedManager];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.xmppManager.messageDelegate = self;
    self.messages = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *messagesDict = (NSDictionary *)self.messages[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [messagesDict objectForKey:@"message"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;
    
    return cell;
}

- (IBAction)sendButton:(id)sender {
    NSString *messageString = self.messageField.text;
    
    if([messageString length] > 0) {
        [self.xmppManager.xmppRoom sendMessageWithBody:messageString];
    }
}

-(void)messageReceived:(NSDictionary *)message {
    [self.messages addObject:message];
    [self.tableView reloadData];
    
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:self.messages.count-1
                                                   inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:topIndexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
}

@end
