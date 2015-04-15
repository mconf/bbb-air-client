package org.bigbluebutton.view.navigation.pages.common
{
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class MenuButtonsViewMediator extends Mediator
	{
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var usersService:IUsersService;
		
		[Inject]
		public var userUISession: IUserUISession;
		
		[Inject]
		public var view:MenuButtonsView;
		
		public override function initialize():void
		{	
			userUISession.loadingSignal.add(loadingFinished);	
			userSession.guestList.guestAddedSignal.add(addGuest);
			userSession.guestList.guestRemovedSignal.add(guestRemoved);
			userSession.userList.userChangeSignal.add(userChanged);
		}
		
		private function updateGuestsNotification():void{
			var numberOfGuests:int = userSession.guestList.guests.length;
			if(numberOfGuests > 0 && userSession.userList.me.role == "MODERATOR"){
				view.menuParticipantsButton.label = String(numberOfGuests);
			}
			else {
				view.menuParticipantsButton.label = "";
			}
		}
		
		private function addGuest(guest:Object):void{
			updateGuestsNotification();
		}
		
		private function guestRemoved(userID:String):void{
			updateGuestsNotification();
		}
		
		private function userChanged(user:User, property:String = null):void{
			if(user.me){
				updateGuestsNotification();
			}
		}
		
		private function loadingFinished(loading:Boolean):void
		{
			if (!loading)
			{
				usersService.getWaitingGuests();
				updateGuestsNotification();
				
				/*var users:ArrayCollection = userSession.userList.users;*/
				userUISession.loadingSignal.remove(loadingFinished);
				if (userSession.deskshareConnection != null)
				{
					view.menuDeskshareButton.visible = view.menuDeskshareButton.includeInLayout = userSession.deskshareConnection.isStreaming;
					userSession.deskshareConnection.isStreamingSignal.add(onDeskshareStreamChange);
				}
				/*userSession.userList.userChangeSignal.add(userChangeHandler);
				for each(var u:User in users) 
				{
					if(u.hasStream)
					{
						view.menuVideoChatButton.visible = view.menuVideoChatButton.includeInLayout = true;
						break;
					}
				}*/
			}
		}
		/**
		 * If we recieve signal that deskshare stream is on - include Deskshare button to the layout
		 */ 
		public function onDeskshareStreamChange(isDeskshareStreaming:Boolean):void
		{
			view.menuDeskshareButton.visible = view.menuDeskshareButton.includeInLayout = isDeskshareStreaming;
		}
		
		/*private function userChangeHandler(user:User, property:int):void
		{
			var users:ArrayCollection = userSession.userList.users;
			var hasStream : Boolean = false;
			if (property == UserList.HAS_STREAM )
			{
				if(user.hasStream)
				{
					hasStream = true;
				}
				else
				{
					for each(var u:User in users)
					{
						if(u.hasStream)
						{
							hasStream = true;
							break;
						}			
					}
				}
				view.menuVideoChatButton.visible = view.menuVideoChatButton.includeInLayout = hasStream;
			}
		}*/
		
		/**
		 * Unsubscribe from listening for Deskshare Streaming Signal
		 */
		public override function destroy():void
		{
			userSession.deskshareConnection.isStreamingSignal.remove(onDeskshareStreamChange);
			/*userSession.userList.userChangeSignal.remove(userChangeHandler);*/
		}
	}
}