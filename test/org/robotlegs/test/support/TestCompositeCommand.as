package org.robotlegs.test.support
{
	import org.robotlegs.mvcs.CompositeSignalCommand;
	
	public class TestCompositeCommand extends CompositeSignalCommand
	{
		public function TestCompositeCommand()
		{
		}
		
		override public function execute():void
		{
			addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			
			super.execute();
		}
	}
}