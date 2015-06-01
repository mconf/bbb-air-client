package org.bigbluebutton.view.navigation.pages.login.rooms {
	
	import flash.events.MouseEvent;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	
	public class RoomsView extends RoomsViewBase implements IRoomsView {
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
