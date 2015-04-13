package org.bigbluebutton.view.navigation.pages.videochat
{
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.resources.ResourceManager;
	import mx.utils.ObjectUtil;
	
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.mockito.integrations.currentMockito;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	public class VideoChatViewMediator extends Mediator
	{
		[Inject]
		public var view: IVideoChatView;
		
		[Inject]
		public var userSession: IUserSession;
		
		[Inject]
		public var userUISession: IUserUISession;
		
		protected var dataProvider:ArrayCollection;
		
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
			userSession.userList.userRemovedSignal.add(userRemovedHandler);
			userSession.userList.userAddedSignal.add(userAddedHandler);
			userSession.userList.userChangeSignal.add(userChangeHandler);
			
			userUISession.pageTransitionStartSignal.add(onPageTransitionStart);
			view.streamlist.addEventListener(IndexChangeEvent.CHANGE, onSelectStream);
			
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'video.title');
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.profileBtn.visible = true;
			dataProvider = new ArrayCollection();
			view.streamlist.dataProvider = dataProvider;
			var users:ArrayCollection = userSession.userList.users;
			for each(var u:User in users)
			{
				if(u.hasStream && !dataProvider.contains(u))
				{
					addUserStreamNames(u);
				}
			}
			checkVideo();
		}
		
		private function addUserStreamNames(u:User):void{
			
			var existingStreamNames:Array = getUserStreamNamesByUserID(u.userID);
			var streamNames:Array = u.streamName.split("|");
			for each (var streamName:String in streamNames){
				var addNew:Boolean = true;
				for each (var existingUserStreamName:UserStreamName in existingStreamNames){
					if(streamName == existingUserStreamName.streamName){
						addNew = false;
					}
				}
				if (addNew){
					var userStreamName:UserStreamName = new UserStreamName(streamName, u);
					dataProvider.addItem(userStreamName);
				}
			}
			dataProvider.refresh();
		}
		
		protected function getUserWithCamera():User
		{
			var users:ArrayCollection = userSession.userList.users;
			var userMe:User = null;
			
			for each(var u:User in users) 
			{
				if (u.hasStream) 
				{
					if (u.me)
					{
						userMe = u;		
					}
					else
					{
						return u;
					}
				}
			}
			
			return userMe;
		}
		
		private function onPageTransitionStart(lastPage:String):void
		{
			if(lastPage == PagesENUM.VIDEO_CHAT)
			{
				view.dispose();
			}
		}
		
		private function onSelectStream(event:IndexChangeEvent):void
		{
			if (event.newIndex >= 0) 
			{
				var userStreamName:UserStreamName = dataProvider.getItemAt(event.newIndex) as UserStreamName;
				var user:User = userStreamName.user;
				if(user.hasStream)
				{
					if(getDisplayedUser() != null)
					{
						stopStream(getDisplayedUser().userID);
					}
					startStream(user.name, userStreamName.streamName);
				}
			}
		}
		
		override public function destroy():void
		{
			userSession.userList.userRemovedSignal.remove(userRemovedHandler);
			userSession.userList.userAddedSignal.remove(userAddedHandler);
			userSession.userList.userChangeSignal.remove(userChangeHandler);
			
			userUISession.pageTransitionStartSignal.remove(onPageTransitionStart);
			
			view.dispose();
			view = null;
			
			super.destroy();
		}
		
		private function userAddedHandler(user:User):void 
		{
			if (user.hasStream)
			{
				var streamNames:Array = user.streamName.split("|");
				for each (var streamName:String in streamNames){
					var userStreamName:UserStreamName = new UserStreamName(streamName, user);
					dataProvider.addItem(userStreamName);
				}
			}
		}
		
		private function userRemovedHandler(userID:String):void 
		{
			var displayedUser:User = getDisplayedUser();
			if(displayedUser)
			{
				if (displayedUser.userID == userID) 
				{
					stopStream(userID);
				}
			}
			for(var item:int; item<dataProvider.length; item++)
			{
				if((dataProvider.getItemAt(item).user as User).userID == userID)
				{
					// -- in the end. see: http://stackoverflow.com/questions/4255226/how-to-remove-an-item-while-iterating-over-collection
					dataProvider.removeItemAt(item--);
				}
			}
			if(dataProvider.length==0)
			{
				view.noVideoMessage.visible = true;
				view.noVideoMessage.includeInLayout = true;
				view.streamListScroller.visible = false;
				view.streamListScroller.includeInLayout = false;
				
			}
			else
			{
				view.noVideoMessage.visible = false;
				view.noVideoMessage.includeInLayout = false;
				view.streamListScroller.visible = true;
				view.streamListScroller.includeInLayout = true;
				checkVideo();
			}			
		}
		
		private function getUserStreamNamesByUserID(userID:String):Array{
			
			var userStreamNames:Array = new Array();
			
			for each(var userStreamName:UserStreamName in dataProvider){
				if(userStreamName.user.userID == userID){
					userStreamNames.push(userStreamName);
				}
			}
			
			return userStreamNames;
		}
		
		private function userChangeHandler(user:User, property:int):void 
		{
			if (property == UserList.HAS_STREAM)
			{
				var displayedUser:User = getDisplayedUser();
				if(displayedUser){
					if (user.userID == displayedUser.userID && !user.hasStream)
					{
						stopStream(user.userID);
					}				
				}
				
				var userStreamNames:Array = getUserStreamNamesByUserID(user.userID);
				
				for each(var userStreamName:UserStreamName in userStreamNames){
					if(!(userStreamName.user.streamName.indexOf(userStreamName.streamName) >= 0))
					{
						dataProvider.removeItem(userStreamName);
						if(userUISession.currentStreamName == userStreamName.streamName){
							userUISession.currentStreamName = "";
							checkVideo();
						}
					}
				}
				
				if(user.streamName.split("|").length > userStreamNames.length && user.streamName.length > 0)
				{
					addUserStreamNames(user);
				}
				
				if(userUISession.currentStreamName == ""){
					checkVideo();
				}
				
				if(dataProvider.length==0)
				{
					view.noVideoMessage.visible = true;
					view.noVideoMessage.includeInLayout = true;
					view.streamListScroller.visible = false;
					view.streamListScroller.includeInLayout = false;
				}
				else
				{
					view.noVideoMessage.visible = false;
					view.noVideoMessage.includeInLayout = false;
					view.streamListScroller.visible = true;
					view.streamListScroller.includeInLayout = true;
				}
			}
			
			dataProvider.refresh();
		}
		
		private function startStream(name:String, streamName:String):void 
		{
			var resolution:Object = getVideoResolution(streamName);
			
			if (resolution) 
			{
				trace(ObjectUtil.toString(resolution));
				var quality:String = String(resolution.dimensions)
				var width:Number;
				var length:Number;
				switch(quality) {
				case "low" :
					width = 160;
					length = 120;
					break;
				case "medium":
					width = 320;
					length = 240;
					break;
				case "high":
					width = 640;
					length = 480;
					break;
				default:
					trace("Unknown quality, setting to low quality");
					width = 160;
					length = 120;
					break;
				}
				
				if (view) 
				{
					view.startStream(userSession.videoConnection.connection, name, streamName, resolution.userID, width, length, view.streamListScroller.height, view.streamListScroller.width);
					userUISession.currentStreamName = streamName;
					view.videoGroup.height = view.video.height;
				}
			}
		}
		
		private function stopStream(userID:String):void 
		{
			if (view) 
			{
				view.stopStream();
				userUISession.currentStreamName = "";
			}
		}
		
		private function getDisplayedUser():User{
			for each(var userStreamName:UserStreamName in dataProvider){
				if(userStreamName.streamName == userUISession.currentStreamName){
					return userStreamName.user;
				}
			}
			return null;
		}
		
		private function checkVideo(changedUser:User = null):void 
		{
			
			// get id of the user that is currently displayed
			var currentUser:User = getDisplayedUser();
			
			// get user that was selected 
			var selectedUser:User = userUISession.currentPageDetails as User;
			
			// get presenter user
			var presenter:User = userSession.userList.getPresenter();
			
			// get any user that has video stream
			var userWithCamera:User = getUserWithCamera();
			
			var newUser:User;
					
			if (changedUser)
			{
				
				var userStreamNames:Array = getUserStreamNamesByUserID(changedUser.userID);
				
				// Priority state machine
				
				if (selectedUser && selectedUser.hasStream && changedUser.userID == selectedUser.userID)
				{
					if (view) view.stopStream();	
					startStream(changedUser.name, userStreamNames[0].streamName);
				}
				else if (changedUser.presenter && changedUser.hasStream)
				{
					if (view) view.stopStream();	
					startStream(changedUser.name, userStreamNames[0].streamName);
				}
				else if (currentUser && changedUser.userID == currentUser.userID)
				{
					if (view) view.stopStream();	
					startStream(changedUser.name, userStreamNames[0].streamName);
				}
				else if (userWithCamera)
				{
					if (userWithCamera.userID == changedUser.userID)
					{
						if (view) view.stopStream();	
						startStream(changedUser.name, userStreamNames[0].streamName);
					}
					else if (!changedUser.hasStream && userWithCamera.me)
					{
						var userStreamNames:Array = getUserStreamNamesByUserID(userWithCamera.userID);
						if (view) view.stopStream();	
						startStream(userWithCamera.name, userStreamNames[0].streamName);
					}
				}
			}
			else
			{	
				// Priority state machine
				
				// if user was directly selected, show this user as a first priority
				if (selectedUser && selectedUser.hasStream)
				{
					newUser = selectedUser;
				}
					// if presenter is transmitting a video - put them in second priority
				else if (presenter != null && presenter.hasStream)
				{
					newUser = presenter;
				}
					// current user is the third priority
				else if (currentUser != null) 
				{
					newUser = currentUser;
				}
					// any user with camera is the last priority
				else if (userWithCamera != null)
				{
					newUser = userWithCamera;
				}
					// otherwise, nobody transmitts video at this moment
				else
				{
					return;
				}
								
				if (newUser)
				{
					var userStreamNames:Array = getUserStreamNamesByUserID(newUser.userID);
					if (view) view.stopStream();	
					var displayUserStreamName:UserStreamName = userStreamNames[0];
					for each (var userStreamName:UserStreamName in userStreamNames){
						if(userUISession.currentStreamName == userStreamName.streamName){
							displayUserStreamName = userStreamName;
							break;
						}
					}
					view.streamlist.selectedIndex = dataProvider.getItemIndex(displayUserStreamName);
					startStream(newUser.name, displayUserStreamName.streamName);
					view.streamlist.selectedIndex = dataProvider.getItemIndex(userStreamNames[0]);
					view.noVideoMessage.visible = false;
					view.noVideoMessage.includeInLayout = false;
					view.streamListScroller.visible = true;
					view.streamListScroller.includeInLayout = true;
				}	
			}
		}
		
		protected function getVideoResolution(stream:String):Object
		{
			trace(stream);
			var pattern:RegExp = new RegExp("([a-z]+)-([A-Za-z0-9]+)-\\d+", "");
			if (pattern.test(stream))
			{
				trace("The stream name is well formatted [" + stream + "]");
				trace("Stream resolution is [" + pattern.exec(stream)[1] + "]");
				trace("Userid [" + pattern.exec(stream)[2] + "]");
				return {userID: pattern.exec(stream)[2], dimensions:pattern.exec(stream)[1]};
			}
			else
			{
				trace("The stream name doesn't follow the pattern <quality>-<userId>-<timestamp>. However, the video resolution will be set to 320x240");
				return null;
			}
		}
	}
}