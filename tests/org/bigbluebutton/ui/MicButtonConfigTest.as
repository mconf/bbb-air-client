package org.bigbluebutton.ui {
	
	import org.bigbluebutton.view.ui.micbutton.MicButtonConfig;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.notNullValue;
	import robotlegs.bender.framework.api.IConfig;
	
	public class MicButtonConfigTest {
		
		/**
		 * Tests that the TodoFormConfig class implements IConfig.
		 */
		[Test]
		public function implements_expectedInterface():void {
			assertThat(new MicButtonConfig() as IConfig, notNullValue());
		}
	}
}
