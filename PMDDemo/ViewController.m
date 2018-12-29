//
//  ViewController.m
//  PMDDemo
//
//  Created by bamq on 2018/12/26.
//  Copyright © 2018 bamq. All rights reserved.
//

#import "ViewController.h"
#import "pmd/PmdView.h"
@interface ViewController ()
@property(nonatomic,strong)PmdView *pmd;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pmd = [[PmdView alloc] init];
    
    [self.view addSubview:_pmd];
//    [_pmd mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(100);
//        make.left.equalTo(self.view).offset(40);
//        make.height.equalTo(@20);
//        make.right.equalTo(self.view).offset(-20);
//    }];
    _pmd.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *v =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_pmd(20)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_pmd)];
    NSArray *h =  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_pmd]-20-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_pmd)];
    [self.view addConstraints:v];
    [self.view addConstraints:h];
    _pmd.scrollType = PMDScrollTypeMiddleToLeft;
    _pmd.dataSource =@[@"Do any additional setup after loading the view",@"typically from a nib."];
    _pmd.clickClosure = ^(NSInteger idx, NSString * _Nonnull content) {
        NSLog(@"%d,%@",idx,content);
    };
//    __block NSString *x = nil;
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_sync(queue, ^{
//        sleep(5);
//        x = @"sdfasdf";
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"dispatch_async%@",x);
//    });
//    dispatch_sync(queue, ^{
//        NSLog(@"dispatch_sync%@",x);
//    });
//    [pmd startMarquee];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
