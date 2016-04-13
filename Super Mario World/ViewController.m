//
//  ViewController.m
//  Super Mario World
//
//  Created by J Lane on 3/31/16.
//  Copyright © 2016 Jonathan Lane. All rights reserved.
//

#import "ViewController.h"
#import "SocketIO.h"

@interface ViewController ()<SocketIODelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *instructionsView;
@property (strong, nonatomic) SocketIO *socketIO;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self importSocket];
    [self animateInstructions];
}

- (void)importSocket {
    self.socketIO = [[SocketIO alloc] initWithDelegate:self];
    [self.socketIO connectToHost:@"localhost" onPort:3000];
}

- (void)animateInstructions {
    self.instructionsView.alpha = 0;
    
    [UIView animateWithDuration:1
                          delay:0
                        options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.instructionsView.alpha = 1;
                     } completion:nil];
}

- (IBAction)marioAction:(id)sender {
    [self.socketIO sendMessage:@"action"];
}

- (IBAction)marioJump:(id)sender {
    [self.socketIO sendMessage:@"jump"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
