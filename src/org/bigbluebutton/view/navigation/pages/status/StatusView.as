package org.bigbluebutton.view.navigation.pages.status {
	
	import spark.components.List;
	
	public class StatusView extends StatusViewBase implements IStatusView {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function dispose():void {
		}
		
		public function get moodList():List {
			return moodList0;
		}
	}
}
