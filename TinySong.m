//
//  TinySong.m
//  TinySong
//
//  Created by Nicolas Haunold on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TinySong.h"
#import "iTunes.h"

#define _API_KEY @"<insert api key>"

@implementation TinySong

- (NSString *)pasteboardNameForTriggeredRaindrop {
	NSPasteboard *board = [NSPasteboard pasteboardWithUniqueName];
	iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	if([iTunes isRunning]) {
		iTunesBrowserWindow *browserWindow = [[iTunes browserWindows] lastObject];
		NSArray *selectedSongs = (NSArray *)[[browserWindow selection] get];
		iTunesFileTrack *track = [selectedSongs lastObject];
		NSString *encodedTrack = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[NSString stringWithFormat:@"%@ %@", [track name], [track artist]], NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
		NSURL *trackURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinysong.com/a/%@&key=%@", encodedTrack, _API_KEY]];
		NSData *connData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:trackURL] returningResponse:nil error:nil];
		if(connData != nil) {
			NSString *str = [[NSString alloc] initWithData:connData encoding:NSUTF8StringEncoding];
			if(![str isEqualToString:@"NSF;"]) {
				[board setString:str forType:NSStringPboardType];
			}

			[str release];
		}

		[encodedTrack release];
	}

	return [board name];
}


@end
