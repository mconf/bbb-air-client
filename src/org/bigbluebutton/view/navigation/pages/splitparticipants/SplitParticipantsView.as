package org.bigbluebutton.view.navigation.pages.splitparticipants {
	
	import spark.components.ViewNavigator;
	
	public class SplitParticipantsView extends SplitParticipantsViewBase implements ISplitParticipantsView {
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
