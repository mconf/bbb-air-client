package org.bigbluebutton.view.navigation.pages.login.rooms {
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.describeType;
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	import org.bigbluebutton.core.ISaveData;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import spark.events.IndexChangeEvent;
	
	public class RoomsViewMediator extends Mediator {
		
		[Inject]
		public var view:IRoomsView;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		[Inject]
		public var saveData:ISaveData;
		
		protected var dataProvider:ArrayCollection;
		
		override public function initialize():void {
			dataProvider = new ArrayCollection((saveData.read("rooms") as ArrayCollection).toArray().reverse());
			view.roomsList.dataProvider = dataProvider;
			view.roomsList.addEventListener(MouseEvent.CLICK, selectRoom);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'profile.rooms');
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'rooms.title');
			FlexGlobals.topLevelApplication.topActionBar.visible = true;
			FlexGlobals.topLevelApplication.bottomMenu.includeInLayout = false;
		}
		
		protected function selectRoom(event:MouseEvent):void {
			trace("trying to select a room");
			trace(dataProvider[view.roomsList.selectedIndex].url);
			if (dataProvider[view.roomsList.selectedIndex].url) {
				var urlReq = new URLRequest(dataProvider[view.roomsList.selectedIndex].url);
				navigateToURL(urlReq);
			}
		}
		
		override public function destroy():void {
			super.destroy();
			view.roomsList.removeEventListener(IndexChangeEvent.CHANGE, selectRoom);
			view.dispose();
			view = null;
		}
	}
}
