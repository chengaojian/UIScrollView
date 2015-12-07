//
//  ViewController.m
//  UIScrollView
//
//  Created by 陈高健 on 15/11/30.
//  Copyright © 2015年 陈高健. All rights reserved.
//

#import "ViewController.h"
//设置图片个数
#define zImageCount 3
//设置宽度
#define zScrollViewSize (self.scrollView.frame.size)

@interface ViewController ()<UIScrollViewDelegate>
//轮播图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//页码
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
//定时器
@property (weak,nonatomic)NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载轮播图片
    [self loadScrollView];
    //加载页码
    [self loadPageControl];
    //加载定时器
    [self loadTimer];
    
}

//加载轮播图片
- (void)loadScrollView{
    
    for (int i=0; i< zImageCount; i++) {
        //计算imageView的X的坐标
        CGFloat imageViewX =i * zScrollViewSize.width;
        //NSLog(@"---%d---%f",zImageCount,imageViewX);
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(imageViewX, 0, zScrollViewSize.width, zScrollViewSize.height)];
        //设置我们的图片
        NSString *imageName=[NSString stringWithFormat:@"mv_%02d.jpg",i];
        //NSLog(@"%@",imageName);
        //设置图片名称
        imageView.image=[UIImage imageNamed:imageName];
        //添加到轮播控制器中
        [self.scrollView addSubview:imageView];
    }
    //计算imageView的宽度
    CGFloat imageViewW=zImageCount * zScrollViewSize.width;
    //NSLog(@"%f",imageViewW);
    
    //给轮播器设置滚动范围
    self.scrollView.contentSize=CGSizeMake(imageViewW, 0);
    //隐藏滚动条
    self.scrollView.showsHorizontalScrollIndicator=NO;
    //设置分页
    self.scrollView.pagingEnabled=YES;
    //设置代理
    self.scrollView.delegate=self;
    
}

//加载页码
- (void)loadPageControl{
    //设置页面总个数
    self.pageControl.numberOfPages=zImageCount;
    //设置当前页码
    self.pageControl.currentPage=0;
    //设置当前页码的颜色
    self.pageControl.currentPageIndicatorTintColor=[UIColor yellowColor];
    //设置其他页码的颜色
    self.pageControl.pageIndicatorTintColor=[UIColor grayColor];
    
}

//加载定时器
- (void)loadTimer{
    //设置定时器,使其1秒钟切换一次,且不断重复切换(repeats:YES)
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pageChanged:) userInfo:nil repeats:YES];
    
    //取得主循环
    NSRunLoop *mainLoop=[NSRunLoop mainRunLoop];
    //将其添加到运行循环中(监听滚动模式)
    [mainLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//当页码发生改变的时候调用
- (void)pageChanged:(id)sender{

    //获取当前页面的索引
    NSInteger currentPage=self.pageControl.currentPage;
    //获取偏移量
    CGPoint offset=self.scrollView.contentOffset;
    //
    if (currentPage >= zImageCount - 1) {
        //将其设置首张图片的索引
        currentPage=0;
        //恢复偏移量
        offset.x = 0;
        //NSLog(@"offset%f",offset.x);
    }else{
        //当前索引+1
        currentPage ++;
        //设置偏移量
        
        offset.x += zScrollViewSize.width;
        
        //NSLog(@"offset.x====%f",offset.x);
    }
    //设置当前页
    self.pageControl.currentPage=currentPage;
    //设置偏移后的位置 加上动画过度
    [self.scrollView setContentOffset:offset animated:NO];
    
}

//根据偏移量获取当前页码
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取偏移量
    CGPoint offset=scrollView.contentOffset;
    //计算当前页码
    NSInteger currentPage=offset.x / zScrollViewSize.width;
    //设置当前页码
    self.pageControl.currentPage=currentPage;
    
}

//设置代理方法,当开始拖拽的时候,让计时器停止
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //使定时器失效
    [self.timer invalidate];
}

//设置代理方法,当拖拽结束的时候,调用计时器,让其继续自动滚动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    //重新启动定时器
    [self loadTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
