//
//  ViewController.m
//  NASReader
//
//  Created by oneko on 2022/6/30.
//

#import "ViewController.h"
#import <DYReader/DYReaderViewer.h>

@interface ViewController ()

@property (nonatomic, strong) DYReaderViewer *readerViewer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.readerViewer = [DYReaderViewer new];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *file = [bundle pathForResource:@"test" ofType:@"pdf"];
    [self.readerViewer openFile:file];
    UIView *v = [self.readerViewer getPageViewAtChapter:1 size:self.view.bounds.size page:1];
    [self.view addSubview:v];
}


@end
