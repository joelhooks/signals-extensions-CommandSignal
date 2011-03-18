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
		
		[Test]
		public function test_unmapping_stops_command_firing():void {
			var guard:Class = HappyGuard; 
			var signal:Signal = new Signal();
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandA, guard);
			guardedCommandMap.unmapSignal(signal, SampleCommandA);
			signal.dispatch();
			assertThat(_reportedCommands, array());
		}		
		
		[Test]
		public function test_unmapping_and_remapping_with_guards_works_fine():void {
			var guard:Class = HappyGuard;
			var signal:Signal = new Signal();
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandA, guard);
			guardedCommandMap.unmapSignal(signal, SampleCommandA);
			guardedCommandMap.mapGuardedSignal(signal, SampleCommandA, guard);
			signal.dispatch();
			assertThat(_reportedCommands, array(SampleCommandA));
		}

		[Test]
		public function mapping_as_class_works_same_as_value():void {             
			var guard:Class = HappyGuard;
			var signal:ISignal = guardedCommandMap.mapGuardedSignalClass(Signal, SampleCommandA, guard);
			Signal(signal).dispatch();
			assertThat(_reportedCommands, array(SampleCommandA));
		}
		
		[Test]
		public function mapping_signal_class_with_fallback_executes_first_choice_if_guard_approves():void {             
			var guard:Class = HappyGuard;
			var signal:ISignal = guardedCommandMap.mapGuardedSignalClassWithFallback(Signal, SampleCommandA, SampleCommandB, guard);
			Signal(signal).dispatch();
			assertThat(_reportedCommands, array(SampleCommandA));
		} 
		
		[Test]
		public function mapping_signal_class_with_fallback_executes_fallback_if_guard_disapproves():void {             
			var guard:Class = GrumpyGuard;
			var signal:ISignal = guardedCommandMap.mapGuardedSignalClassWithFallback(Signal, SampleCommandA, SampleCommandB, guard);
			Signal(signal).dispatch();
			assertThat(_reportedCommands, array(SampleCommandB));
		}
		
		[Test]
		public function mapping_with_fallback_executes_first_choice_if_guard_approves():void {             
			var guard:Class = HappyGuard;
			var signal:Signal = new Signal();
			guardedCommandMap.mapGuardedSignalWithFallback(signal, SampleCommandA, SampleCommandB, guard);
			signal.dispatch();
			assertThat(_reportedCommands, array(SampleCommandA));
		} 
		
		[Test]
		public function mapping_with_fallback_executes_fallback_if_guard_disapproves():void {             
			var guard:Class = GrumpyGuard;
			var signal:Signal = new Signal();
			guardedCommandMap.mapGuardedSignalWithFallback(signal, SampleCommandA, SampleCommandB, guard);
			signal.dispatch();
			assertThat(_reportedCommands, array(SampleCommandB));
		}   	
    }
}