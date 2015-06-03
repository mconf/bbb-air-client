package org.bigbluebutton.view.navigation.pages.exit {
	
	import spark.components.Button;
	
	public interface IExitPageView {
		function get currentState():String
		function set currentState(value:String):void
		function get yesButton():Button
		function get noButton():Button
	}
}
