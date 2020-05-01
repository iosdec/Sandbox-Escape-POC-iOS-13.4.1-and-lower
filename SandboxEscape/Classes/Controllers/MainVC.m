//
//  MainVC.m
//  SandboxEscape
//
//  Created by Declan Land on 01/05/2020.
//  Copyright © 2020 superb. All rights reserved.
//

#import "MainVC.h"

@interface MainVC () { }

/*! @brief Console view. */
@property (weak, nonatomic) IBOutlet UITextView *consoleView;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.consoleView setText:@"[+] Console Ready\n"];
}

#pragma mark    -   Button Actions: -

- (IBAction)actionRead:(UIButton *)sender {
    
    NSString *filePath = @"/private/var/mobile/Library/SMS/sms.db";
    NSURL *fileURL = [NSURL URLWithString:filePath];
    
    if (![[NSFileManager defaultManager] isReadableFileAtPath:filePath]) {
        [self.consoleView insertText:@"[-] Error: Couldn't read file at path\n"];
        [self.consoleView insertText:@"[*] Please make sure Sandbox escape is applied\n"];
        return;
    }
    
    NSData *rawData = [NSData dataWithContentsOfFile:fileURL.absoluteString options:0 error:nil];
    [self.consoleView insertText:[NSString stringWithFormat:@"[+] Found file: %@\n", rawData]];
    
    if (!rawData) {
        [self.consoleView insertText:@"[-] Error: Read file, but invalid data\n"];
        return;
    }
    
    [self.consoleView insertText:@"[+] File dump success!\n"];
    [self.consoleView insertText:@"[+] Converting raw data to file..!\n"];
    
    NSString *newFileName = @"sms-dump.db";
    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *newFilePath = [documents stringByAppendingPathComponent:newFileName];
    BOOL writeSuccess = [rawData writeToFile:newFilePath atomically:YES];
    
    if (!writeSuccess) {
        [self.consoleView insertText:@"[-] Error saving file!\n"];
        return;
    }
    
    [self.consoleView insertText:[NSString stringWithFormat:@"[+] Wrote to path: %@\n", newFilePath]];
    [self.consoleView insertText:@"[+] File ready to send!\n"];
    
}

- (IBAction)actionAirdrop:(UIButton *)sender {
    
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"sms-dump.db"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self.consoleView insertText:@"[-] Error - couldn't find file\n"];
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:path];
    UIActivityViewController *activitySheet = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    [self presentViewController:activitySheet animated:YES completion:nil];
    
}

@end
