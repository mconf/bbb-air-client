package org.bigbluebutton.view.navigation.pages.exit {
	
	import spark.components.Button;
	import org.bigbluebutton.view.navigation.pages.exit.ExitPageViewBase;
	import org.bigbluebutton.view.navigation.pages.exit.IExitPageView;
	
	public class ExitPageView extends ExitPageViewBase implements IExitPageView {
		public function get yesButton():Button {
			return yesButton0;
		}
		
		public function get noButton():Button {
			return noButton0;
		}
	}
}
