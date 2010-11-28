package org.robotlegs.test.support
{
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.AsyncSignalCommand;
	
	public class TestCompleteAsyncCommand extends AsyncSignalCommand
	{
		public function TestCompleteAsyncCommand()
		{
		}
		
		override public function execute():void
		{
			setTimeout(dispatchComplete, 100);
		}
	}
}