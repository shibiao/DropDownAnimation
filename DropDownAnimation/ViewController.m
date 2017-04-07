//
//  ViewController.m
//  DropDownAnimation
//
//  Created by sycf_ios on 2017/4/7.
//  Copyright © 2017年 shibiao. All rights reserved.
//

#import "ViewController.h"
#import "SBTableViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) CGPoint cp;
@property (nonatomic,assign) CGFloat oldY;
@property (nonatomic,strong) CAShapeLayer *shapLayer;
@end

@implementation ViewController
//grayLayer懒加载
-(CAShapeLayer *)grayLayer{
    if (!_shapLayer) {
        _shapLayer = [[CAShapeLayer alloc]init];
        self.grayLayer.path = [self customPath].CGPath;
        _shapLayer.fillColor = [UIColor blueColor].CGColor;
        _shapLayer.lineJoin = kCALineJoinRound;
        _shapLayer.lineCap = kCALineCapRound;
    }
    return _shapLayer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _oldY = 0;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(hanlePanGesture:)];
    [self.tableView addGestureRecognizer:panGesture];
    
}
//获取点击位置
-(void)hanlePanGesture:(UIPanGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self.tableView];
    if (_oldY == 0) {
        _oldY = point.y;
    }else{
        CGFloat y = point.y - _oldY;
        if (y<=0) {
            y=0;
        }
        if (y >= 100) {
            y = 100;
        }
        self.cp = CGPointMake(point.x, 64 + y);
    }
    //更新路径
    self.grayLayer.path = [self customPath].CGPath;
    [self.view.layer setNeedsDisplay];
}

//自定义路径
-(UIBezierPath *)customPath {
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(0, 64)];
    CGPoint endPoint = CGPointMake(self.view.frame.size.width, 64);
    //添加曲线
    [path addQuadCurveToPoint:endPoint controlPoint:self.cp];
    return path;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.title.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
    return cell;
}

//MARK: tableView的ScrollView代理方法
//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //当tableView滑到最顶端的时候往下拉
    if (self.tableView.contentOffset.y == -64 ){
        self.shapLayer.path = [self customPath].CGPath;
        [self.view.layer addSublayer:self.shapLayer];

    }

}
//结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _oldY = 0;
    [self.shapLayer removeFromSuperlayer];
}

@end
