package org.robotlegs.test.support
{
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.AsyncSignalCommand;

	public class TestFailAsyncCommand extends AsyncSignalCommand
	{
		public function TestFailAsyncCommand()
		{
		}
		
		override public function execute():void
		{
			setTimeout(timeoutHandler, 100);
		}
		
		protected function timeoutHandler():void
		{
			dispatchFail("Error");
		}
	}
}