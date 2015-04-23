package org.bigbluebutton.view.navigation.pages.participants
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.CollectionEvent;
	import mx.resources.ResourceManager;

	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.Guest;
	import org.bigbluebutton.model.GuestList;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.TransitionAnimationENUM;
	import org.bigbluebutton.view.navigation.pages.participants.guests.GuestResponseEvent;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import spark.components.Button;
	import spark.events.IndexChangeEvent;
	
	public class ParticipantsViewMediator extends Mediator
	{
		[Inject]
		public var view: IParticipantsView;
		
		[Inject]
		public var userSession: IUserSession
		
		[Inject]
		public var userUISession: IUserUISession
		
		[Inject]
		public var usersService: IUsersService;

		
		protected var dataProvider:ArrayCollection;
		protected var dataProviderGuests:ArrayCollection;
		protected var dicUserIdtoUser:Dictionary;
		protected var dicUserIdtoGuest:Dictionary
		protected var usersSignal:ISignal; 
		
		private var _userMe:User;
		
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
			dataProvider = new ArrayCollection();
			
			view.list.dataProvider = dataProvider;
			view.list.addEventListener(IndexChangeEvent.CHANGE, onSelectParticipant);
			
			dicUserIdtoUser = new Dictionary();
			
			var users:ArrayCollection = userSession.userList.users;
			for each (var user:User in users)
			{
				addUser(user);
				if (user.me){
					_userMe = user;
				}
			}
			
			userSession.userList.userChangeSignal.add(userChanged);
			userSession.userList.userAddedSignal.add(addUser);
			userSession.userList.userRemovedSignal.add(userRemoved);
			
			setPageTitle();
			FlexGlobals.topLevelApplication.profileBtn.visible = true;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			
			
			dataProviderGuests = new ArrayCollection();
			view.guestsList.dataProvider = dataProviderGuests;
			
			view.guestsList.addEventListener(GuestResponseEvent.GUEST_RESPONSE, onSelectGuest);
			view.allowAllButton.addEventListener(MouseEvent.CLICK, allowAllGuests);
			view.denyAllButton.addEventListener(MouseEvent.CLICK, denyAllGuests);
			
			dicUserIdtoGuest = new Dictionary();
			
			var guests:ArrayCollection = userSession.guestList.guests;
			for each (var guest:Guest in guests)
			{
				addGuest(guest);
			}
			
			userSession.guestList.guestAddedSignal.add(addGuest);
			userSession.guestList.guestRemovedSignal.add(guestRemoved);
			
			if (_userMe.role == User.MODERATOR && dataProviderGuests.length > 0){
					view.guestsList.visible = true;
					view.guestsList.includeInLayout = true;
					view.allGuests.visible = true;
					view.allGuests.includeInLayout = true;
			}
		}
		
		private function addUser(user:User):void
		{
			dataProvider.addItem(user);
			dataProvider.refresh();
			dicUserIdtoUser[user.userID] = user;
			setPageTitle();
		}
		
		private function addGuest(guest:Object):void
		{
			dataProviderGuests.addItem(guest);
			dataProviderGuests.refresh();
			dicUserIdtoGuest[guest.userID] = guest;
			
			if(_userMe.role == User.MODERATOR && dataProviderGuests.length > 0){
				view.guestsList.visible = true;
				view.guestsList.includeInLayout = true;
				view.allGuests.visible = true;
				view.allGuests.includeInLayout = true;
			}
		}
		
		private function userRemoved(userID:String):void
		{
			var user:User = dicUserIdtoUser[userID] as User;
			var index:uint = dataProvider.getItemIndex(user);
			dataProvider.removeItemAt(index);
			dicUserIdtoUser[user.userID] = null;
			setPageTitle();
		}
		
		private function guestRemoved(userID:String):void
		{
			var guest:Guest = dicUserIdtoGuest[userID] as Guest;
			if(guest){
				var index:uint = dataProviderGuests.getItemIndex(guest);
				dataProviderGuests.removeItemAt(index);
				dicUserIdtoGuest[guest.userID] = null;
				if(_userMe.role == User.MODERATOR && dataProviderGuests.length == 0 && view && view.guestsList != null){
					
					view.guestsList.includeInLayout = false;
					view.guestsList.visible = false;
					view.allGuests.includeInLayout = false;
					view.allGuests.visible = false;
				}
			}

		}
		
		private function userChanged(user:User, property:String = null):void
		{
			dataProvider.refresh();
			
			if (_userMe.role == User.MODERATOR && dataProviderGuests.length > 0){
				view.guestsList.visible = true;
				view.guestsList.includeInLayout = true;
				view.allGuests.visible = true;
				view.allGuests.includeInLayout = true;
			}
			else{
				view.guestsList.visible = false;
				view.guestsList.includeInLayout = false;
				view.allGuests.visible = false;
				view.allGuests.includeInLayout = false;
			}
		}
		
		protected function onSelectParticipant(event:IndexChangeEvent):void
		{
			if (event.newIndex >= 0) {
				var user:User = dataProvider.getItemAt(event.newIndex) as User;
				userUISession.pushPage(PagesENUM.USER_DETAIS, user, TransitionAnimationENUM.SLIDE_LEFT);
			}
		}
		
		protected function onSelectGuest(event:GuestResponseEvent):void
		{
			usersService.responseToGuest(event.guestID, event.allow);
		}
		
		protected function allowAllGuests(event:MouseEvent):void
		{
			usersService.responseToAllGuests(true);
		}
		
		protected function denyAllGuests(event:MouseEvent):void
		{
			usersService.responseToAllGuests(false);
		}
		
		/**
		 * Count participants and set page title accordingly
		 **/
		private function setPageTitle():void
		{
			if(dataProvider != null)
			{
				FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'participants.title') + " (" + dataProvider.length + ")";
			}
		}
			
		override public function destroy():void
		{
			super.destroy();
			
			view.dispose();
			view = null;
			
			userSession.userList.userChangeSignal.remove(userChanged);
			userSession.userList.userAddedSignal.remove(addUser);
			userSession.userList.userRemovedSignal.remove(userRemoved);
			
			userSession.guestList.guestAddedSignal.remove(addGuest);
		}
	}
}