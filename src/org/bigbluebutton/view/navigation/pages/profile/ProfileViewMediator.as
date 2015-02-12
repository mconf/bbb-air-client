package org.bigbluebutton.view.navigation.pages.profile
{
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	
	import org.bigbluebutton.command.DisconnectUserSignal;
	import org.bigbluebutton.command.MoodSignal;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	public class ProfileViewMediator extends Mediator
	{
		[Inject]
		public var view: IProfileView;
		
		[Inject]
		public var userSession: IUserSession;
		
		[Inject] 
		public var moodSignal: MoodSignal;
		
		[Inject]
		public var disconnectUserSignal: DisconnectUserSignal;
			
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
			
			userSession.userList.userChangeSignal.add(userChangeHandler);
			
			var userMe:User = userSession.userList.me;		
			
			view.userNameButton.label = userMe.name;
			view.moodList.addEventListener(IndexChangeEvent.CHANGE, onMoodChange);
			view.logoutButton.addEventListener(MouseEvent.CLICK, logoutClick);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'profile.title');
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = true;			
		}
		
		private function userChangeHandler(user:User, type:int):void
		{
			if (user.me && type == UserList.RAISE_HAND) 
			{
				view.raiseHandButton.label = ResourceManager.getInstance().getString('resources', (user.status==User.RAISE_HAND) ?'profile.settings.handLower' : 'profile.settings.handRaise');
			}
		}
		
		protected function onMoodChange(event:IndexChangeEvent):void
		{			
			var obj:Object;
			obj = view.moodList.selectedItem;
			moodSignal.dispatch( view.moodList.selectedItem.signal);
		}
		
		
		/**
		 * User pressed log out button
		 */ 
		public function logoutClick(event:MouseEvent):void
		{
			disconnectUserSignal.dispatch(DisconnectEnum.CONNECTION_STATUS_USER_LOGGED_OUT);
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			userSession.userList.userChangeSignal.remove(userChangeHandler);			
			view.moodList.removeEventListener(IndexChangeEvent.CHANGE, onMoodChange);
			view.logoutButton.removeEventListener(MouseEvent.CLICK, logoutClick);
			
			view.dispose();
			view = null;
		}
	}
}
