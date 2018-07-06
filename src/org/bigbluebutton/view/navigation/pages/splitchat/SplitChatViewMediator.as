package org.bigbluebutton.view.navigation.pages.splitchat {
	
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.ResizeEvent;
	
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.splitsettings.SplitViewEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class SplitChatViewMediator extends Mediator {
		
		[Inject]
		public var view:ISplitChatView;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		private var currentChat:Object = null;
		
		override public function initialize():void {
			eventDispatcher.addEventListener(SplitViewEvent.CHANGE_VIEW, changeView);
			view.participantsList.pushView(PagesENUM.getClassfromName(PagesENUM.CHATROOMS));
			FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			var tabletLandscape:Boolean = FlexGlobals.topLevelApplication.isTabletLandscape();
			if (currentChat) {
				if (tabletLandscape) {
					userUISession.pushPage(PagesENUM.SPLITCHAT, currentChat);
				} else {
					if (currentChat.hasOwnProperty("button")) {
						userUISession.pushPage(PagesENUM.SELECT_PARTICIPANT, userUISession.currentPageDetails);
					} else {
						userUISession.pushPage(PagesENUM.CHAT, currentChat);
					}
				}
			}
		}
		
		private function changeView(event:SplitViewEvent):void {
			view.participantDetails.pushView(event.view);
			currentChat = event.details;
			userUISession.pushPage(PagesENUM.SPLITCHAT, event.details)
		}
		
		override public function destroy():void {
			super.destroy();
			eventDispatcher.removeEventListener(SplitViewEvent.CHANGE_VIEW, changeView);
			FlexGlobals.topLevelApplication.stage.removeEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			view.dispose();
			view = null;
		}
	}
}
