package org.robotlegs.mvcs
{
	import flash.display.Sprite;
	
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.utils.failOnSignal;
	import org.osflash.signals.utils.proceedOnSignal;
	import org.robotlegs.core.ISignalCommand;
	import org.robotlegs.test.support.SignalContextWithAccessibleInjector;
	import org.robotlegs.test.support.TestCompleteAsyncCommand;
	import org.robotlegs.test.support.TestCompleteAsyncNoReferenceCommand;
	import org.robotlegs.test.support.TestFailAsyncCommand;
	import org.robotlegs.test.support.TestNotDetainedAsyncCommand;

	public class AsyncSignalCommandTests
	{		
		protected var context:SignalContextWithAccessibleInjector;
		
		protected var command:AsyncSignalCommand;
		
		[Before]
		public function setUp():void
		{
			context = new SignalContextWithAccessibleInjector(new Sprite());
		}
		
		[After]
		public function tearDown():void
		{
			context = null;
			command = null;
		}
		
		[Test]
		public function command_is_signal_command():void
		{
			command = new AsyncSignalCommand();
			
			assertTrue(command is ISignalCommand);
		}
		
		[Test(async)]
		public function command_dispatches_completed_when_it_completes():void
		{
			command = context.getInjector().instantiate(TestCompleteAsyncCommand);

			proceedOnSignal(this, command.completed);
			
			command.execute();
		}
		
		[Test(async)]
		public function command_is_garbage_collected_when_not_detained():void
		{
			var command:TestNotDetainedAsyncCommand = context.getInjector().instantiate(TestNotDetainedAsyncCommand);
			
			failOnSignal(this, command.signalBus.commandCompleted);
			
			command.execute();
		}
		
		[Test(async)]
		public function command_dispatches_completed_when_it_completes_without_references():void
		{
			var command:TestCompleteAsyncNoReferenceCommand = context.getInjector().instantiate(TestCompleteAsyncNoReferenceCommand);
			
			proceedOnSignal(this, command.signalBus.commandCompleted);
			
			command.execute();
		}
		
		[Test(async)]
		public function command_dispatches_failed_when_it_fails():void
		{
			command = context.getInjector().instantiate(TestFailAsyncCommand);
			
			proceedOnSignal(this, command.failed);
			
			command.execute();
		}
	}
}