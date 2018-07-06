package org.bigbluebutton.view.navigation.pages.splitchat {
	
	import spark.components.ViewNavigator;
	
	import org.bigbluebutton.core.view.IView;
	
	public interface ISplitChatView extends IView {
		function get participantDetails():ViewNavigator;
		function get participantsList():ViewNavigator;
	}
}
