package org.bigbluebutton.view.navigation.pages.splitparticipants {
	
	import spark.components.ViewNavigator;
	
	import org.bigbluebutton.core.view.IView;
	
	public interface ISplitParticipantsView extends IView {
		function get participantDetails():ViewNavigator;
		function get participantsList():ViewNavigator;
	}
}
