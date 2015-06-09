package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.LoadSlideService;
	import org.bigbluebutton.model.presentation.Slide;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;
	import org.mockito.integrations.verify;
	
	public class LoadSlideCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var loadSlideCommand:LoadSlideCommand;
		
		[Mock(type = "org.bigbluebutton.model.presentation.Slide", argsList = "constructorArgs")]
		public var slide:Slide;
		
		public var constructorArgs:Array = [null, null, null, null, null];
		
		[Before]
		public function setUp():void {
			loadSlideCommand = new LoadSlideCommand();
		}
		
		[Test]
		public function execute():void {
			loadSlideCommand.slide = slide;
			loadSlideCommand.execute();
		}
	}
}
