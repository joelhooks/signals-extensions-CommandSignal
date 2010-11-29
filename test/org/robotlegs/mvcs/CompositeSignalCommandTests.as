package org.robotlegs.mvcs
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mockolate.mock;
	import mockolate.prepare;
	import mockolate.strict;
	import mockolate.verify;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utils.handleSignal;
	import org.osflash.signals.utils.proceedOnSignal;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.base.SignalCommandMap;
	import org.robotlegs.core.ICompositeSignalCommand;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.core.ISignalCommand;
	import org.robotlegs.core.ISignalCommandMap;
	import org.robotlegs.test.support.SignalBusTestClass;
	import org.robotlegs.test.support.SignalContextWithAccessibleInjector;
	import org.robotlegs.test.support.TestCommandProperty;
	import org.robotlegs.test.support.TestCompleteAsyncCommand;
	import org.robotlegs.test.support.TestCompleteSyncCommand;
	import org.robotlegs.test.support.TestCompositeCommand;
	import org.robotlegs.test.support.TestDispatchCompletedSignalBusAsyncCommand;
	import org.robotlegs.test.support.TestDispatchCompletedSignalBusSyncCommand;
	import org.robotlegs.test.support.TestFailAsyncCommand;
	import org.robotlegs.test.support.TestPayloadCommand;
	import org.robotlegs.test.support.TestPayloadCompositeCommand;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.Reflector;

	public class CompositeSignalCommandTests
	{		
		protected var context:SignalContextWithAccessibleInjector;
		
		protected var command:CompositeSignalCommand;
		
		protected var signalBus:SignalBusTestClass;
		
		[Before(async, timeout=5000)]
		public function setUp():void
		{
			context = new SignalContextWithAccessibleInjector(new Sprite());
			signalBus = new SignalBusTestClass();
			
			context.getInjector().mapValue(SignalBusTestClass, signalBus);
			
			Async.proceedOnEvent(this,
				prepare(Signal),
				Event.COMPLETE);
		}
		
		[After]
		public function tearDown():void
		{
			context = null;
			command = null;
			signalBus = null;
		}
		
		protected function createCompositeCommandInstance(commandClass:Class):CompositeSignalCommand
		{
			var command:CompositeSignalCommand = new commandClass();
			
			command.injector = new SwiftSuspendersInjector()
			command.reflector = new SwiftSuspendersReflector();
			command.signalCommandMap = new SignalCommandMap(command.injector);
			
			command.injector.mapValue(IInjector, command.injector);
			command.injector.mapValue(IReflector, command.reflector);
			command.injector.mapValue(ISignalCommandMap, command.signalCommandMap);
			command.injector.mapValue(SignalBusTestClass, signalBus);
			
			return command;
		}
		
		[Test]
		public function command_is_composite_signal_command():void
		{
			command = new CompositeSignalCommand();

			assertTrue(command is ICompositeSignalCommand);
		}
		
		[Test]
		public function numCommmands_matches_number_of_added_child_commands():void
		{
			command = createCompositeCommandInstance(CompositeSignalCommand);
			
			command.addCommand(TestCompleteSyncCommand);
			command.addCommand(TestCompleteSyncCommand);
			
			assertEquals(2, command.numCommands);
		}
		
		[Test(expects="ArgumentError")]
		public function command_throws_error_when_adding_a_non_signal_command():void
		{
			command = createCompositeCommandInstance(CompositeSignalCommand);
			
			command.addCommand(Command);
		}
		
		[Test(expects="Error")]
		public function command_with_no_child_commands_throws_error():void
		{
			command = new CompositeSignalCommand();
			
			command.execute();
		}
		
		[Test(async)]
		public function command_dispatches_completed_when_all_sync_commands_complete():void
		{
			command = createCompositeCommandInstance(CompositeSignalCommand);
			
			command.addCommand(TestCompleteSyncCommand);
			command.addCommand(TestCompleteSyncCommand);
			command.addCommand(TestCompleteSyncCommand);
			
			proceedOnSignal(this, command.completed);
			
			command.execute();
		}
		
		[Test(async)]
		public function command_dispatches_completed_when_all_async_commands_complete():void
		{
			command = createCompositeCommandInstance(CompositeSignalCommand);

			command.addCommand(TestCompleteAsyncCommand);
			command.addCommand(TestCompleteAsyncCommand);
			command.addCommand(TestCompleteAsyncCommand);
			
			proceedOnSignal(this, command.completed);
			
			command.execute();
		}
		
		[Test]
		public function command_executes_all_sync_commands():void
		{
			command = createCompositeCommandInstance(CompositeSignalCommand);
			signalBus.commandCompleted = strict(Signal, null, [ISignalCommand]);
			
			command.addCommand(TestDispatchCompletedSignalBusSyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusSyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusSyncCommand);
			
			mock(signalBus.commandCompleted).method('dispatch').times(3);
			command.execute();
			
			verify(signalBus.commandCompleted);
		}
		
		[Test(async)]
		public function command_executes_all_async_commands():void
		{
			command = createCompositeCommandInstance(CompositeSignalCommand);
			signalBus.commandCompleted = strict(Signal, null, [ISignalCommand]);
			
			command.addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			
			mock(signalBus.commandCompleted).method('dispatch').times(3);

			handleSignal(this, command.completed, function():void
			{
				verify(signalBus.commandCompleted);
			});
			
			command.execute();
		}
		
		[Test(async)]
		public function command_executes_all_mixed_commands():void
		{
			command = createCompositeCommandInstance(CompositeSignalCommand);
			signalBus.commandCompleted = strict(Signal, null, [ISignalCommand]);
			
			command.addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusSyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusSyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			
			mock(signalBus.commandCompleted).method('dispatch').times(5);
			
			handleSignal(this, command.completed, function():void
			{
				verify(signalBus.commandCompleted);
			});
			
			command.execute();
		}
		
		[Test(async)]
		public function command_executes_all_commands_in_nested_composite_commands():void
		{
			command = createCompositeCommandInstance(CompositeSignalCommand);
			signalBus.commandCompleted = strict(Signal, null, [ISignalCommand]);
			
			command.addCommand(TestCompositeCommand);
			command.addCommand(TestCompositeCommand);
			command.addCommand(TestCompositeCommand);
			
			mock(signalBus.commandCompleted).method('dispatch').times(9);
			
			handleSignal(this, command.completed, function():void
			{
				verify(signalBus.commandCompleted);
			}, 2000);
			
			command.execute();
		}
		
		[Test(async)]
		public function command_dispatches_failed_when_an_async_command_fails():void
		{
			command = createCompositeCommandInstance(CompositeSignalCommand);
			
			command.addCommand(TestFailAsyncCommand);
			
			proceedOnSignal(this, command.failed);
			
			command.execute();
		}
		
		[Test]
		public function command_instantiates_child_command_with_payload():void
		{
			command = createCompositeCommandInstance(TestPayloadCompositeCommand);
			command.addCommand(TestPayloadCommand);
			
			signalBus.commandCompleted.add(function(childCommand:TestPayloadCommand):void
			{
				assertEquals((command as TestPayloadCompositeCommand).property, childCommand.property);
			});
			
			command.execute();
		}
	}
}