package org.bigbluebutton.view.navigation.pages.camerasettings
{
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	import flash.media.Video;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.IndexChangedEvent;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	
	import org.bigbluebutton.command.CameraQualitySignal;
	import org.bigbluebutton.command.ShareCameraSignal;
	import org.bigbluebutton.core.VideoConnection;
	import org.bigbluebutton.core.VideoProfile;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.view.ui.SwapCameraButton;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;

	public class CameraSettingsViewMediator extends Mediator
	{
		[Inject]
		public var view: ICameraSettingsView;
		
		[Inject]
		public var userSession: IUserSession;
		
		[Inject]
		public var userUISession: IUserUISession;
		
		[Inject]
		public var shareCameraSignal: ShareCameraSignal;			
		
		[Inject]
		public var changeQualitySignal : CameraQualitySignal;
		
		protected var dataProvider:ArrayCollection;
	
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
			
			dataProvider = new ArrayCollection();
			view.cameraProfilesList.dataProvider = dataProvider;
			displayCameraProfiles();
			
			userSession.userList.userChangeSignal.add(userChangeHandler);
			var userMe:User = userSession.userList.me;
						
			if (Camera.getCamera() == null)
			{
				view.startCameraButton.label = ResourceManager.getInstance().getString('resources', 'profile.settings.camera.unavailable');
				view.startCameraButton.enabled = false;
			}
			else
			{
				view.startCameraButton.label  = ResourceManager.getInstance().getString('resources', userMe.hasStream? 'profile.settings.camera.on':'profile.settings.camera.off');
				view.startCameraButton.enabled = true;
			}
			if(Camera.names.length <= 1 )
			{
				setSwapCameraButtonEnable(false);
			}
			else
			{
				view.swapCameraButton.addEventListener(MouseEvent.CLICK, mouseClickHandler);
				userSession.userList.userChangeSignal.add(userChangeHandler);
			}
			view.startCameraButton.addEventListener(MouseEvent.CLICK, onShareCameraClick);
			view.cameraProfilesList.addEventListener(IndexChangeEvent.CHANGE, onCameraQualitySelected);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'cameraSettings.title');
			displayPreviewCamera();
		}
		
		private function displayCameraProfiles():void{
			var videoProfiles : Array = userSession.videoProfileManager.profiles;
			for each (var profile:VideoProfile in videoProfiles){
				dataProvider.addItem(profile);
			}
			dataProvider.refresh();
			view.cameraProfilesList.selectedIndex = dataProvider.getItemIndex(userSession.videoConnection.selectedCameraQuality);
		}
		
		private function userChangeHandler(user:User, type:int):void
		{
			if (user.me) {
				if (type == UserList.HAS_STREAM) {
					view.startCameraButton.label  = ResourceManager.getInstance().getString('resources', user.hasStream ? 'profile.settings.camera.on' : 'profile.settings.camera.off');
					if(Camera.names.length > 1)
					{
						setSwapCameraButtonEnable(true)
					}
				}
			}
		}
		
		protected function onShareCameraClick(event:MouseEvent):void
		{
			view.cameraProfilesList.selectedIndex = dataProvider.getItemIndex(userSession.videoConnection.selectedCameraQuality);
			shareCameraSignal.dispatch(!userSession.userList.me.hasStream, userSession.videoConnection.cameraPosition);
			displayPreviewCamera();
			if(userSession.videoAutoStart){
				userSession.videoAutoStart = false;
				userUISession.popPage();
			}
		}
		
		protected function setSwapCameraButtonEnable(enabled:Boolean):void
		{
			view.swapCameraButton.enabled = enabled;
		}
		
		protected function onCameraQualitySelected(event:IndexChangeEvent):void
		{
			if (event.newIndex >= 0) {
				var profile:VideoProfile = dataProvider.getItemAt(event.newIndex) as VideoProfile;
				if(userSession.userList.me.hasStream){
					changeQualitySignal.dispatch(profile);
				}
				else {
					userSession.videoConnection.selectedCameraQuality = profile;
				}
				displayPreviewCamera();
			}
		}
		
		private function displayPreviewCamera():void{
			var profile:VideoProfile = userSession.videoConnection.selectedCameraQuality
			var camera:Camera = getCamera(userSession.videoConnection.cameraPosition);
			if (camera) {
				camera.setMode(profile.width, profile.height, profile.modeFps);
				var camAspectRatio:Number = FlexGlobals.topLevelApplication.width/view.cameraSettingsScroller.height;
				var camWidth:Number;
				var camHeight:Number;
				if (camAspectRatio > 1){
					camHeight = view.cameraSettingsScroller.height;
					camWidth =  profile.width * view.cameraSettingsScroller.height/profile.height;
				}
				else {
					camWidth = FlexGlobals.topLevelApplication.width;
					camHeight = profile.height * FlexGlobals.topLevelApplication.width/profile.width;
				}
				var myCam:Video = new Video(camWidth, camHeight);
				myCam.attachCamera(camera);
				view.previewVideo.removeChildren();
				view.previewVideo.addChild(myCam);
				view.settingsGroup.y = myCam.height;
				myCam.x = (FlexGlobals.topLevelApplication.width - myCam.width)/2;
				
			} else {
				view.noVideoMessage.visible = true;
			}
		}
		
		private function getCamera(position:String):Camera
		{
			for (var i:uint = 0; i < Camera.names.length; ++i)
			{
				var cam:Camera = Camera.getCamera(String(i));
				if (cam.position == position) 
					return cam;
			}
			return Camera.getCamera();
		}
		
		/**
		 * Raised on button click, will send signal to swap camera source  
		 **/
		//close old stream on swap
		private function mouseClickHandler(e:MouseEvent):void
		{
			if(!userSession.userList.me.hasStream){
				if (String(userSession.videoConnection.cameraPosition) == CameraPosition.FRONT)
				{
					userSession.videoConnection.cameraPosition = CameraPosition.BACK;
				}
				else
				{
					userSession.videoConnection.cameraPosition = CameraPosition.FRONT;
				}
			}
			else {
				if (String(userSession.videoConnection.cameraPosition) == CameraPosition.FRONT)
				{
					shareCameraSignal.dispatch(!userSession.userList.me.hasStream, CameraPosition.FRONT);
					shareCameraSignal.dispatch(userSession.userList.me.hasStream, CameraPosition.BACK);
				}
				else
				{
					shareCameraSignal.dispatch(!userSession.userList.me.hasStream, CameraPosition.BACK);
					shareCameraSignal.dispatch(userSession.userList.me.hasStream, CameraPosition.FRONT);
				}
			}
			displayPreviewCamera();
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			userSession.userList.userChangeSignal.remove(userChangeHandler);		
			view.startCameraButton.removeEventListener(MouseEvent.CLICK, onShareCameraClick);
			if(Camera.names.length > 1)
			{
				view.swapCameraButton.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			}
			view.cameraProfilesList.removeEventListener(ItemClickEvent.ITEM_CLICK, onCameraQualitySelected);			
			view.dispose();
			view = null;
			userSession.videoAutoStart = false;
		}
	}
}