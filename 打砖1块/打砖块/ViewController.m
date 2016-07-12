//
//  ViewController.m
//  打砖块
//
//  Created by cqy on 16/4/20.
//  Copyright © 2016年 刘征. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController (){
    
    //用这个布尔值标示游戏是否正在运行中
    BOOL isPlaying;
    
    //游戏时钟
    CADisplayLink *_gameTimer;
    //小球的移动速度
    CGPoint _speed;
    //手指移动的位置的差值
    CGFloat chaX;
}
//检测屏幕碰撞
- (BOOL)checkWithScreen;
//游戏结束处理事件
- (void)gameOver:(NSString *)str;
//检测砖块碰撞
-(BOOL)checkWithBlock;
//挡板碰撞
- (void)checkWithPaddle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //判断游戏是否正在游戏中，如果没开始就让游戏开始
    
    
    
    if (!isPlaying) {
        
        isPlaying = YES;
       //初始化一个游戏始终,让step方法1/60秒执行一次
        _gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
        
        //将游戏时钟放在runloop中
        /*
         *runloop做两件事情
            1.监听输入源，一般自动放到runloop中
            2.监听定时器，一般需手动放到runloop中
         */
        [_gameTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
    //给小球一个初始速度
        _speed = CGPointMake(0, -5);
        
    }else{
        
        chaX = 0;
        
    }
}
//让小球按照1/60秒的频率动起来
- (void)step{
    
    //如果返回yes就代表游戏失败
    if([self checkWithScreen]){
        
        [self gameOver:@"再来一次"];
    }
    //如果返回yes，就代表游戏过关
    if ([self checkWithBlock]) {
        
        [self gameOver:@"你真棒"];
        
    }
    [self checkWithPaddle];
    _ballImage.center = CGPointMake(_ballImage.center.x+_speed.x, _ballImage.center.y+_speed.y);
}

#pragma mark 碰撞检测

-(BOOL)checkWithScreen{
    
    BOOL isFail = NO;
    //CGRectGetMinY 获取到小球的最小y值
    if (CGRectGetMinY(_ballImage.frame) <= 0) {
        
        //fabsf获取到绝对值
        _speed.y = fabs(_speed.y);
        
    }//底部碰撞
    if (CGRectGetMaxY(_ballImage.frame) >= CGRectGetHeight(self.view.frame)) {
        
        isFail = YES;
        
    }
  
    //左侧碰撞
    if(CGRectGetMinX(_ballImage.frame) <= 0){
        
        _speed.x = fabs(_speed.x);
    }
    
    //右侧碰撞
    if(CGRectGetMaxX(_ballImage.frame) >= CGRectGetWidth(self.view.frame)){
        
        _speed.x = -1 * fabs(_speed.x);
    }
    
    
    return isFail;
    
}
- (void)gameOver:(NSString *)str{
    
    isPlaying = NO;
    
    NSLog(@"%@",str);
    
    //销毁定时器
    [_gameTimer invalidate];
    
    for (UIImageView *block in _blockImageArray) {
        
        block.hidden = YES;
        
        block.alpha
        = 0;
    }
    
    [UIView animateWithDuration:2.0 animations:^{
        
        for (UIImageView *block in _blockImageArray) {
            
            block.hidden = NO;
            
            block.alpha = 1;
        }
        
    } completion:^(BOOL finished) {
        
        _ballImage.center = CGPointMake(160, 377);
        _paddleImage.center = CGPointMake(160, 402);
    }];
}
//砖块碰撞
- (BOOL)checkWithBlock{
    
    BOOL gameWin = YES;
    
    //通过for循环找到小球跟哪个色块碰撞了
    for (UIImageView *block in _blockImageArray) {
        
        //CGRectIntersectsRect判断两个试图是否碰撞
        if (CGRectIntersectsRect(block.frame, _ballImage.frame) && !block.hidden) {
            
            block.hidden = YES;
            
            _speed.y = fabs(_speed.y);
            
        }
    }
    //用来判断是否所有的色块都隐藏了
    for (UIImageView *block in _blockImageArray) {
        
        if (block.hidden == NO) {
            
            gameWin = NO;
            
            break;
            
        }
        
    }
    
    return gameWin;
    
}
//挡板碰撞
-(void)checkWithPaddle{
    
    if (CGRectIntersectsRect(_ballImage.frame, _paddleImage.frame)) {
        
        _speed.y =-1 * fabs( _speed.y);
    //小球移动的速度和手指移动的速度相加
        _speed.x += chaX;
        
    }
}

//监听在屏幕上的滑动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(isPlaying){
        
        //获取到我点击的手指 touches是个集合，因为视图有多点触摸
        UITouch *touch = [touches anyObject];
        //获取到当前手指的位置
        CGFloat nowX = [touch locationInView:self.view].x;
        //获取到上一次手指的位置
        CGFloat lastX = [touch previousLocationInView:self.view].x;
        
        chaX = nowX - lastX;
        _paddleImage.center = CGPointMake(_paddleImage.center.x+chaX, _paddleImage.center.y);
        
    
    
}
}
@end
