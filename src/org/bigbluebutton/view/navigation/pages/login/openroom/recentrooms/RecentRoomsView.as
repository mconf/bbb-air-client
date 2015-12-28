package org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms {
	
	import spark.components.List;
	import org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms.IRecentRoomsView;
	
	public class RecentRoomsView extends RecentRoomsViewBase implements IRecentRoomsView {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function dispose():void {
		}
		
		public function get roomsList():List {
			return roomsList0;
		}
	}
}
