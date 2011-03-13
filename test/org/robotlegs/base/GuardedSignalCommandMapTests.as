package org.robotlegs.base
{
    import mx.collections.ArrayCollection;

    import org.flexunit.asserts.*;
    import org.flexunit.*;
    import org.osflash.signals.ISignal;
    import org.robotlegs.adapters.SwiftSuspendersInjector;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.test.support.*;
    import org.robotlegs.test.support.guarding.ICommandReporter;
    import org.robotlegs.test.support.guarding.*;
    import org.robotlegs.core.IGuardedSignalCommandMap;
    import org.robotlegs.base.GuardedSignalCommandMap;
	import org.osflash.signals.Signal;
	import org.hamcrest.collection.*; 
	import org.robotlegs.base.ContextError;
	import flash.display.Sprite;
	
	public class GuardedSignalCommandMapTests implements ICommandReporter
    {
        private var guardedCommandMap:IGuardedSignalCommandMap;
        private var injector:IInjector;
        private var onePropSignal:TestCommandPropertySignal;
        private var twoPropSignal:TestTwoPropertySignal;
		private var _reportedCommands:Array;

        [Before]
        public function setup():void
        {
            _reportedCommands = [];
			injector = new SwiftSuspendersInjector();
			injector.mapValue(ICommandReporter, this);
            onePropSignal = new TestCommandPropertySignal();
            twoPropSignal = new TestTwoPropertySignal();
            guardedCommandMap = new GuardedSignalCommandMap(injector);
        }

        [After]
        public function teardown():void
        {
            injector = null;
            guardedCommandMap = null;
        }
        
		public function reportCommand(commandClass:Class):void
		{
			_reportedCommands.push(commandClass);
		}

        [Test]
        public function GuardedSignalCommandMap_instance_is_IGuardedSignalCommandMap():void
        {
            assertTrue(guardedCommandMap is IGuardedSignalCommandMap)
        }

		[Test]
		public function one_command_with_one_guard_fires_when_guard_gives_yes():void {             
			var guard:Class = HappyGuard;
			var signal:Signal = new Signal();
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandA, guard);
			signal.dispatch();
			assertThat(_reportedCommands, array(SampleCommandA));
		} 
		
		[Test]
		public function one_command_with_one_guard_doesnt_fire_when_guard_gives_no():void {
			var guard:Class = GrumpyGuard;    
			var signal:Signal = new Signal();
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandA, guard);
			signal.dispatch();
			assertThat(_reportedCommands, array());
		}

		[Test]
		public function one_command_with_two_guards_fires_if_both_say_yes():void {
			injector.mapSingletonOf(IInjectedAnswer, InjectedYes);
			var guards:Array = [InjectedGuard, HappyGuard];   
			var signal:Signal = new Signal();
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandA, guards);
			signal.dispatch();
			assertThat(_reportedCommands, array(SampleCommandA));
		}

		[Test]
		public function one_command_with_two_guards_doesnt_fire_if_one_says_no():void {
			var guards:Array = [GrumpyGuard, HappyGuard];
			var signal:Signal = new Signal();
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandA, guards);
			signal.dispatch();
			assertThat(_reportedCommands, array());
		}

		[Test]
		public function command_doesnt_fire_if_double_injected_guard_says_no():void {
			injector.mapSingletonOf(IInjectedAnswer, InjectedYes);
			injector.mapSingletonOf(IInjectedOtherAnswer, InjectedNo);
			var guards:Array = [HappyGuard, DoubleInjectedGuard];  
			var signal:Signal = new Signal();
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandA, guards);
			signal.dispatch();
			assertThat(_reportedCommands, array());
		}
		
		[Test]
		public function three_commands_with_different_guards_fire_correctly():void { 
			injector.mapSingletonOf(IInjectedAnswer, InjectedYes);  
			var signal:Signal = new Signal();
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandA, HappyGuard);
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandB, GrumpyGuard);
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandC, [HappyGuard, InjectedGuard]);
			signal.dispatch();       
			assertThat(_reportedCommands, array(SampleCommandA, SampleCommandC));
		}
		
		[Test(expected="org.robotlegs.base.ContextError")]
		public function error_thrown_if_non_guards_provided_in_guard_value_argument():void {
			var signal:Signal = new Signal();
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandA, Sprite);
		}
		
		[Test(expected="org.robotlegs.base.ContextError")]
		public function error_thrown_if_non_guards_provided_in_guard_array_argument():void {
			var signal:Signal = new Signal();
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandA, [HappyGuard, Sprite]);
		}
		
		[Test]
		public function signal_values_passed_to_guards():void {
			var signal:Signal = new Signal(Boolean);
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandA, CooperativeGuard);
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandB, ContraryGuard);
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandC, CooperativeGuard);
			signal.dispatch(true);
			assertThat(_reportedCommands, array(SampleCommandA, SampleCommandC));
		}
		
		/*
		
		public function test_unmapping_stops_command_firing():void {
			var guard:Class = HappyGuard;
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, guard, ContextEvent);
			guardedCommandMap.unmapEvent(ContextEvent.STARTUP, SampleCommandA, ContextEvent);
			eventDispatcher.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
			assertEqualsArraysIgnoringOrder("received the correct command", [], _reportedCommands);
		}		
		
		public function test_unmapping_and_remapping_with_guards_works_fine():void {
			var guard:Class = HappyGuard;
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, guard, ContextEvent);
			guardedCommandMap.unmapEvent(ContextEvent.STARTUP, SampleCommandA, ContextEvent);
			guardedCommandMap.mapGuardedEvent(ContextEvent.STARTUP, SampleCommandA, guard, ContextEvent);
			eventDispatcher.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
			assertEqualsArraysIgnoringOrder("received the correct command", [SampleCommandA], _reportedCommands);  
		}
		*/
        /*
        [Test]
        public function mapping_signal_creates_command_mapping():void
        {
            signalCommandMap.mapSignal(onePropSignal, TestNoPropertiesCommand);
            assertTrue(signalCommandMap.hasSignalCommand(onePropSignal, TestNoPropertiesCommand))
        }

        [Test(expects="org.robotlegs.base.ContextError")]
        public function mapping_class_with_no_execute_throws_error():void
        {
            signalCommandMap.mapSignal(onePropSignal, TestNoExecuteCommand);
        }

        [Test]
        public function unmapping_signal_removes_command_mapping():void
        {
            signalCommandMap.mapSignal(onePropSignal, TestNoPropertiesCommand);
            signalCommandMap.unmapSignal(onePropSignal, TestNoPropertiesCommand);
            assertFalse(signalCommandMap.hasSignalCommand(onePropSignal, TestNoPropertiesCommand));
        }

        [Test]
        public function dispatch_signal_executes_command():void
        {
            var prop:TestCommandProperty = new TestCommandProperty();
            signalCommandMap.mapSignal(onePropSignal, TestOnePropertyCommand);
            onePropSignal.dispatch(prop);
            assertTrue(prop.wasExecuted);
        }

        [Test]
        public function multiple_command_properties_values_are_injected():void
        {
            var propOne:TestCommandProperty = new TestCommandProperty();
            var propTwo:TestCommandProperty2 = new TestCommandProperty2();
            signalCommandMap.mapSignal(twoPropSignal, TestTwoPropertyCommand);
            twoPropSignal.dispatch(propOne, propTwo);
            assertTrue(propOne.wasExecuted && propTwo.wasExecuted);
        }

        [Test]
        public function command_can_be_executed_multiple_times():void
        {
            var prop:TestCommandProperty = new TestCommandProperty();
            signalCommandMap.mapSignal(onePropSignal, TestOnePropertyCommand);
            onePropSignal.dispatch(prop);
            prop.wasExecuted = false;
            onePropSignal.dispatch(prop);
            assertTrue(prop.wasExecuted);
        }

        [Test]
        public function command_receives_constructor_dependency_from_signal_dispatch():void
        {
            var prop:TestCommandProperty = new TestCommandProperty();
            signalCommandMap.mapSignal(onePropSignal, TestOnePropertyConstructorCommand);
            onePropSignal.dispatch(prop);
            assertTrue(prop.wasExecuted);
        }

        [Test]
        public function command_receives_two_constructor_dependencies_from_signal_dispatch():void
        {
            var propOne:TestCommandProperty = new TestCommandProperty();
            var propTwo:TestCommandProperty2 = new TestCommandProperty2();
            signalCommandMap.mapSignal(twoPropSignal, TestTwoPropertyConstructorCommand);
            twoPropSignal.dispatch(propOne, propTwo);
            assertTrue(propOne.wasExecuted && propTwo.wasExecuted);
        }

        [Test]
        public function one_shot_command_only_executes_once():void
        {
            var prop:TestCommandProperty = new TestCommandProperty();
            signalCommandMap.mapSignal(onePropSignal, TestOnePropertyCommand, true);

            onePropSignal.dispatch(prop);
            assertTrue(prop.wasExecuted);
            prop.wasExecuted = false;
            onePropSignal.dispatch(prop);

            assertFalse(prop.wasExecuted);
        }

        [Test]
        public function mapping_signal_class_returns_instance():void
        {
            var signal:ISignal = signalCommandMap.mapSignalClass(TestCommandPropertySignal, TestNoPropertiesCommand);

            assertTrue(signal is ISignal);
        }

        [Test]
        public function signal_mapped_as_class_maps_signal_instance_with_injector():void
        {
            var signal:ISignal = signalCommandMap.mapSignalClass(TestCommandPropertySignal, TestNoPropertiesCommand);
            var signalTwo:ISignal = injector.instantiate(SignalInjecteeTestClass).signal;

            assertEquals(signal, signalTwo);
        }

        [Test]
        public function mapping_signal_class_twice_returns_same_signal_instance():void
        {
            var signalOne:ISignal = signalCommandMap.mapSignalClass(TestCommandPropertySignal, TestNoPropertiesCommand);
            var signalTwo:ISignal = signalCommandMap.mapSignalClass(TestCommandPropertySignal, TestOnePropertyCommand);

            assertEquals(signalOne, signalTwo);
        }

        [Test]
        public function map_signal_class_creates_command_mapping():void
        {
            var signal:ISignal = signalCommandMap.mapSignalClass(TestCommandPropertySignal, TestNoPropertiesCommand);
            assertTrue(signalCommandMap.hasSignalCommand(signal, TestNoPropertiesCommand));
        }

        [Test]
        public function unmap_signal_class_removes_command_mapping():void
        {
            var signal:ISignal = signalCommandMap.mapSignalClass(TestCommandPropertySignal, TestNoPropertiesCommand);
            signalCommandMap.unmapSignalClass(TestCommandPropertySignal, TestNoPropertiesCommand);
            assertFalse(signalCommandMap.hasSignalCommand(signal, TestNoPropertiesCommand));
        }

        [Test]
        public function xml_signal_value_properly_injected_into_command():void
        {
            var prop:TestCommandProperty = new TestCommandProperty();
            var xml:XML = <this></this>;
            var signal:TestXMLPropertySignal = new TestXMLPropertySignal();
            signalCommandMap.mapSignal(signal, TestXMLPropertyCommand);

            signal.dispatch(xml,prop);

            assertTrue(prop.wasExecuted);
        }

        [Test]
        public function ArrayCollection_signal_value_properly_injected_into_command():void
        {
            var prop:TestCommandProperty = new TestCommandProperty();
            var ac:ArrayCollection = new ArrayCollection();
            var signal:TestArrayCollectionPropertySignal = new TestArrayCollectionPropertySignal();
            signalCommandMap.mapSignal(signal, TestArrayCollectionPropertyCommand);

            signal.dispatch(ac, prop);

            assertTrue(prop.wasExecuted);
        }

		[Test]
		public function uint_signal_value_properly_injected_into_command():void
		{
			var prop:TestCommandProperty = new TestCommandProperty();
			var i:uint = 3;
			var signal:TestUintPropertySignal = new TestUintPropertySignal();
			signalCommandMap.mapSignal(signal, TestUintPropertyCommand);

			signal.dispatch(i,prop);

			assertTrue(prop.wasExecuted);
		}

		[Test]
		public function int_signal_value_properly_injected_into_command():void
		{
			var prop:TestCommandProperty = new TestCommandProperty();
			var i:int = 3;
			var signal:TestIntPropertySignal = new TestIntPropertySignal();
			signalCommandMap.mapSignal(signal, TestIntPropertyCommand);

			signal.dispatch(i,prop);

			assertTrue(prop.wasExecuted);
		} 
		*/
    }
}