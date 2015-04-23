package org.bigbluebutton.view.navigation.pages.common
{
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.chat.IChatMessagesSession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.TransitionAnimationENUM;
	import org.bigbluebutton.view.skins.NavigationButtonSkin;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import spark.transitions.ViewTransitionBase;
	
	public class MenuButtonsViewMediator extends Mediator
	{
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var usersService:IUsersService;
		
		[Inject]
		public var chatMessagesSession:IChatMessagesSession;
		
		[Inject]
		public var userUISession: IUserUISession;
		
		[Inject]
		public var view:MenuButtonsView;
		
		public override function initialize():void
		{	
			userUISession.loadingSignal.add(loadingFinished);	
			userUISession.pageChangedSignal.add(pageChanged);
			userSession.guestList.guestAddedSignal.add(addGuest);
			userSession.userList.userChangeSignal.add(userChanged);
			chatMessagesSession.newChatMessageSignal.add(updateMessagesNotification);
			userSession.presentationList.presentationChangeSignal.add(presentationChanged);
		}
		
		private function presentationChanged(){
			userSession.presentationList.currentPresentation.slideChangeSignal.add(updatePresentationNotification);
		}
		
		private function updatePresentationNotification(){
			trace("++ novo slide?");
			if(userUISession.currentPage != PagesENUM.PRESENTATION){
				(view.menuPresentationButton.skin as NavigationButtonSkin).notification.visible  = true;
			}
			else {
				(view.menuPresentationButton.skin as NavigationButtonSkin).notification.visible  = false;
			}
		}
		
		private function updateMessagesNotification(userID:String, publicChat:Boolean):void {
			
			var notification = (view.menuChatButton.skin as NavigationButtonSkin).notification;
			
			var data = userUISession.currentPageDetails;
			
			var currentPageIsPublicChat:Boolean = data && data.hasOwnProperty("user") && !data.user;
			var currentPageIsPrivateChatOfTheSender:Boolean = (data is User && userID == data.userID) || (data && data.hasOwnProperty("user") && data.user && data.user.userID == userID);
			
			if(userUISession.currentPage != PagesENUM.CHATROOMS && !(currentPageIsPrivateChatOfTheSender && !publicChat) && !(currentPageIsPublicChat && publicChat)){
				notification.visible  = true;
			}
			else {
				notification.visible  = false;
			}
		}
		
		private function pageChanged(pageName:String, pageRemoved:Boolean = false, animation:int = TransitionAnimationENUM.APPEAR, transition:ViewTransitionBase = null):void{
			if(pageName == PagesENUM.PARTICIPANTS){
				updateGuestsNotification();
			}
			if(pageName == PagesENUM.PRESENTATION){
				updatePresentationNotification();
			}
			if(pageName == PagesENUM.CHATROOMS){
				(view.menuChatButton.skin as NavigationButtonSkin).notification.visible  = false;
			}
		}
		
		private function updateGuestsNotification():void {
			var numberOfGuests:int = userSession.guestList.guests.length;
			if(numberOfGuests > 0 && userSession.userList.me.role == User.MODERATOR && userUISession.currentPage != PagesENUM.PARTICIPANTS){
				(view.menuParticipantsButton.skin as NavigationButtonSkin).notification.visible  = true;
			}
			else {
				(view.menuParticipantsButton.skin as NavigationButtonSkin).notification.visible  = false;
			}
		}
		
		private function addGuest(guest:Object):void{
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