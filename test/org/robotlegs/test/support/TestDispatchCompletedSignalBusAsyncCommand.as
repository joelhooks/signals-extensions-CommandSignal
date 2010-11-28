package org.robotlegs.test.support
{
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.AsyncSignalCommand;
	
	public class TestDispatchCompletedSignalBusAsyncCommand extends AsyncSignalCommand
	{
		[Inject]
		public var signalBus:SignalBusTestClass;
		
		public var hasExecuted:Boolean;
		
		public function TestDispatchCompletedSignalBusAsyncCommand()
		{
		}
		
		override public function execute():void
		{
			hasExecuted = true;
			
			setTimeout(dispatchComplete, 100);
		}
		
		override protected function dispatchComplete():void
		{
			signalBus.commandCompleted.dispatch(this);

			super.dispatchComplete();
		}
	}
}