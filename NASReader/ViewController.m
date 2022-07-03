//
//  ViewController.m
//  NASReader
//
//  Created by oneko on 2022/6/30.
//

#import "ViewController.h"
#import <DYReader/DYBookReader.h>

@interface ViewController ()

@property (nonatomic, strong) DYBookReader *readerViewer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.readerViewer = [DYBookReader new];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *file = [bundle pathForResource:@"TLYCSEbookDec2020FINAL" ofType:@"epub"];
    [self.readerViewer openFile:file];
    UIView *v = [self.readerViewer getPageViewAtPage:1 size:self.view.bounds.size];
    [self.view addSubview:v];
}


@end
