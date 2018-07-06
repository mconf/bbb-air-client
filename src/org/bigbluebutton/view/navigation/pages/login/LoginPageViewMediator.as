package org.bigbluebutton.view.navigation.pages.login {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.command.JoinMeetingSignal;
	import org.bigbluebutton.core.ILoginService;
	import org.bigbluebutton.core.ISaveData;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class LoginPageViewMediator extends Mediator {
		private const LOG:String = "LoginPageViewMediator::";
		
		[Inject]
		public var view:ILoginPageView;
		
		[Inject]
		public var joinMeetingSignal:JoinMeetingSignal;
		
		[Inject]
		public var loginService:ILoginService;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		[Inject]
		public var saveData:ISaveData;
		
		private var count:Number = 0;
		
		override public function initialize():void {
			//loginService.unsuccessJoinedSignal.add(onUnsucess);
			userUISession.unsuccessJoined.add(onUnsucess);
			view.tryAgainButton.addEventListener(MouseEvent.CLICK, tryAgain);
			joinRoom(userSession.joinUrl);
		}
		
		private function onUnsucess(reason:String):void {
			trace(LOG + "onUnsucess() " + reason);
			FlexGlobals.topLevelApplication.topActionBar.visible = false;
			FlexGlobals.topLevelApplication.bottomMenu.visible = false;
			switch (reason) {
				case "emptyJoinUrl":
					if (!saveData.read("rooms")) {
						view.currentState = LoginPageViewBase.STATE_NO_REDIRECT;
					}
					break;
				case "invalidMeetingIdentifier":
					view.currentState = LoginPageViewBase.STATE_INVALID_MEETING_IDENTIFIER;
					break;
				case "checksumError":
					view.currentState = LoginPageViewBase.STATE_CHECKSUM_ERROR;
					break;
				case "invalidPassword":
					view.currentState = LoginPageViewBase.STATE_INVALID_PASSWORD;
					break;
				case "invalidURL":
					view.currentState = LoginPageViewBase.STATE_INAVLID_URL;
					break;
				case "genericError":
					view.currentState = LoginPageViewBase.STATE_GENERIC_ERROR;
					break;
				case "authTokenTimedOut":
					view.currentState = LoginPageViewBase.STATE_AUTH_TOKEN_TIMEDOUT;
					break;
				case "authTokenInvalid":
					view.currentState = LoginPageViewBase.STATE_AUTH_TOKEN_INVALID;
					break;
				default:
					view.currentState = LoginPageViewBase.STATE_GENERIC_ERROR;
					break;
			}
			// view.messageText.text = reason;
		}
		
		public function joinRoom(url:String):void {
			if (url == null || url.length == 0) {
				if (isDebugBuild()) {
					url = "https://live-pa01.mconf.rnp.br/bigbluebutton/api/join?fullName=User+3542281&meetingID=990a5cd0-f685-430c-942e-b021ec78f3bc-1397501921&password=dc78fe3a-bf9f-42e9-872f-46c6934e691c&redirect=true&checksum=b917b7b456bf244cbb88e2f59c7751f5486b320f";
					// url = "";
				} else {
					url = "";
				}
			}
			if (url.lastIndexOf("://") == -1) {
				userUISession.popPage();
				userUISession.pushPage(PagesENUM.OPENROOM);
			}
			joinMeetingSignal.dispatch(url);
		}
		
		/**
		 * Returns true if the swf is built in debug mode
		 **/
		private function isDebugBuild() : Boolean
		{
			var stackTrace:String = new Error().getStackTrace();
			if(stackTrace == null || stackTrace.length == 0)
			{
				//in Release the stackTrace is null
				return false;
			}
			//The code searches for line numbers of errors in StackTrace result. 
			//Only StackTrace result of a debug SWF file contains line numbers.
			return stackTrace.search(/:[0-9]+]$/m) > -1;
		}
		
		override public function destroy():void {
			super.destroy();
			//loginService.unsuccessJoinedSignal.remove(onUnsucess);
			userUISession.unsuccessJoined.remove(onUnsucess);
			view.dispose();
			view = null;
		}
		
		private function tryAgain(event:Event):void {
			FlexGlobals.topLevelApplication.mainshell.visible = false;
			userUISession.popPage();
			userUISession.pushPage(PagesENUM.LOGIN);
		}
	}
}
