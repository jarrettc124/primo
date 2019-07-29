//
//  TutorialViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/26/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()
@property (nonatomic,strong) NSArray *pageTutorial;
@property (nonatomic,strong) NSArray *pictureText;
@property (nonatomic,strong) UIPageControl *pageControl;


@end

@implementation TutorialViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    
    [self.navigationItem setTitle:@"How Can We Help?"];

    
    //set color for navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tutorialBackground"]];
    [backgroundView setUserInteractionEnabled:YES];
    [self.view addSubview:backgroundView];
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    _pageTutorial = @[@"Manage your class' behavior by awarding them coins or take them away with our class economy.",@"With coins your students can purchase items from your store.",@"Broadcast news to parents or students anywhere, anytime!. (No more \"I didn't know we have a test today!\")",@"Have us split your class in groups for projects so you don't have to."];
    
    _pictureText = @[@"tutorialImg1",@"tutorialImg2",@"tutorialImg3",@"tutorialImg4"],
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    IntroPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.dataSource = self;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    _pageControl = [[UIPageControl alloc]init];
    self.pageControl.userInteractionEnabled=NO;
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage =0;
        
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0705882 green:0.082353 blue:0.243137 alpha:1];
    [self.view addSubview:self.pageControl];
    
    if(IS_IPHONE){
        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        [self.pageControl setFrame:CGRectMake((self.view.frame.size.width/2)-45,self.view.frame.size.height-75, 90, 30)];
    }
    else if (IS_IPAD){
        
        
        backgroundView.translatesAutoresizingMaskIntoConstraints=NO;
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        self.pageControl.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:300]];
    }
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"pageIndex" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pageIndex" object:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger index = ((IntroPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return [self viewControllerAtIndex:3];
    }
    
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroPageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    
    index++;
    if (index == [self.pageTutorial count]) {
        return [self viewControllerAtIndex:0];
    }
    
    return [self viewControllerAtIndex:index];
}

- (IntroPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTutorial count] == 0) || (index >= [self.pageTutorial count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    IntroPageContentViewController *pageContentViewController = [[IntroPageContentViewController alloc] init];
    //pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.tutorialText = self.pageTutorial[index];
    pageContentViewController.pictureText = self.pictureText[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (void) incomingNotification:(NSNotification *)notification{
    NSNumber *pageIndexNum = [notification object];
    self.pageControl.currentPage= [pageIndexNum intValue];
}

@end
