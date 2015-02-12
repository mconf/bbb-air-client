package org.bigbluebutton.view.navigation.pages.profile
{
	
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	
	import org.bigbluebutton.command.RaiseHandCommand;
	import org.bigbluebutton.command.RaiseHandSignal;
	
	import org.bigbluebutton.command.MoodCommand;
	import org.bigbluebutton.command.MoodSignal;


	public class ProfileConfig implements IConfig
	{
		[Inject]
		public var injector: IInjector;
		
		[Inject]
		public var mediatorMap: IMediatorMap;
		
		[Inject]
		public var signalCommandMap: ISignalCommandMap;
		
		public function configure(): void
		{
			dependencies();
			mediators();
			signals();
		}
		
		/**
		 * Specifies all the dependencies for the feature
		 * that will be injected onto objects used by the
		 * application.
		 */
		private function dependencies(): void
		{
			 
		}
		
		/**
		 * Maps view mediators to views.
		 */
		private function mediators(): void
		{
			mediatorMap.map(IProfileView).toMediator(ProfileViewMediator);
		}
		
		/**
		 * Maps signals to commands using the signalCommandMap.
		 */
		private function signals(): void
		{
			signalCommandMap.map(RaiseHandSignal).toCommand(RaiseHandCommand);  
			signalCommandMap.map(MoodSignal).toCommand(MoodCommand);
			//signalCommandMap.map(ButtonTestSignal).toCommand(ButtonTestCommand);
		}	
	}
}