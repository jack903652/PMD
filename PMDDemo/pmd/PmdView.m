//
//  PmdView.m
//  Pmd
//
//  Created by bamq on 2018/11/7.
//  Copyright © 2018年 bamq. All rights reserved.
//

#import "PmdView.h"
#import "PmdCell.h"
#define pmd_screen_width [UIScreen mainScreen].bounds.size.width
static CGFloat speed = 0.5;
@interface PmdView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
///collectionView
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)CADisplayLink *marqueeDisplayLink;
///width
@property(nonatomic,copy)NSArray<NSNumber*> *widths;
///总长
@property(nonatomic,assign)CGFloat totalWidth;
///是否有空的占位字符,修改了数据源,方便点击的时候取到正确的idx和content
@property(nonatomic,assign)BOOL hasPlaceholder;
@end
@implementation PmdView

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.speed = speed;
        self.space = 20;
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = [UIColor blackColor];
        self.scrollType = PMDScrollTypeDefault;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];;
        [self addSubview:_collectionView];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *v =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)];
        NSArray *h =  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)];
        [self addConstraints:v];
        [self addConstraints:h];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PmdCell class] forCellWithReuseIdentifier:@"PmdCell"];
        _collectionView.backgroundColor = [UIColor clearColor];

        _totalWidth = 0;
    }
    return self;
}
-(void)setDataSource:(NSArray *)dataSource{
    [self layoutIfNeeded];
    CGFloat from = 0;
    switch (self.scrollType) {
        case PMDScrollTypeDefault:
            from = self.space;
        break;
            
        case PMDScrollTypeMiddleToLeft:
            from = CGRectGetWidth(self.frame)/2;
        break;
            
        case PMDScrollTypeRightToLeft:
            from = CGRectGetWidth(self.frame);
            break;
            
        default:
            from = 0;
            break;
    }
    CGFloat space_width = from - self.space/*多个间隔*/;
    CGFloat tWidth = [@" " sizeWithAttributes:@{NSFontAttributeName:self.font}].width;
    NSInteger n = ceil(space_width/tWidth);
    NSMutableString *string = [NSMutableString string];
    for (int i = 0 ; i<n ; i++) {
        [string appendString:@" "];
    }
    _totalWidth = 0;
    NSMutableArray <NSString *>*arr =[NSMutableArray arrayWithArray:dataSource];
    if (string.length > 0) {
        self.hasPlaceholder = YES;
        [arr insertObject:string atIndex:0];
    }
    NSMutableArray <NSNumber *>*temp = [NSMutableArray array];
    for (int i = 0; i<arr.count; i++) {
        CGFloat width = [arr[i] sizeWithAttributes:@{NSFontAttributeName:self.font}].width;
        width += self.space;
        self.totalWidth += width;
        [temp addObject:@(width)];
    }
    NSInteger repeat = ceil(pmd_screen_width/self.totalWidth);

    for (int i = 0; i<repeat; i++) {
        [arr addObjectsFromArray:arr];
        [temp addObjectsFromArray:temp];
    }
    _dataSource = [arr copy];
    self.widths = [temp copy];
    [self.collectionView reloadData];
    [self startMarquee];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PmdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PmdCell" forIndexPath:indexPath];
    cell.tLabel.font = _font;
    cell.tLabel.textColor = _textColor;
    cell.tLabel.text = self.dataSource[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = [self.widths[indexPath.item] floatValue];
    return CGSizeMake(width, self.font.pointSize +1);
}
-(void)processMarquee{
    CGFloat targetX = self.totalWidth;
    CGPoint contentOffset = self.collectionView.contentOffset;
    if (contentOffset.x >= targetX) {
        self.collectionView.contentOffset = CGPointMake(0, 0);
    }else {
        contentOffset.x += self.speed;
        if (contentOffset.x > targetX) {
            contentOffset.x = 0;
        }
        self.collectionView.contentOffset = contentOffset;
    }
}
-(void)stopMarquee{
    [self.marqueeDisplayLink invalidate];
    self.marqueeDisplayLink = nil;
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview == nil) {
        [self stopMarquee];
    }
}
-(void)startMarquee{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopMarquee];
        self.marqueeDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(processMarquee)];
        [self.marqueeDisplayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    });

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickClosure) {
        NSString *content = self.dataSource[indexPath.item];
        content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (content.length > 0) {
            self.clickClosure(indexPath.item -1, content);
        }
    }
}
@end
