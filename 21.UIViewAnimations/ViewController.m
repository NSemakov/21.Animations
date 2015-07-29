//
//  ViewController.m
//  21.UIViewAnimations
//
//  Created by Admin on 29.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong,nonatomic) NSArray *arrayOfViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Uchenik
    CGRect rect1=CGRectMake(0, 50, 40, 40);
    UIView *view1=[[UIView alloc]initWithFrame:rect1];
    view1.backgroundColor=[self randomColor];
    
    CGRect rect2=CGRectMake(0, 100, 40, 40);
    UIView *view2=[[UIView alloc]initWithFrame:rect2];
    view2.backgroundColor=[self randomColor];
    
    CGRect rect3=CGRectMake(0, 150, 40, 40);
    UIView *view3=[[UIView alloc]initWithFrame:rect3];
    view3.backgroundColor=[self randomColor];
    
    CGRect rect4=CGRectMake(0, 200, 40, 40);
    UIView *view4=[[UIView alloc]initWithFrame:rect4];
    view4.backgroundColor=[self randomColor];
    
    self.arrayOfViews =[NSArray arrayWithObjects:view1,view2,view3,view4, nil];
    for (NSInteger i=0;i<[self.arrayOfViews count];i++){
        UIView *obj=[self.arrayOfViews objectAtIndex:i];
        [self.view addSubview:obj];
        [UIView animateWithDuration:2
                              delay:0
                            options:i<<16 | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                         animations:^{
                             CGAffineTransform moveTransform=CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds)-CGRectGetWidth(obj.bounds), 0);
                             obj.transform=moveTransform;
                             obj.backgroundColor=[self randomColor];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
    }
    //--------
    //end of Uchenik
    
    //Student
    
    CGPoint topLeft=CGPointMake(0, 0);
    CGPoint topRight=CGPointMake(CGRectGetMaxX(self.view.bounds), 0);
    CGPoint bottomRight=CGPointMake(CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds));
    CGPoint bottomLeft=CGPointMake(0, CGRectGetMaxY(self.view.bounds));
    CGFloat rectSize=40.f;
    
    
    UIView *viewTopLeft=[self createCornerViewWithRectSize:rectSize cornerPoint:topLeft xDelta:0 yDelta:0];
    viewTopLeft.backgroundColor=[self randomColor];
    [self.view addSubview:viewTopLeft];
    
    UIView *viewTopRight=[self createCornerViewWithRectSize:rectSize cornerPoint:topRight xDelta:-1 yDelta:0];
    viewTopRight.backgroundColor=[self randomColor];
    [self.view addSubview:viewTopRight];
    
    UIView *viewBottomLeft=[self createCornerViewWithRectSize:rectSize cornerPoint:bottomLeft xDelta:0 yDelta:-1];
    viewBottomLeft.backgroundColor=[self randomColor];
    [self.view addSubview:viewBottomLeft];

    UIView *viewBottomRight=[self createCornerViewWithRectSize:rectSize cornerPoint:bottomRight xDelta:-1 yDelta:-1];
    viewBottomRight.backgroundColor=[self randomColor];
    [self.view addSubview:viewBottomRight];
    
    self.collectionOfCornerViews =[NSArray arrayWithObjects:viewTopLeft,viewTopRight,viewBottomRight, viewBottomLeft, nil];
    
    [self cornerMoveViewsInArray:self.collectionOfCornerViews];

    
    //--------
    //end of Student
    
    
    
}
- (void) cornerMoveViewsInArray:(NSArray *) array {
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        BOOL isReverse=arc4random_uniform(2);
        UIView * firstUIView=[array firstObject];
        UIView *lastUIView=[array lastObject];
        CGPoint centerOfFirstUIView=firstUIView.center;
        CGPoint centerOfLastUIView=lastUIView.center;
        
        UIColor *buferColor=firstUIView.backgroundColor;
        /*
         NSValue *buferCenterNSValue=[NSValue valueWithCGPoint:firstUIView.center];//1. Put center of first point of array in outer bufer
         NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:buferCenterNSValue,@"buferCenterNSValue",buferColor,@"buferColor", nil];
         
         for (NSInteger i=1; i<[self.collectionOfCornerViews count];i++){
         
         UIView *currentView=[self.collectionOfCornerViews objectAtIndex:i];
         UIColor *buferColorInner=currentView.backgroundColor;
         CGPoint buferCenterInner=currentView.center; //make exchange. 2. put center in inner bufer
         currentView.center=[[dict objectForKey:@"buferCenterNSValue"] CGPointValue];//3. point of current view <--from outer buffer
         currentView.backgroundColor=[dict objectForKey:@"buferColor"] ;
         [dict setValue:[NSValue valueWithCGPoint:buferCenterInner] forKey:@"buferCenterNSValue"];//4. refresh outer bufer with point from inner one
         [dict setValue:buferColorInner forKey:@"buferColor"];//4. refresh outer bufer with point from inner one
         }
         */
        if (isReverse) {
            for (NSInteger i=[array count]-1; i>0;i--){
                
                UIView *currentView=[array objectAtIndex:i];
                UIView *previousView=[array objectAtIndex:i-1];
                currentView.center=previousView.center;
                currentView.backgroundColor=previousView.backgroundColor;
            }

            firstUIView.center=centerOfLastUIView;
            firstUIView.backgroundColor=buferColor;
        } else {
            for (NSInteger i=0; i<[array count]-1;i++){
                
                UIView *currentView=[array objectAtIndex:i];
                UIView *nextView=[array objectAtIndex:i+1];
                currentView.center=nextView.center;
                currentView.backgroundColor=nextView.backgroundColor;
            }
            //firstUIView.center=[[dict objectForKey:@"buferCenterNSValue"] CGPointValue]; //5. set up center of first point
            //firstUIView.backgroundColor=[dict objectForKey:@"buferColor"];
            lastUIView.center=centerOfFirstUIView;
            lastUIView.backgroundColor=buferColor;
        }
        
    } completion:^(BOOL finished) {
        __weak NSArray* arr=array;
        [self cornerMoveViewsInArray:arr];
    }];
}
- (UIView*) createCornerViewWithRectSize:(CGFloat) rectSize cornerPoint:(CGPoint) point xDelta:(NSInteger) xDelta yDelta:(NSInteger) yDelta {
    
    CGRect rect=CGRectMake(point.x+xDelta*rectSize, point.y+yDelta*rectSize, rectSize, rectSize);
    
    UIView *view=[[UIView alloc]initWithFrame:rect];
    return view;
}
- (UIColor *) randomColor {
    CGFloat red=(float)arc4random_uniform(10000)/10000;
    CGFloat green=(float)arc4random_uniform(10000)/10000;
    CGFloat blue=(float)arc4random_uniform(10000)/10000;
    UIColor *color=[UIColor colorWithRed:red green:green blue:blue alpha:0.8];
    return color;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
