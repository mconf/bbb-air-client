package org.bigbluebutton.core.ui.api {
	
	import org.bigbluebutton.core.view.IView;
	
	public interface IPopup {
		function add(view:IView):void;
		function remove(view:IView):void;
	}
}
