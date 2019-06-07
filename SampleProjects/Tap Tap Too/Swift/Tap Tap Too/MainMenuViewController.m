//
//  MainMenuViewController.m
//  Tap Tap Too
//
//  Created by Alejandro Zamudio Guajardo on 6/20/17.
//  Copyright © 2017 Adamant Jumper. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *matchesButton;
@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playButton.layer.borderWidth = 2.0;
    self.playButton.layer.borderColor = [[UIColor aquaColor] CGColor];
    self.playButton.tintColor = [UIColor aquaColor];
    self.playButton.layer.cornerRadius = 8.0;
    self.matchesButton.layer.borderWidth = 2.0;
    self.matchesButton.layer.borderColor = [[UIColor violetColor] CGColor];
    self.matchesButton.tintColor = [UIColor violetColor];
    self.matchesButton.layer.cornerRadius = 8.0;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden: NO animated: NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissViewControllerAnimated:(BOOL)flag {
    [[self navigationController] popViewControllerAnimated: YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString: @"Play Game"]) {
        InGameViewController * inGameViewController = [segue destinationViewController];
        inGameViewController.delegate = self;
    }
    else {
        
    }
}

@end
