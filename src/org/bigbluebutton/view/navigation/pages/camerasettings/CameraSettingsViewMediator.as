package org.bigbluebutton.view.navigation.pages.camerasettings
{
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	
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
				if(!userMe.hasStream)
				{
					setSwapCameraButtonEnable(false);
				}
				view.swapCameraButton.addEventListener(MouseEvent.CLICK, mouseClickHandler);
				userSession.userList.userChangeSignal.add(userChangeHandler);
			}
			view.startCameraButton.addEventListener(MouseEvent.CLICK, onShareCameraClick);
			view.cameraProfilesList.addEventListener(IndexChangeEvent.CHANGE, onCameraQualitySelected);
			setCameraProfilesEnable(userMe.hasStream);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'cameraSettings.title');
		}
		
		private function displayCameraProfiles(){
			var videoProfiles : Array = userSession.videoProfileManager.profiles;
			for each (var profile:VideoProfile in videoProfiles){
				trace("prof:: " + profile);
				dataProvider.addItem(profile);
			}
			dataProvider.refresh();
			
			if(userSession.videoConnection.selectedCameraQuality != VideoConnection.CAMERA_QUALITY_NOT_SET){
				view.cameraProfilesList.selectedIndex = userSession.videoConnection.selectedCameraQuality;
			}
		}
		
		private function userChangeHandler(user:User, type:int):void
		{
			if (user.me) {
				if (type == UserList.HAS_STREAM) {
					view.startCameraButton.label  = ResourceManager.getInstance().getString('resources', user.hasStream ? 'profile.settings.camera.on' : 'profile.settings.camera.off');
					setCameraProfilesEnable(user.hasStream);
					if(Camera.names.length > 1)
					{
						setSwapCameraButtonEnable(user.hasStream)
					}
				}
			}
		}
		
		protected function onShareCameraClick(event:MouseEvent):void
		{
			if(userSession.videoConnection.selectedCameraQuality != VideoConnection.CAMERA_QUALITY_NOT_SET){
				view.cameraProfilesList.selectedIndex = userSession.videoConnection.selectedCameraQuality;
			}
			else {
				userSession.videoConnection.selectedCameraQuality = VideoConnection.CAMERA_QUALITY_MEDIUM;
				view.cameraProfilesList.selectedIndex = VideoConnection.CAMERA_QUALITY_MEDIUM;
			}
			shareCameraSignal.dispatch(!userSession.userList.me.hasStream, CameraPosition.FRONT);
		}
		
		protected function setCameraProfilesEnable(enabled:Boolean):void
		{
			view.cameraProfilesList.enabled=enabled;
		}
		
		protected function setSwapCameraButtonEnable(enabled:Boolean):void
		{
			view.swapCameraButton.enabled = enabled;
		}
		
		protected function onCameraQualitySelected(event:IndexChangeEvent):void
		{
			if (event.newIndex >= 0) {
				var profile:VideoProfile = dataProvider.getItemAt(event.newIndex) as VideoProfile;
				switch(profile.id){
					case "low":
						changeQualitySignal.dispatch(VideoConnection.CAMERA_QUALITY_LOW);
						break;
					case "medium":
						changeQualitySignal.dispatch(VideoConnection.CAMERA_QUALITY_MEDIUM);
						break;
					case "high":
						changeQualitySignal.dispatch(VideoConnection.CAMERA_QUALITY_HIGH);
						break;
					default:
						changeQualitySignal.dispatch(VideoConnection.CAMERA_QUALITY_MEDIUM);
				}
			}
		}
		
		/**
		 * Raised on button click, will send signal to swap camera source  
		 **/
		//close old stream on swap
		private function mouseClickHandler(e:MouseEvent):void
		{
			if (String(userSession.videoConnection.cameraPosition) == CameraPosition.FRONT)
			{
				shareCameraSignal.dispatch(!userSession.userList.me.hasStream, CameraPosition.FRONT);
				shareCameraSignal.dispatch(userSession.userList.me.hasStream, CameraPosition.BACK);
			}
			else if (String(userSession.videoConnection.cameraPosition) == CameraPosition.BACK)
			{
				shareCameraSignal.dispatch(!userSession.userList.me.hasStream, CameraPosition.BACK);
				shareCameraSignal.dispatch(userSession.userList.me.hasStream, CameraPosition.FRONT);
			}
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
		}
	}
}