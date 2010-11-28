package org.robotlegs.test.support
{
	import org.robotlegs.mvcs.SignalCommand;
	
	public class TestValueClassPayloadCommand extends SignalCommand
	{
		[Inject]
		public var signalBus:SignalBusTestClass;
		
		[Inject]
		public var property:TestCommandProperty;
		
		public function TestValueClassPayloadCommand()
		{
		}
		
		override public function execute():void
		{
			signalBus.commandCompleted.dispatch(this);
		}
	}
}