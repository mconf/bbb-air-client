package org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms {
	
	import spark.components.List;
	
	import org.bigbluebutton.core.view.IView;
	
	public interface IRecentRoomsView extends IView {
		function get roomsList():List;
	}
}
