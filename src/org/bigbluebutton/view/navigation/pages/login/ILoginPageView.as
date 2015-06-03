package org.bigbluebutton.view.navigation.pages.login {
	
	import org.bigbluebutton.core.view.IView;
	import spark.components.Button;
	import spark.components.Label;
	
	public interface ILoginPageView extends IView {
		function get currentState():String
		function set currentState(value:String):void
		function get messageText():Label
		function get tryAgainButton():Button
	}
}
