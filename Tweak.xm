#import <substrate.h>
#import <UIKit/UIKit.h>

@interface SPUITextField:UITextField
@end

@interface SPUISearchHeader
@property (retain) SPUITextField * searchField;
-(void)cancelButtonClicked:(id)arg1;
@end

@interface SpringBoard
- (void)setNextAssistantRecognitionStrings:(id)arg1;
@end

@interface SBAssistantController
+ (id)sharedInstance;
- (void)handleSiriButtonUpEventFromSource:(int)arg1;
- (_Bool)handleSiriButtonDownEventFromSource:(int)arg1 activationEvent:(int)arg2;
@end

static SpringBoard *springBoard = nil;
%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)fp8 {
    %orig;
    springBoard = self;
}
%end

%hook SPUISearchHeader
-(BOOL)textFieldShouldReturn:(id)arg1{
    SPUITextField *searchField = self.searchField;
    
    NSString *searchString = [searchField.text lowercaseString];
    if ([searchString hasPrefix:@"siri"]) {
        NSString *searchStringWithoutSiri = [searchString
                                         stringByReplacingOccurrencesOfString:@"siri" withString:@""];
        if (![[searchStringWithoutSiri stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""]) {
            NSArray *myStrings = [NSArray arrayWithObjects:searchStringWithoutSiri, nil];
            [springBoard setNextAssistantRecognitionStrings:myStrings];
        }
        SBAssistantController *assistantController = [%c(SBAssistantController) sharedInstance];
        [assistantController handleSiriButtonDownEventFromSource:1 activationEvent:1];
        [assistantController handleSiriButtonUpEventFromSource:1];
        searchField.text = @"";
        [self cancelButtonClicked:nil];
    }
        return %orig(arg1);
}

%end
