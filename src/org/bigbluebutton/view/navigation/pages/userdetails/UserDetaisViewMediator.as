package org.bigbluebutton.view.navigation.pages.userdetails
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.resources.ResourceManager;
	import mx.states.Transition;
	
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.TransitionAnimationENUM;
	import org.osmf.logging.Log;
	
	import org.bigbluebutton.command.ChangeRoleSignal;
	import org.bigbluebutton.command.ClearUserStatusSignal;
	import org.bigbluebutton.command.PresenterSignal;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class UserDetaisViewMediator extends Mediator
	{
		[Inject]
		public var view: IUserDetaisView;
		
		[Inject]
		public var userSession: IUserSession;
		
		[Inject]
		public var userUISession: IUserUISession;
		
		[Inject] 
		public var clearUserStatusSignal: ClearUserStatusSignal;
		
		[Inject] 
		public var presenterSignal: PresenterSignal;
		
		[Inject] 
		public var changeRoleSignal: ChangeRoleSignal;
		
		protected var _user:User;
		
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
			
			_user = userUISession.currentPageDetails as User;

			userSession.userList.userChangeSignal.add(userChanged);
			userSession.userList.userRemovedSignal.add(userRemoved);
						
			view.user = _user;
			view.userMe = userSession.userList.me;
			
			view.showCameraButton.addEventListener(MouseEvent.CLICK, onShowCameraButton);
			view.showPrivateChat.addEventListener(MouseEvent.CLICK, onShowPrivateChatButton);
			view.clearStatusButton.addEventListener(MouseEvent.CLICK, onClearStatusButton);
			view.makePresenterButton.addEventListener(MouseEvent.CLICK, onMakePresenterButton);
			view.promoteButton.addEventListener(MouseEvent.CLICK, onPromoteButton);
			FlexGlobals.topLevelApplication.pageName.text = view.user.name;
			FlexGlobals.topLevelApplication.backBtn.visible = true;
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
		}
		
		protected function onShowCameraButton(event:MouseEvent):void
		{
			userUISession.pushPage(PagesENUM.VIDEO_CHAT, _user, TransitionAnimationENUM.APPEAR);
		}
		
		protected function onShowPrivateChatButton(event:MouseEvent):void
		{
			userUISession.pushPage(PagesENUM.CHAT, _user, TransitionAnimationENUM.APPEAR);
		}
		
		protected function onClearStatusButton(event:MouseEvent):void
		{
			clearUserStatusSignal.dispatch(_user.userID);
			userSession.userList.getUser(_user.userID).status = User.NO_STATUS;
			view.clearStatusButton.includeInLayout = false;
			view.clearStatusButton.visible = false;
			userUISession.popPage();
		}
		
		protected function onPromoteButton(event:MouseEvent):void
		{
			var roleOptions:Object = new Object();
			roleOptions.userID = _user.userID;
			roleOptions.role = (_user.role == User.MODERATOR) ? User.VIEWER : User.MODERATOR;
			changeRoleSignal.dispatch(roleOptions);
			userUISession.popPage();
		}
		
		protected function onMakePresenterButton(event:MouseEvent):void
		{
			presenterSignal.dispatch(_user, userSession.userList.me.userID);
			userUISession.popPage();
		}
		
		private function userRemoved(userID:String):void
		{
			if(_user.userID == userID)
			{
				userUISession.popPage();
			}
		}
		
		private function userChanged(user:User, type:int):void
		{
			if(_user.userID == user.userID || user.me )
			{
				view.update();
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			view.showCameraButton.removeEventListener(MouseEvent.CLICK, onShowCameraButton);
			view.showPrivateChat.removeEventListener(MouseEvent.CLICK, onShowPrivateChatButton);
			
			userSession.userList.userChangeSignal.remove(userChanged);
			userSession.userList.userRemovedSignal.remove(userRemoved);
			
			view.dispose();
			view = null;
		}
	}
}