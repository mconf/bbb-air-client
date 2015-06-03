package org.bigbluebutton.view.navigation.pages.status {
	
	import flash.events.MouseEvent;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	import org.bigbluebutton.command.MoodSignal;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
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
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'profile.status');
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = true;
		}
		
		protected function onMoodChange(event:IndexChangeEvent):void {
			var obj:Object;
			obj = view.moodList.selectedItem;
			moodSignal.dispatch(view.moodList.selectedItem.signal);
			userUISession.popPage();
			userUISession.popPage();
		}
		
		override public function destroy():void {
			super.destroy();
			view.moodList.removeEventListener(IndexChangeEvent.CHANGE, onMoodChange);
			view.dispose();
			view = null;
		}
	}
}
