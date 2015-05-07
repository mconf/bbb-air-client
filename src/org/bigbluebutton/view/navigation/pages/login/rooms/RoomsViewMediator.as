package org.bigbluebutton.view.navigation.pages.login.rooms
{
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
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	public class RoomsViewMediator extends Mediator
	{
		[Inject]
		public var view: IRoomsView;
		
		[Inject]
		public var userSession: IUserSession;
		
		[Inject]
		public var userUISession: IUserUISession;
		
		[Inject]
		public var saveData:ISaveData;
		
		protected var dataProvider:ArrayCollection;
		
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
			dataProvider = new ArrayCollection((saveData.read("rooms") as ArrayCollection).toArray().reverse());
			view.roomsList.dataProvider = dataProvider;
			view.roomsList.addEventListener(IndexChangeEvent.CHANGE, selectRoom);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'profile.rooms');
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'rooms.title');
			FlexGlobals.topLevelApplication.topActionBar.visible=true;
		}
		
		protected function selectRoom(event:IndexChangeEvent):void
		{			
			var urlReq = new URLRequest(dataProvider[event.newIndex].url); 
			navigateToURL(urlReq);
			NativeApplication.nativeApplication.exit();
		}
		
		override public function destroy():void
		{
			super.destroy();			
			view.roomsList.removeEventListener(IndexChangeEvent.CHANGE, selectRoom);
			view.dispose();
			view = null;
		}
	}
}

