package org.bigbluebutton.view.navigation.pages.exit
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.view.navigation.pages.common.MenuButtons;
	import org.bigbluebutton.view.navigation.pages.disconnect.IDisconnectPageView;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectType;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class ExitPageViewMediator extends Mediator
	{	
		[Inject]
		public var view:IExitPageView;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		[Inject]
		public var userSession: IUserSession;
			
		override public function initialize():void
		{
			// If operating system is iOS, don't show exit button because there is no way to exit application:
			if(Capabilities.version.indexOf('IOS') >= 0) {
				view.yesButton.visible = false;
				view.noButton.visible = false;
			}
			else {
				view.yesButton.addEventListener(MouseEvent.CLICK, applicationExit);
				view.noButton.addEventListener(MouseEvent.CLICK, backToApplication);
			}
			
			changeConnectionStatus(userUISession.currentPageDetails as int);
			FlexGlobals.topLevelApplication.pageName.text = "";
			FlexGlobals.topLevelApplication.profileBtn.visible = true;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
		}
		
		/**
		 * Sets the disconnect status based on disconnectionStatusCode received from DisconnectUserCommand
		 */ 
		public function changeConnectionStatus(disconnectionStatusCode:int):void
		{
			switch(disconnectionStatusCode)
			{
				case DisconnectEnum.CONNECTION_STATUS_MEETING_ENDED:
					view.currentState = DisconnectType.CONNECTION_STATUS_MEETING_ENDED_STRING;
					break;
				case DisconnectEnum.CONNECTION_STATUS_CONNECTION_DROPPED:
					view.currentState = DisconnectType.CONNECTION_STATUS_CONNECTION_DROPPED_STRING;
					break;
				case DisconnectEnum.CONNECTION_STATUS_USER_KICKED_OUT:
					view.currentState = DisconnectType.CONNECTION_STATUS_USER_KICKED_OUT_STRING;
					break;
				case DisconnectEnum.CONNECTION_STATUS_USER_LOGGED_OUT:
					view.currentState = DisconnectType.CONNECTION_STATUS_USER_LOGGED_OUT_STRING;
					break;
				case DisconnectEnum.CONNECTION_STATUS_MODERATOR_DENIED:
					view.currentState = DisconnectType.CONNECTION_STATUS_MODERATOR_DENIED_STRING;
					break;
			}	
		}
		
		private function applicationExit(event:Event):void
		{
			trace("DisconnectPageViewMediator.applicationExit - exitting the application!");
			NativeApplication.nativeApplication.exit();
		}
		
		private function backToApplication(event:Event):void
		{
			userUISession.popPage();
		}
	}
}