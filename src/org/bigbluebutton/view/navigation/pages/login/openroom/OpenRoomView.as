package org.bigbluebutton.view.navigation.pages.login.openroom {
	
	import org.bigbluebutton.view.navigation.pages.login.openroom.OpenRoomViewBase;
	import org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms.IRecentRoomsView;
	import org.bigbluebutton.view.ui.NavigationButton;
	import spark.components.Button;
	import spark.components.List;
	import spark.components.TextInput;
	
	public class OpenRoomView extends OpenRoomViewBase implements IOpenRoomView {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function get inputRoom():TextInput {
			return inputRoom0;
		}
		
		public function get goButton():Button {
			return goButton0;
		}
		
		public function dispose():void {
		}
	}
}
