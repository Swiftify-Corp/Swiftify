//
//  InGameViewController.m
//  Tap Tap Too
//
//  Created by Alejandro Zamudio Guajardo on 6/20/17.
//  Copyright © 2017 Adamant Jumper. All rights reserved.
//

#import "InGameViewController.h"

@interface InGameViewController ()

@property (weak, nonatomic) IBOutlet UIButton *firstPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *secondPlayerButton;
@property (weak, nonatomic) IBOutlet UILabel *firstPlayerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstPlayerTapsLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerTapsLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstPlayerTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerTimerLabel;

@end

@implementation InGameViewController

int firstPlayerTapCount = 0;
int secondPlayerTapCount = 0;
int totalGameTime = 60;
NSTimer * gameTimer;
UIView * shadowView;
UIView * nameRegisteringView;
UILabel * registerLabel;
UITextField * nameInputTextField;
UIButton * continueButton;
UIView * winnerDisplayingView;
UILabel * gameWinnerLabel;
UILabel * gameResultLabel;
bool hasFirstPlayerBeenRegistered = NO;
AVAudioPlayer * gameAudioPlayer;
AVAudioPlayer * soundsAudioPlayer;
NSURL * gameMusic;
NSURL * gameEndedSound;
NSString * winnerName;
int winnerTaps;
bool isItATie = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUIElements];
    [self presentPlayerRegistrationView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadGameMusic {
    @try {
        gameMusic = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource: @"TimeGames" ofType: @"wav"]];
        gameAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: gameMusic error: nil];
    } @catch (NSException *exception) {
        NSLog(@"Music couldn't be load");
    }
    
    gameAudioPlayer.enableRate = YES;
    [gameAudioPlayer prepareToPlay];
    [gameAudioPlayer play];
    [gameAudioPlayer setVolume: 1.0];
    gameAudioPlayer.delegate = self;
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [gameAudioPlayer play];
}

- (void)configureUIElements {
    self.firstPlayerNameLabel.transform = CGAffineTransformMakeRotation(M_PI);
    self.firstPlayerTapsLabel.transform = CGAffineTransformMakeRotation(M_PI);
    self.firstPlayerTimerLabel.transform = CGAffineTransformMakeRotation(M_PI);
    [self.navigationController setNavigationBarHidden: YES animated: NO];
}

- (void)updateTotalGameTime {
    if (totalGameTime > 0) {
        if (totalGameTime < 30) {
            gameAudioPlayer.rate = 1.5;
        }
        
        if (totalGameTime < 15) {
            gameAudioPlayer.rate = 2.0;
        }
        
        totalGameTime = totalGameTime - 1;
        self.firstPlayerTimerLabel.text = [NSString stringWithFormat: @"%i", totalGameTime];
        self.secondPlayerTimerLabel.text = [NSString stringWithFormat: @"%i", totalGameTime];
    }
    else {
        [self endGame];
    }
}

- (void)startGame {
    [self loadGameMusic];
    gameTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector:@selector(updateTotalGameTime) userInfo: nil repeats: true];
}

- (void)endGame {
    [gameTimer invalidate];
    [gameAudioPlayer stop];
    @try {
        gameEndedSound = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource: @"buzzer_x" ofType: @"wav"]];
        soundsAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: gameEndedSound error: nil];
    } @catch (NSException *exception) {
        NSLog(@"Music couldn't be load");
    }
    [soundsAudioPlayer prepareToPlay];
    [soundsAudioPlayer play];
    [soundsAudioPlayer setVolume: 1.0];
    [self determineWinner];
    [self presentEndGameView];
}

- (void)determineWinner {
    if (firstPlayerTapCount > secondPlayerTapCount) {
        winnerName = self.firstPlayerNameLabel.text;
        winnerTaps = firstPlayerTapCount;
    }
    else if (firstPlayerTapCount < secondPlayerTapCount) {
        winnerName = self.secondPlayerNameLabel.text;
        winnerTaps = secondPlayerTapCount;
    }
    else {
        isItATie = YES;
        winnerTaps = firstPlayerTapCount;
    }
}

