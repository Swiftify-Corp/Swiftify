//
//  InGameViewController.h
//  Tap Tap Too
//
//  Created by Alejandro Zamudio Guajardo on 6/20/17.
//  Copyright © 2017 Adamant Jumper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+UIColor_CustomColors.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewControllerProtocols.h"

@interface InGameViewController : UIViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) id <UIViewControllerProtocols> delegate;

@end
