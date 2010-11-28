package org.robotlegs.test.support
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.AsyncSignalCommand;
	
	public class TestCompleteAsyncNoReferenceCommand extends AsyncSignalCommand
	{
		public var signalBus:SignalBusTestClass;
		
		protected var timer:Timer;
		
		public function TestCompleteAsyncNoReferenceCommand()
		{
			signalBus = new SignalBusTestClass();
			timer = new Timer(100, 1);
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false, 0, true);
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