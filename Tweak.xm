#import <substrate.h>
#import <UIKit/UIKit.h>

@interface SPUITextField:UITextField
@end

@interface SPUISearchHeader
@property (retain) SPUITextField * searchField;
@end

@interface SpringBoard
- (void)setNextAssistantRecognitionStrings:(id)arg1;
@end

@interface SBAssistantController
+ (id)sharedInstance;
- (void)handleSiriButtonUpEventFromSource:(int)arg1;
- (_Bool)handleSiriButtonDownEventFromSource:(int)arg1 activationEvent:(int)arg2;
@end

@interface SPUISearchViewController
- (void)cancelButtonPressed;
@end
static SpringBoard *springBoard = nil;
%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)fp8 {
    %orig;
    springBoard = self;
}
%end

%hook SPUISearchViewController

- (void)cancelButtonPressed{
    SPUISearchHeader *_searchHeader = MSHookIvar<SPUISearchHeader*>(self, "_searchHeader");
    SPUITextField *searchField = _searchHeader.searchField;
    
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
    }
        %orig;
}

%end