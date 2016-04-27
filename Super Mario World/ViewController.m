//
//  ViewController.m
//  Super Mario World
//
//  Created by J Lane on 3/31/16.
//  Copyright © 2016 Jonathan Lane. All rights reserved.
//

#import "ViewController.h"
#import "SocketIO.h"
@import CoreMotion;

@interface ViewController ()<SocketIODelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *instructionsView;
@property (strong, nonatomic) SocketIO *socketIO;
@property (strong, nonatomic) CMMotionManager *motionSensor;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self importSocket];
    [self animateInstructions];
    [self startMotionDetection];
}

- (void)importSocket {
    self.socketIO = [[SocketIO alloc] initWithDelegate:self];
    [self.socketIO connectToHost:@"10.0.1.13" onPort:4000];
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

-(CMMotionManager *)motionSensor {
    if (!_motionSensor) {
        _motionSensor = [[CMMotionManager alloc] init];
    }
    return _motionSensor;
}

- (void)startMotionDetection {
//    ViewController * __weak weakSelf = self;
    if (self.motionSensor.accelerometerAvailable) {
        self.motionSensor.accelerometerUpdateInterval = 1.0f/60.0f;
        [self.motionSensor startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *data, NSError *error) {
        
            [self handleAccelerometerData:data];
        }];
    }
}

- (void)handleAccelerometerData:(CMAccelerometerData *)data {
    
    NSInteger yValue = roundf(data.acceleration.y * 100.0f);
    NSInteger xValue = roundf(data.acceleration.x * 100.0f) - 48.0f;
    
    NSLog(@"x: %li, y: %li", (long)xValue, (long)yValue);

    if(labs(yValue) > 10) {
        
        if(yValue > 0) {
            
            [self marioRight];
        }
        else {
            
            [self marioLeft];
        }
    }
    else if(labs(xValue) > 20) {
        
        if(xValue > 0) {
            
            [self marioDown];
        }
        else {
            
            [self marioUp];
        }
    }
}

#pragma mark - Mario control

- (IBAction)marioAction:(id)sender {

    [self.socketIO sendEvent:@"actions" withData:@"action"];
}

- (IBAction)marioJump:(id)sender {

    [self.socketIO sendEvent:@"actions" withData:@"jump"];
}

- (void)marioUp {
    
    [self.socketIO sendEvent:@"actions" withData:@"up"];
}

- (void)marioDown {
    
    [self.socketIO sendEvent:@"actions" withData:@"down"];
}

- (void)marioLeft {
    
    [self.socketIO sendEvent:@"actions" withData:@"left"];
}

- (void)marioRight {
    
    [self.socketIO sendEvent:@"actions" withData:@"right"];
}

//#pragma mark - SocketIODelegate
//
//- (void) socketIODidConnect:(SocketIO *)socket {
//
//    NSLog(@"Did Connect");
//    
//}
//
//- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
//    
//    NSLog(@"Did Discconnect: %@", error.localizedDescription);
//}
//
//- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet {
//    
//    NSLog(@"Did Send Message");
//}
//
//- (void) socketIO:(SocketIO *)socket onError:(NSError *)error {
//    
//    NSLog(@"Did Error: %@", error.localizedDescription);
//}

@end
