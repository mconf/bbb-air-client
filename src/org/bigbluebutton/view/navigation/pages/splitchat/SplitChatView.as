package org.bigbluebutton.view.navigation.pages.splitchat {
	
	import spark.components.ViewNavigator;
	
	public class SplitChatView extends SplitChatViewBase implements ISplitChatView {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function dispose():void {
		}
		
		public function get participantsList():ViewNavigator {
			return participantslist0;
		}
		
		public function get participantDetails():ViewNavigator {
			return participantdetails0;
		}
	}
}
