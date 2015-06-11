package org.bigbluebutton.view.navigation.pages.profile {
	
	import flash.events.MouseEvent;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	
	public class ProfileView extends ProfileViewBase implements IProfileView {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function dispose():void {
		}
		
		public function get userNameButton():Button {
			return userName0;
		}
		
		public function get userStatusButton():Button {
			return userStatus0;
		}
		
		public function get clearStatusButton():Button {
			return clearStatusButton0;
		}
		
		public function get shareCameraButton():Button {
			return shareCameraBtn0;
		}
		
		public function get shareCameraBtnLabel():String {
			return shareCameraBtn0.label;
		}
		
		public function get shareMicButton():Button {
			return shareMicBtn0;
		}
		
		public function get statusButton():Button {
			return statusBtn0;
		}
		
		public function get shareMicBtnLabel():String {
			return shareMicBtn0.label;
		}
		
		public function get logoutButton():Button {
			return logoutButton0;
		}
		
		public function get handButton():Button {
			return handBtn0;
		}
	}
}
