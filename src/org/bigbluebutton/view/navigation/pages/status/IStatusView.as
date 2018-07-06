package org.bigbluebutton.view.navigation.pages.status {
	
	import spark.components.List;
	
	import org.bigbluebutton.core.view.IView;
	
	public interface IStatusView extends IView {
		function get moodList():List;
	}
}
