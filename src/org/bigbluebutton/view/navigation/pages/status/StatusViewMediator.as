package org.bigbluebutton.view.navigation.pages.status {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.events.ResizeEvent;
	import mx.resources.ResourceManager;
	import org.bigbluebutton.command.MoodSignal;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import spark.events.IndexChangeEvent;
	
	public class StatusViewMediator extends Mediator {
		
		[Inject]
		public var view:IStatusView;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		[Inject]
		public var moodSignal:MoodSignal;
		
		override public function initialize():void {
			var userMe:User = userSession.userList.me;
			view.moodList.addEventListener(IndexChangeEvent.CHANGE, onMoodChange);
			userSession.userList.userChangeSignal.add(userChanged);
			FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'profile.status');
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = true;
			selectMood(userMe.status);
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			var tabletLandscape = FlexGlobals.topLevelApplication.isTabletLandscape();
			if (tabletLandscape) {
				userUISession.popPage();
				userUISession.popPage();
				userUISession.pushPage(PagesENUM.SPLITSETTINGS, PagesENUM.STATUS);
			}
		}
		
		private function userChanged(user:User, type:int):void {
			if (user == userSession.userList.me) {
				selectMood(user.status);
			}
		}
		
		private function selectMood(mood:String):void {
			for (var i:Number = 0; i < view.moodList.dataProvider.length; i++) {
				if (mood == view.moodList.dataProvider.getItemAt(i).signal) {
					view.moodList.setSelectedIndex(i);
					break;
				}
			}
		}
		
		protected function onMoodChange(event:IndexChangeEvent):void {
			var obj:Object;
			obj = view.moodList.selectedItem;
			moodSignal.dispatch(view.moodList.selectedItem.signal);
			if (!FlexGlobals.topLevelApplication.isTabletLandscape()) {
				userUISession.popPage();
				userUISession.popPage();
			}
		}
		
		override public function destroy():void {
			super.destroy();
			view.moodList.removeEventListener(IndexChangeEvent.CHANGE, onMoodChange);
			FlexGlobals.topLevelApplication.stage.removeEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			userSession.userList.userChangeSignal.remove(userChanged);
			view.dispose();
			view = null;
		}
	}
}
