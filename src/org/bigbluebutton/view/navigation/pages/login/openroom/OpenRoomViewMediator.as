package org.bigbluebutton.view.navigation.pages.login.openroom {
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	
	import mx.core.FlexGlobals;
	
	import spark.components.View;
	
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class OpenRoomViewMediator extends Mediator {
		
		[Inject]
		public var view:IOpenRoomView;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		override public function initialize():void {
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.bottomMenu.includeInLayout = false;
			FlexGlobals.topLevelApplication.topActionBar.visible = false;
			(view as View).addEventListener(KeyboardEvent.KEY_DOWN, KeyHandler);
			view.goButton.addEventListener(MouseEvent.CLICK, onGoButtonClick);
		}
		
		private function KeyHandler(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				onGoButtonClick(null);
			}
		}
		
		private function onGoButtonClick(e:MouseEvent):void {
			var url:String = view.inputRoom.text;
			if (url.indexOf("http") == -1) {
				url = "http://" + url;
			}
			var urlReq:URLRequest = new URLRequest(url);
			navigateToURL(urlReq);
		}
		
		override public function destroy():void {
			super.destroy();
			(view as View).removeEventListener(KeyboardEvent.KEY_DOWN, KeyHandler);
			view.goButton.removeEventListener(MouseEvent.CLICK, onGoButtonClick);
			view.dispose();
			view = null;
		}
	}
}
