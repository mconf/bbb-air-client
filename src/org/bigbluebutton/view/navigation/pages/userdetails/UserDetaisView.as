package org.bigbluebutton.view.navigation.pages.userdetails
{
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.IUserSession;
	
	import spark.components.Button;
	
	public class UserDetaisView extends UserDetaisViewBase implements IUserDetaisView
	{
		public function UserDetaisView():void
		{
				
		}	
		
		protected var _user:User;
		protected var _userMe:User;
		
		public function set user(u:User):void
		{
			_user = u;
			update();
		}
		
		public function set userMe(u:User):void
		{
			_userMe = u;
			update();
		}
		
		public function get user():User
		{
			return _user;
		}
		
		public function get userMe():User
		{
			return _userMe;
		}
		
		public function update():void
		{
			if(user != null && FlexGlobals.topLevelApplication.mainshell != null && userMe != null)
			{			
				if(_user.me)
				{
					userNameText.text = _user.name + " " +resourceManager.getString('resources', 'userDetail.you');
				}
				else
				{
					userNameText.text = _user.name;
				}
				
				if(_user.presenter)
				{
					statusText.text = resourceManager.getString('resources', 'participants.status.presenter');
				}
				else if(_user.role == "MODERATOR")
				{
					statusText.text = resourceManager.getString('resources', 'participants.status.moderator');
				}
				else
				{
					statusText.text = "";
				}
				
				if(_user.status != User.NO_STATUS && _userMe.role == "MODERATOR"){
					clearStatusButton.includeInLayout = true;
					clearStatusButton.visible = true;
				}
				else {
					clearStatusButton.includeInLayout = false;
					clearStatusButton.visible = false;
				}
				
				cameraIcon.visible = cameraIcon.includeInLayout = _user.hasStream;
				micIcon.visible = micIcon.includeInLayout = (_user.voiceJoined && !_user.muted);
				micOffIcon.visible = micOffIcon.includeInLayout = (_user.voiceJoined && _user.muted);
				noMediaText.visible = noMediaText.includeInLayout = (!_user.voiceJoined && !_user.hasStream);
				
				//TODO: buttons
				showCameraButton0.includeInLayout = _user.hasStream;
				showCameraButton0.visible = _user.hasStream;
				
				showPrivateChat0.includeInLayout = !_user.me;
				showPrivateChat0.visible = !_user.me;
			}
		}
		
		public function dispose():void
		{

		}

		public function get showCameraButton():Button
		{
			return showCameraButton0;
		}
		
		public function get showPrivateChat():Button
		{
			return showPrivateChat0;
		}
		
		public function get clearStatusButton():Button
		{
			return clearStatusButton0;
		}
		
		
	}
}