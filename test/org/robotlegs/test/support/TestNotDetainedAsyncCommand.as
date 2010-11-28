package org.robotlegs.test.support
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.robotlegs.core.ISignalCommandMap;
	import org.robotlegs.mvcs.AsyncSignalCommand;
	
	public class TestNotDetainedAsyncCommand extends AsyncSignalCommand
	{
		public var signalBus:SignalBusTestClass;
		
		protected var timer:Timer;
		
		public function TestNotDetainedAsyncCommand()
		{
			signalBus = new SignalBusTestClass();
			timer = new Timer(100, 1);
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false, 0, true);
		}
		
		[Inject]
		override public function set signalCommandMap(value:ISignalCommandMap):void
		{
			// remove detain code for the purpose of the test
			_signalCommandMap = value;
		}
		
		override public function execute():void
		{
			timer.start();
		}
		
		override protected function dispatchComplete():void
		{
			super.dispatchComplete();
			
			signalBus.commandCompleted.dispatch(this);
		}
		
		protected function timerCompleteHandler(event:TimerEvent):void
		{
			dispatchComplete();
		}
	}
}