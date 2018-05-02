//
//  ViewController.m
//  View_AnimationTest
//
//  Created by Dmitriy Tarelkin on 2/5/18.
//  Copyright © 2018 Dmitriy Tarelkin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) UIView* testSubView;
@property (weak, nonatomic) UIImageView* testImageSubView;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*** ImageView example ***
     UIImageView* subView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100,100)];
     subView.backgroundColor = [UIColor clearColor];
     
     UIImage* image = [UIImage imageNamed:@"Human.png"];
     subView.animationImages = [NSArray arrayWithObjects:image, nil];
     //animateViewWithImage
     [subView startAnimating];
     
     [self.view addSubview:subView];
     self.testImageSubView = subView;
     */
    
}

#pragma mark - Custom Methods
-(void)createSubViewCount:(int)count withFrame:(CGRect)frame {
    
    for (int i =0 ; i < count; i+=1) {
        UIView* subView = [[UIView alloc] initWithFrame:frame];
        subView.backgroundColor = [self randomColor];
        
        //add subView to ViewController
        [self.view addSubview:subView];
        [self moveView:subView];
    }
}

-(void)createSubImageViewCount:(int)count withImageNamed:(NSString*)imgName andFrame:(CGRect)frame{
    for (int i =0 ; i < count; i+=1) {
        UIImageView* subImgView = [[UIImageView alloc] initWithFrame:frame];
        subImgView.backgroundColor = [UIColor clearColor];
        
        UIImage* image = [UIImage imageNamed:imgName];
        subImgView.animationImages = [NSArray arrayWithObjects:image, nil];
        
        //animateViewWithImage
        [subImgView startAnimating];
        [self.view addSubview:subImgView];
        [self moveView:subImgView];
    }
}

-(UIColor*)randomColor {
    CGFloat r = (CGFloat)(arc4random() %256) /255.f;
    CGFloat g = (CGFloat)(arc4random() %256) /255.f;
    CGFloat b = (CGFloat)(arc4random() %256) /255.f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}

-(void)moveView:(UIView*)view{
    
    CGRect rect = self.view.bounds;
    //отступ внутри  view
    rect = CGRectInset(rect, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
    //cгенерим точку
    CGFloat x = arc4random() % (int)CGRectGetWidth(rect) + CGRectGetMinX(rect);
    CGFloat y = arc4random() % (int)CGRectGetHeight(rect) + CGRectGetMinY(rect);
    
    //random scale
    CGFloat s = (float)(arc4random() % 151) / 100.f + 0.5f;
    
    //random rotation
    CGFloat r = (float)(arc4random() % (int)(M_PI*2* 10000)) /10000 - M_PI;
    
    //generate duration from 2 to 4 seconds
    CGFloat d = (float)(arc4random_uniform(2) + 2);
    
    [UIView animateWithDuration:d
                          delay:0
                        options:UIViewAnimationOptionCurveLinear //| UIViewAnimationOptionRepeat
                     animations:^{
                         //animation start, сдвигаем view в рандомную точку
                         view.center = CGPointMake(x,y);
                         
                         //changing color when view in change position
                         view.backgroundColor = [self randomColor];
                         // NSLog(@"%@", NSStringFromCGPoint(view.center));
                         
                         //all transforms at the same time
                         CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
                         CGAffineTransform rotation = CGAffineTransformMakeRotation(r);
                         
                         //sum up matrix
                         CGAffineTransform transformScaleRotation = CGAffineTransformConcat(scale, rotation);
                         
                         //transform
                         view.transform = transformScaleRotation;
                         
                     }
                     completion:^(BOOL finished) {
                         //animation end
                         //   NSLog(@"First animation ends with %@", finished ? @"YES":@"NO");
                         
                         // NSLog(@"\nview frame: %@\nbounds: %@ ",
                         //       NSStringFromCGRect(view.frame),NSStringFromCGRect(view.bounds));
                         //при изменении формы bounds остаются прежними, а фрейм меняется
                         
                         //recursive call when animation end
                         __weak UIView* v = view;
                         [self moveView:v];
                     }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //animate when view appeared
    /*** first animation ***
     [UIView animateWithDuration:10
     animations:^{
     self.testSubView.center =
     CGPointMake(CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.testSubView.frame)/2, 150);
     }];
     */
    /*** second animation ***
     [UIView animateWithDuration:5
     delay:1
     usingSpringWithDamping:0
     initialSpringVelocity:0
     options:0
     animations:^{
     //animation
     self.testSubView.center =
     CGPointMake(CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.testSubView.frame)/2, 150);
     
     NSLog(@"%@", NSStringFromCGPoint(self.testSubView.center)); //x = 784, y = 150
     }
     completion:^(BOOL finished) {
     //animation to finish
     [UIView animateWithDuration:5 animations:^{
     self.testSubView.center =
     CGPointMake(CGRectGetWidth(self.testSubView.frame)/2, 150);
     }];
     
     //position after animation
     NSLog(@"%@", NSStringFromCGPoint(self.testSubView.center));  //x = 50, y = 150
     }];
     */
    /*** third animation with transformation ***
     [UIView animateWithDuration:1
     delay:0
     options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
     animations:^{
     //animation start
     self.testSubView.center =
     CGPointMake(CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.testSubView.frame)/2, 150);
     
     //changing color when view in change position
     self.testSubView.backgroundColor = [self randomColor];
     NSLog(@"%@", NSStringFromCGPoint(self.testSubView.center));                //x = 784, y = 150
     
     //transformation: rotate view M_PI = 180
     //                         self.testSubView.transform = CGAffineTransformMakeRotation(M_PI);          //rotate
     //                         self.testSubView.transform = CGAffineTransformMakeTranslation(0, 600);     //change end position
     //                         self.testSubView.transform = CGAffineTransformMakeScale(2, 2);             //skale
     
     //all transforms at the same time
     CGAffineTransform scale = CGAffineTransformMakeScale(4,4);
     CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI);
     CGAffineTransform translation = CGAffineTransformMakeTranslation(0, 600);
     
     //sum up matrix
     CGAffineTransform transformScaleRotation = CGAffineTransformConcat(scale, rotation);
     CGAffineTransform transformAll = CGAffineTransformConcat (transformScaleRotation, translation);
     
     //transform
     self.testSubView.transform = transformAll;
     
     }
     completion:^(BOOL finished) {
     //animation end
     NSLog(@"First animation ends with %@", finished ? @"YES":@"NO");
     }];
     */
    /*** Stop current animation after 6s and start other animation ***
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     //отменить анимацию через 6 секунд и testSubview переместится на последнюю позицию
     [self.testSubView.layer removeAllAnimations];
     
     //animation that starts arter 6 seconds of first
     [UIView animateWithDuration:4
     delay:0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^{
     self.testSubView.center = CGPointMake(500, 500);
     self.testSubView.backgroundColor = [UIColor redColor];
     NSLog(@"%@", NSStringFromCGPoint(self.testSubView.center)); //x = 784, y = 150
     }
     completion:^(BOOL finished) {
     NSLog(@"Second animation ends with %@", finished ? @"YES":@"NO");
     }];
     
     });
     */
    
    
    //create views
    //[self createSubViewCount:100];
    
    //create viewImages
    [self createSubImageViewCount:50 withImageNamed:@"Like2.png" andFrame:CGRectMake(100, 100, 100, 100)];
    
    //call method that transform view
    [self moveView:self.testImageSubView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