- (void)presentEndGameView {
    NSString * endGameText;
    if (isItATie) {
        endGameText = @"It is a tie!";
    }
    else {
        endGameText = [NSString stringWithFormat: @"%@%@", @"Winner: ", winnerName];
    }
    NSString * endGameTaps = [NSString stringWithFormat: @"%@%i", @"Taps: ", winnerTaps];
    CGRect frame = [[self view] frame];
    shadowView = [[UIView alloc] initWithFrame: frame];
    shadowView.backgroundColor = [UIColor shadowColor];
    frame = CGRectMake(self.view.frame.size.width / 8.0, self.view.frame.size.height / 4.0, self.view.frame.size.width / 1.3, self.view.frame.size.height / 3.0);
    winnerDisplayingView = [[UIView alloc] initWithFrame: frame];
    winnerDisplayingView.backgroundColor = [UIColor whiteColor];
    winnerDisplayingView.clipsToBounds = YES;
    winnerDisplayingView.layer.cornerRadius = 8;
    frame = CGRectMake(0.0, winnerDisplayingView.frame.size.height / 8.0, winnerDisplayingView.frame.size.width, winnerDisplayingView.frame.size.height / 6.0);
    gameWinnerLabel = [[UILabel alloc] initWithFrame: frame];
    gameWinnerLabel.backgroundColor = [UIColor whiteColor];
    gameWinnerLabel.textColor = [UIColor violetColor];
    gameWinnerLabel.text = endGameText;
    gameWinnerLabel.textAlignment = NSTextAlignmentCenter;
    gameWinnerLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 25];
    frame = CGRectMake(0.0, winnerDisplayingView.frame.size.height / 2.7, winnerDisplayingView.frame.size.width, winnerDisplayingView.frame.size.height / 6.0);
    gameResultLabel = [[UILabel alloc] initWithFrame: frame];
    gameResultLabel.backgroundColor = [UIColor whiteColor];
    gameResultLabel.textColor = [UIColor violetColor];
    gameResultLabel.text = endGameTaps;
    gameResultLabel.textAlignment = NSTextAlignmentCenter;
    gameResultLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 25];
    frame = CGRectMake(winnerDisplayingView.frame.size.width / 8.0, winnerDisplayingView.frame.size.height / 1.5, winnerDisplayingView.frame.size.width / 1.3, winnerDisplayingView.frame.size.height / 4.5);
    continueButton = [[UIButton alloc] initWithFrame: frame];
    continueButton.backgroundColor = [UIColor violetColor];
    continueButton.clipsToBounds = YES;
    continueButton.layer.cornerRadius = 8;
    [continueButton setTitle: @"Continue" forState: UIControlStateNormal];
    [continueButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    continueButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [continueButton addTarget: self action: @selector(registerMatch) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview: shadowView];
    [[self view] addSubview: winnerDisplayingView];
    [winnerDisplayingView addSubview: gameWinnerLabel];
    [winnerDisplayingView addSubview: gameResultLabel];
    [winnerDisplayingView addSubview: continueButton];
}

- (void)registerMatch {
    [[self delegate] dismissViewControllerAnimated: YES];
}

