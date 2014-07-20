/*

BitTime
(c)2008 KR & con3 Office

*/

#import "bittime.h"
#import "AppKit/NSGraphics.h"
#import "AppKit/NSSound.h"

@implementation bittime

//初期化
- (id)init {
	self = [super init];
	if (!self) {
        return nil;
	}
	
	return self;
}

//ウインドウを閉じて終了
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

//終了処理
- (void)applicationWillTerminate:(NSNotification *)aNotification
{

	if([alarm_au isPlaying] == YES){
		[alarm_au stop];
	}

	if (timer_working){
		[mytimer invalidate];
	}

}

//終了
- (void)dealloc
{

    [alarm_au release];
    [mytimer release];
    [ss release];
    [mm release];
    
    [super dealloc];
}

//アプリ初期化
- (void)awakeFromNib
{

	timer_working = FALSE;
	botan = FALSE;
	mm = [[NSMutableString alloc] init];
	ss = [[NSMutableString alloc] init];
	alarm_au = [NSSound soundNamed:@"alarm"];

	[mm setString:@"00"];
	[ss setString:@"00"];
		//初期化


	
/*
	NSLog(@"Min:%@, Sec:%@",mm,ss);

	[min setStringValue:@"00"];
	[sec setStringValue:@"00"];

	NSDate*	nowTime = [NSDate date];
	[mm setString:[nowTime descriptionWithCalendarFormat:@"%M" timeZone:nil locale:nil]];
	[ss setString:[nowTime descriptionWithCalendarFormat:@"%S" timeZone:nil locale:nil]];
*/

}

//時間設定（総秒数からの正規化及び，表示と変数の動機）
- (void)set_time:(int)now_second
{
	int tmp_second;
	int tmp_min;
	int tmp_sec;

	if (now_second > 5999) {
		tmp_second = 5999;	//ルーチン内数値修正
		now_sec = 5999;		//カウント用変数修正
		total_sec = 5999;	//設定総秒数修正
	}
	else{
		tmp_second = now_second;
	}
	
	tmp_min = tmp_second / 60;
	tmp_sec = tmp_second - (tmp_min * 60);

	[mm setString:[NSString stringWithFormat:@"%02d",tmp_min]];
	[ss setString:[NSString stringWithFormat:@"%02d",tmp_sec]];
	[min setStringValue:[NSString stringWithFormat:@"%02d",tmp_min]];
	[sec setStringValue:[NSString stringWithFormat:@"%02d",tmp_sec]];
	[test setString:[NSString stringWithFormat:@"%02d",tmp_sec]];
	[test sizeToFit];
}

//数値入力処理（秒数分数間の数字繰り上がり処理と表示）
- (void)input_num:(NSString*)in_num
{

	NSMutableString* oldm;
	NSMutableString* olds;
	
	oldm = [[NSMutableString alloc] init];
	olds = [[NSMutableString alloc] init];

	[oldm setString:mm];
	[olds setString:ss];
	
	NSRange leftone = NSMakeRange(0,1);		//左の１文字分（３文字前提）
	NSRange righttwo = NSMakeRange(1,2);	//右の２文字分（３文字前提）
	[mm setString:[[oldm stringByAppendingString:[olds substringWithRange:leftone]] substringWithRange:righttwo]];
	[ss setString:[[olds stringByAppendingString:in_num] substringWithRange:righttwo]];
		//表示用文字列での数値繰り上がり処理

	m = [mm intValue];
	s = [ss intValue];
		//数値への変換と総秒数計算

	[min setStringValue:[NSString stringWithFormat:@"%02d",m]];
	[sec setStringValue:[NSString stringWithFormat:@"%02d",s]];
		//表示
}

//カウントダウン処理（ループから呼び出し）
- (void)count_down
{
	now_sec--;
	
	if (now_sec)
	{

		[self set_time:now_sec];
		//NSLog(@"Now:%d",now_sec);
		return;
	}

	[self set_time:now_sec];
	//NSLog(@"Now:%d",now_sec);

	[mytimer invalidate];
	timer_working = FALSE;
		//タイマー解除

	[mm setString:@"00"];
	[ss setString:@"00"];
	m = [mm intValue];
	s = [ss intValue];
	total_sec = (m * 60) + s;
		//リセット

	[alarm_au play];
	//アラーム音再生
	[SSbutton setState:NSOffState]; //「Start」表示	


}

//数字ボタン
- (IBAction)b0:(id)sender
{
	if (!timer_working){
		[self input_num:@"0"];
	}
}

- (IBAction)b1:(id)sender
{
	if (!timer_working){
		[self input_num:@"1"];
	}
}

- (IBAction)b2:(id)sender
{
	if (!timer_working){
		[self input_num:@"2"];
	}
}

- (IBAction)b3:(id)sender
{
	if (!timer_working){
		[self input_num:@"3"];
	}
}

- (IBAction)b4:(id)sender
{
	if (!timer_working){
		[self input_num:@"4"];
	}
}

- (IBAction)b5:(id)sender
{
	if (!timer_working){
		[self input_num:@"5"];
	}
}

- (IBAction)b6:(id)sender
{
	if (!timer_working){
		[self input_num:@"6"];
	}
}

- (IBAction)b7:(id)sender
{
	if (!timer_working){
		[self input_num:@"7"];
	}
}

- (IBAction)b8:(id)sender
{
	if (!timer_working){
		[self input_num:@"8"];
	}
}

- (IBAction)b9:(id)sender
{
	if (!timer_working){
		[self input_num:@"9"];
	}
}

//スタートストップボタン
- (IBAction)bSS:(id)sender
{

	total_sec = ([mm intValue] * 60) + [ss intValue];
		//総秒数計算

	if(!botan){
		botan = TRUE;
		SSbutton = sender; //トグルボタンのインスタンス先を保存
	}

	if(!total_sec){
		[sender setState:NSOffState]; //「Start」表示	
		timer_working = FALSE;
		if([alarm_au isPlaying] == YES){
			[alarm_au stop];
		}
		return; //0秒の場合は反応せず返す
	}

	if (!timer_working){
	
		[sender setState:NSOnState]; //「Stop」表示

		now_sec = total_sec; //カウント用秒数変数にコピー
		[self set_time:now_sec];

		mytimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count_down) userInfo:nil repeats:YES];
		timer_working = TRUE;
			//タイマー稼働

		return;
	}

	[sender setState:NSOffState];
		//「Start」表示	

	[mytimer invalidate];	
	timer_working = FALSE;
		//タイマー解除

	total_sec = now_sec;
	m = [mm intValue];
	s = [ss intValue];
		//途中で止めた場合の現在数値を設定
}

//メニュー「File->New」
- (IBAction)new:(id)sender
{

	[mm setString:@"00"];
	[ss setString:@"00"];
	m = [mm intValue];
	s = [ss intValue];
	total_sec = (m * 60 ) + s;
	[self set_time:total_sec];
		//リセット
}

@end
