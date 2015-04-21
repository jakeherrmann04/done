//
//  NewListViewController.m
//  MyDayCapstone
//
//  Created by Jake Herrmann on 4/20/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import "NewListViewController.h"
#import "ListController.h"
#import <pop/POP.h>
#import "SegmentController.h"

@interface NewListViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *giveTitleView;

@end

@implementation NewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.giveTitleView.transform = CGAffineTransformMakeScale(0.6, 0.6);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exitButtonTapped:(id)sender {
    
    [self animateNewListViewOff];
    
}
- (IBAction)addTitleButtonPressed:(id)sender {
    
    if (self.isList) {
        [[ListController sharedInstance] addListWithTitle:self.titleTextField.text];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"listReload" object:nil];
    } else {
        [[SegmentController sharedInstance] addSegmentToList:self.list withTitle:self.titleTextField.text];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"segmentListReload" object:nil];

    }
    
    [self animateNewListViewOff];
}

-(void)animateNewListViewOn {
    
    [self.view pop_removeAllAnimations];
    [self.giveTitleView pop_removeAllAnimations];
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(0.0);
    anim.toValue = @(1.0);
    [self.view pop_addAnimation:anim forKey:@"fade"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    scaleAnimation.springBounciness = 18.f;
    [self.giveTitleView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    [scaleAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [self.titleTextField becomeFirstResponder];
    }];

}

-(void)animateNewListViewOff {
    
    [self.view pop_removeAllAnimations];
    [self.giveTitleView pop_removeAllAnimations];
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.duration = 0.4;
    anim.fromValue = @(1.0);
    anim.toValue = @(0.0);
    [self.view pop_addAnimation:anim forKey:@"fade"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.1, 0.1)];
    scaleAnimation.springBounciness = 8.0f;
    [self.giveTitleView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [self.view removeFromSuperview];
        [self willMoveToParentViewController:nil];
    }];

}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
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
