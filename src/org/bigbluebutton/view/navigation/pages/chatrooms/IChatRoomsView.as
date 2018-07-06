package org.bigbluebutton.view.navigation.pages.chatrooms {
	
	import spark.components.List;
	
	import org.bigbluebutton.core.view.IView;
	
	public interface IChatRoomsView extends IView {
		function get list():List;
	}
}
