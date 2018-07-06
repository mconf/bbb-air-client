package org.bigbluebutton.view.navigation {
	
	import spark.transitions.ViewTransitionBase;
	
	import org.bigbluebutton.core.view.IView;
	
	public interface IPagesNavigatorView extends IView {
		function pushView(viewClass:Class,
						  data:Object = null,
						  context:Object = null,
						  transition:ViewTransitionBase = null):void
		function popView(transition:ViewTransitionBase = null):void
		function set visible(value:Boolean):void
		function set includeInLayout(value:Boolean):void
		function popAll(transition:ViewTransitionBase = null):void
	}
}
