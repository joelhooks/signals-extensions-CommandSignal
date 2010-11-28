package org.robotlegs.mvcs
{
	import flash.display.Sprite;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.utils.handleSignal;
	import org.osflash.signals.utils.proceedOnSignal;
	import org.robotlegs.core.ICompositeSignalCommand;
	import org.robotlegs.core.ISignalCommand;
	import org.robotlegs.test.support.SignalBusTestClass;
	import org.robotlegs.test.support.SignalContextWithAccessibleInjector;
	import org.robotlegs.test.support.TestCommandProperty;
	import org.robotlegs.test.support.TestCompleteAsyncCommand;
	import org.robotlegs.test.support.TestCompleteSyncCommand;
	import org.robotlegs.test.support.TestCompositeCommand;
	import org.robotlegs.test.support.TestDispatchCompletedSignalBusAsyncCommand;
	import org.robotlegs.test.support.TestDispatchCompletedSignalBusSyncCommand;
	import org.robotlegs.test.support.TestFailAsyncCommand;
	import org.robotlegs.test.support.TestValueClassNamedPayloadCommand;
	import org.robotlegs.test.support.TestValueClassNamedPayloadCompositeCommand;
	import org.robotlegs.test.support.TestValueClassPayloadCommand;
	import org.robotlegs.test.support.TestValueClassPayloadCompositeCommand;
	import org.robotlegs.test.support.TestValuePayloadCommand;
	import org.robotlegs.test.support.TestValuePayloadCompositeCommand;

	public class CompositeSignalCommandTests
	{		
		protected var context:SignalContextWithAccessibleInjector;
		
		protected var command:CompositeSignalCommand;
		
		protected var signalBus:SignalBusTestClass;
		
		[Before]
		public function setUp():void
		{
			context = new SignalContextWithAccessibleInjector(new Sprite());
			signalBus = new SignalBusTestClass();
			
			context.getInjector().mapValue(SignalBusTestClass, signalBus);
		}
		
		[After]
		public function tearDown():void
		{
			context = null;
			command = null;
			signalBus = null;
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
			command = context.getInjector().instantiate(CompositeSignalCommand);
			
			command.addCommand(TestCompleteSyncCommand);
			command.addCommand(TestCompleteSyncCommand);
			
			assertEquals(2, command.numCommands);
		}
		
		[Test(expects="ArgumentError")]
		public function command_throws_error_when_adding_a_non_signal_command():void
		{
			command = context.getInjector().instantiate(CompositeSignalCommand);
			
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
			command = context.getInjector().instantiate(CompositeSignalCommand);
			
			command.addCommand(TestCompleteSyncCommand);
			command.addCommand(TestCompleteSyncCommand);
			command.addCommand(TestCompleteSyncCommand);
			
			proceedOnSignal(this, command.completed);
			
			command.execute();
		}
		
		[Test(async)]
		public function command_dispatches_completed_when_all_async_commands_complete():void
		{
			command = context.getInjector().instantiate(CompositeSignalCommand);

			command.addCommand(TestCompleteAsyncCommand);
			command.addCommand(TestCompleteAsyncCommand);
			command.addCommand(TestCompleteAsyncCommand);
			
			proceedOnSignal(this, command.completed);
			
			command.execute();
		}
		
		[Test]
		public function command_executes_all_sync_commands():void
		{
			command = context.getInjector().instantiate(CompositeSignalCommand);
			
			command.addCommand(TestDispatchCompletedSignalBusSyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusSyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusSyncCommand);
			
			var numExecutedCommands:int;
			
			signalBus.commandCompleted.add(function(childCommand:ISignalCommand):void
			{
				numExecutedCommands++;
			});
			
			command.completed.add(function():void
			{
				assertEquals(3, numExecutedCommands);
			});
			
			command.execute();
		}
		
		[Test(async)]
		public function command_executes_all_async_commands():void
		{
			command = context.getInjector().instantiate(CompositeSignalCommand);
			
			command.addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			
			var numExecutedCommands:int;
			
			signalBus.commandCompleted.add(function(childCommand:TestDispatchCompletedSignalBusAsyncCommand):void
			{
				numExecutedCommands++;
			});

			handleSignal(this, command.completed, function():void
			{
				assertEquals(3, numExecutedCommands);
			});
			
			command.execute();
		}
		
		[Test(async)]
		public function command_executes_all_mixed_commands():void
		{
			command = context.getInjector().instantiate(CompositeSignalCommand);
			
			command.addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusSyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusSyncCommand);
			command.addCommand(TestDispatchCompletedSignalBusAsyncCommand);
			
			var numExecutedCommands:int;
			
			signalBus.commandCompleted.add(function(childCommand:*):void
			{
				numExecutedCommands++;
			});
			
			handleSignal(this, command.completed, function():void
			{
				assertEquals(5, numExecutedCommands);
			});
			
			command.execute();
		}
		
		[Test(async)]
		public function command_executes_all_commands_in_nested_composite_commands():void
		{
			command = context.getInjector().instantiate(CompositeSignalCommand);
			
			command.addCommand(TestCompositeCommand);
			command.addCommand(TestCompositeCommand);
			command.addCommand(TestCompositeCommand);
			
			var numExecutedSubCommands:int;
			
			signalBus.commandCompleted.add(function(childCommand:*):void
			{
				numExecutedSubCommands++;
			});
			
			handleSignal(this, command.completed, function():void
			{
				assertEquals(9, numExecutedSubCommands);
			}, 2000);
			
			command.execute();
		}
		
		[Test(async)]
		public function command_dispatches_failed_when_an_async_command_fails():void
		{
			command = context.getInjector().instantiate(CompositeSignalCommand);
			
			command.addCommand(TestFailAsyncCommand);
			
			proceedOnSignal(this, command.failed);
			
			command.execute();
		}
		
		[Test]
		public function command_instantiates_child_command_with_value_payload():void
		{
			command = context.getInjector().instantiate(TestValuePayloadCompositeCommand);
			command.addCommand(TestValuePayloadCommand);
			
			signalBus.commandCompleted.add(function(childCommand:TestValuePayloadCommand):void
			{
				assertEquals((command as TestValuePayloadCompositeCommand).property, childCommand.property);
			});
			
			command.execute();
		}
		
		[Test]
		public function command_instantiates_child_command_with_value_class_payload():void
		{
			command = context.getInjector().instantiate(TestValueClassPayloadCompositeCommand);
			command.addCommand(TestValueClassPayloadCommand);
			
			signalBus.commandCompleted.add(function(childCommand:TestValueClassPayloadCommand):void
			{
				assertEquals((command as TestValueClassPayloadCompositeCommand).property, childCommand.property);
			});
			
			command.execute();
		}
		
		[Test]
		public function command_instantiates_child_command_with_value_class_named_payload():void
		{
			command = context.getInjector().instantiate(TestValueClassNamedPayloadCompositeCommand);
			command.addCommand(TestValueClassNamedPayloadCommand);
			
			signalBus.commandCompleted.add(function(childCommand:TestValueClassNamedPayloadCommand):void
			{
				assertEquals((command as TestValueClassNamedPayloadCompositeCommand).property, childCommand.property);
			});
			
			command.execute();
		}
		
		[Test]
		public function command_instantiates_child_command_with_value_payload_and_remaps_preexisting_mapped_value():void
		{
			var preexistingValue:TestCommandProperty = new TestCommandProperty();
			context.getInjector().mapValue(TestCommandProperty, preexistingValue);
			
			command = context.getInjector().instantiate(TestValuePayloadCompositeCommand);
			command.addCommand(TestValuePayloadCommand);
			
			signalBus.commandCompleted.add(function(childCommand:TestValuePayloadCommand):void
			{
				assertEquals(preexistingValue, context.getInjector().getInstance(TestCommandProperty));
			});
			
			command.execute();
		}
		
		[Test]
		public function command_instantiates_child_command_with_value_class_payload_and_remaps_preexisting_mapped_value():void
		{
			var preexistingValue:TestCommandProperty = new TestCommandProperty();
			context.getInjector().mapValue(TestCommandProperty, preexistingValue);
			
			command = context.getInjector().instantiate(TestValueClassPayloadCompositeCommand);
			command.addCommand(TestValueClassPayloadCommand);
			
			signalBus.commandCompleted.add(function(childCommand:TestValueClassPayloadCommand):void
			{
				assertEquals(preexistingValue, context.getInjector().getInstance(TestCommandProperty));
			});
			
			command.execute();
		}
		
		[Test]
		public function command_instantiates_child_command_with_value_class_named_payload_and_remaps_preexisting_mapped_value():void
		{
			var preexistingValue:TestCommandProperty = new TestCommandProperty();
			context.getInjector().mapValue(TestCommandProperty, preexistingValue, "TestCommandProperty");
			
			command = context.getInjector().instantiate(TestValueClassPayloadCompositeCommand);
			command.addCommand(TestValueClassPayloadCommand);
			
			signalBus.commandCompleted.add(function(childCommand:TestValueClassPayloadCommand):void
			{
				assertEquals(preexistingValue, context.getInjector().getInstance(TestCommandProperty, "TestCommandProperty"));
			});
			
			command.execute();
		}
	}
}