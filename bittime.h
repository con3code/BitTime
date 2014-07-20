/* bittime */

#import <Cocoa/Cocoa.h>

@interface bittime : NSObject
{
    IBOutlet NSTextField *min; //表示分数
    IBOutlet NSTextField *sec; //表示秒数
    IBOutlet NSTextView *test; //

	NSTimer*	mytimer; //タイマー
	
	NSMutableString*	mm; //設定分数文字
	NSMutableString*	ss; //設定秒数文字

	int m; //設定分数
	int s; //設定秒数
	int total_sec; //設定総秒数

	int now_sec; //カウント用変動秒数
	
	BOOL timer_working; //タイマー稼働フラグ
	BOOL botan; //トグルボタンのインスタンス先取得処理有無
	BOOL count_updown; //カウントアップかダウンか

	NSSound*	alarm_au;
	NSColor*	background_normal; //通常用バックグラウンドカラー 
	NSColor*	background_alarm; //アラーム用バッククラウン土カラー

	id SSbutton; //トグルボタンのインスタンス先保存用

}
- (IBAction)b0:(id)sender;
- (IBAction)b1:(id)sender;
- (IBAction)b2:(id)sender;
- (IBAction)b3:(id)sender;
- (IBAction)b4:(id)sender;
- (IBAction)b5:(id)sender;
- (IBAction)b6:(id)sender;
- (IBAction)b7:(id)sender;
- (IBAction)b8:(id)sender;
- (IBAction)b9:(id)sender;
- (IBAction)bSS:(id)sender;
- (IBAction)new:(id)sender;
@end