- (void)presentPlayerRegistrationView {
    CGRect frame = [[self view] frame];
    shadowView = [[UIView alloc] initWithFrame: frame];
    shadowView.backgroundColor = [UIColor shadowColor];
    frame = CGRectMake(self.view.frame.size.width / 8.0, self.view.frame.size.height / 4.0, self.view.frame.size.width / 1.3, self.view.frame.size.height / 3.0);
    nameRegisteringView = [[UIView alloc] initWithFrame: frame];
    nameRegisteringView.backgroundColor = [UIColor whiteColor];
    nameRegisteringView.clipsToBounds = YES;
    nameRegisteringView.layer.cornerRadius = 8;
    frame = CGRectMake(0.0, nameRegisteringView.frame.size.height / 8.0, nameRegisteringView.frame.size.width, nameRegisteringView.frame.size.height / 6.0);
    registerLabel = [[UILabel alloc] initWithFrame: frame];
    registerLabel.backgroundColor = [UIColor whiteColor];
    registerLabel.textColor = [UIColor violetColor];
    registerLabel.text = @"Enter player's name";
    registerLabel.textAlignment = NSTextAlignmentCenter;
    registerLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 25];
    frame = CGRectMake(nameRegisteringView.frame.size.width / 8.0, nameRegisteringView.frame.size.height / 2.3, nameRegisteringView.frame.size.width / 1.3, nameRegisteringView.frame.size.height / 5.5);
    nameInputTextField = [[UITextField alloc] initWithFrame: frame];
    nameInputTextField.borderStyle = UITextBorderStyleRoundedRect;
    nameInputTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    nameInputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameInputTextField.textAlignment = NSTextAlignmentLeft;
    nameInputTextField.keyboardType = UIKeyboardTypeAlphabet;
    nameInputTextField.keyboardAppearance = UIKeyboardAppearanceLight;
    nameInputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameInputTextField.tintColor = [UIColor violetColor];
    nameInputTextField.textColor = [UIColor violetColor];
    nameInputTextField.font = [UIFont fontWithName: @"HelveticaNeue" size: 15];
    if (hasFirstPlayerBeenRegistered) {
        nameInputTextField.placeholder = @"Second player's name";
    }
    else {
        nameInputTextField.placeholder = @"First player's name";
    }
    frame = CGRectMake(nameRegisteringView.frame.size.width / 8.0, nameRegisteringView.frame.size.height / 1.5, nameRegisteringView.frame.size.width / 1.3, nameRegisteringView.frame.size.height / 4.5);
    continueButton = [[UIButton alloc] initWithFrame: frame];
    continueButton.backgroundColor = [UIColor violetColor];
    continueButton.clipsToBounds = YES;
    continueButton.layer.cornerRadius = 8;
    if (!hasFirstPlayerBeenRegistered) {
        [continueButton setTitle: @"Continue" forState: UIControlStateNormal];
    }
    else {
        [continueButton setTitle: @"Start" forState: UIControlStateNormal];
    }
    [continueButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    continueButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [continueButton addTarget: self action: @selector(registerPlayerName) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview: shadowView];
    [[self view] addSubview: nameRegisteringView];
    [nameRegisteringView addSubview: registerLabel];
    [nameRegisteringView addSubview: nameInputTextField];
    [nameRegisteringView addSubview: continueButton];
}

- (void)hidePlayerRegistrationView {
    [registerLabel removeFromSuperview];
    [nameInputTextField removeFromSuperview];
    [continueButton removeFromSuperview];
    [nameRegisteringView removeFromSuperview];
    if (hasFirstPlayerBeenRegistered) {
        [shadowView removeFromSuperview];
    }
}

- (void)registerPlayerName {
    if (![nameInputTextField.text  isEqualToString: @""]) {
        if (!hasFirstPlayerBeenRegistered) {
            self.firstPlayerNameLabel.text = nameInputTextField.text;
            hasFirstPlayerBeenRegistered = YES;
            [self hidePlayerRegistrationView];
            [self presentPlayerRegistrationView];
        }
        else {
            self.secondPlayerNameLabel.text = nameInputTextField.text;
            [self hidePlayerRegistrationView];
            [self startGame];
        }
    }
}

- (IBAction)tap:(UIButton *)sender {
    if (sender == self.firstPlayerButton) {
        firstPlayerTapCount = firstPlayerTapCount + 1;
        self.firstPlayerTapsLabel.text = [[NSString alloc] initWithFormat: @"%i", firstPlayerTapCount];
    }
    else {
        secondPlayerTapCount = secondPlayerTapCount + 1;
        self.secondPlayerTapsLabel.text = [[NSString alloc] initWithFormat: @"%i", secondPlayerTapCount];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
