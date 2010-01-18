package org.robotlegs.base
{
    import asunit.asserts.*;

    import org.robotlegs.test.support.*;
    import org.robotlegs.adapters.SwiftSuspendersInjector;
    import org.robotlegs.base.SignalCommandMap;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.core.ISignalCommandMap;

    public class SignalCommandMapTests
    {
		private var signalCommandMap:ISignalCommandMap;
		private var injector:IInjector;
		private var onePropSignal:TestCommandPropertySignal;
		private var twoPropSignal:TestTwoPropertySignal;

		[Before]
		public function setup():void
		{
			injector = new SwiftSuspendersInjector( );
			onePropSignal = new TestCommandPropertySignal();
			twoPropSignal = new TestTwoPropertySignal();
			signalCommandMap = new SignalCommandMap( injector );
		}

		[After]
		public function teardown():void
		{
			injector = null;
			signalCommandMap = null;
		}

		[Test]
		public function SignalCommandMap_instance_is_ISignalCommandMap():void
		{
			assertTrue( signalCommandMap is ISignalCommandMap )
		}

		[Test]
		public function mapping_command_created_mapped_command():void
		{
			signalCommandMap.mapSignal( onePropSignal, TestNoPropertiesCommand );
			assertTrue( signalCommandMap.hasSignalCommand( onePropSignal, TestNoPropertiesCommand ) )
		}

		[Test(expects="org.robotlegs.base.ContextError")]
		public function mapping_object_with_no_execute_throws_error():void
		{
			signalCommandMap.mapSignal( onePropSignal, TestNoExecuteCommand );
		}

		[Test]
		public function removing_command_removes_command():void
		{
			signalCommandMap.mapSignal( onePropSignal, TestNoPropertiesCommand );
			signalCommandMap.unmapSignal( onePropSignal, TestNoPropertiesCommand );
			assertFalse( signalCommandMap.hasSignalCommand( onePropSignal, TestNoPropertiesCommand ) );
		}

		[Test]
		public function dispatch_signal_executes_command():void
		{
			var prop:TestCommandProperty = new TestCommandProperty( );
			signalCommandMap.mapSignal( onePropSignal, TestOnePropertyCommand );
			onePropSignal.dispatch( prop );
			assertTrue( prop.wasExecuted );
		}
		
        [Test]
        public function multiple_command_properties_values_are_injected():void
        {
            var propOne:TestCommandProperty = new TestCommandProperty( );
            var propTwo:TestCommandProperty2 = new TestCommandProperty2( );
            signalCommandMap.mapSignal( twoPropSignal, TestTwoPropertyCommand );
            twoPropSignal.dispatch( propOne, propTwo );
            assertTrue( propOne.wasExecuted && propTwo.wasExecuted );
        }

        [Test]
        public function command_can_be_executed_multiple_times():void
        {
            var prop:TestCommandProperty = new TestCommandProperty( );
            signalCommandMap.mapSignal( onePropSignal, TestOnePropertyCommand );
            onePropSignal.dispatch( prop );
            prop.wasExecuted = false;
            onePropSignal.dispatch( prop );
            assertTrue( prop.wasExecuted );
        }
		
		[Test]
		public function command_receives_constructor_dependency_from_signal_dispatch():void
		{
			var prop:TestCommandProperty = new TestCommandProperty( );
			signalCommandMap.mapSignal( onePropSignal, TestOnePropertyConstructorCommand );
			onePropSignal.dispatch( prop );
			assertTrue( prop.wasExecuted );
		}

		[Test]
		public function command_receives_two_constructor_dependencies_from_signal_dispatch():void
		{
            var propOne:TestCommandProperty = new TestCommandProperty( );
            var propTwo:TestCommandProperty2 = new TestCommandProperty2( );
            signalCommandMap.mapSignal( twoPropSignal, TestTwoPropertyConstructorCommand );
            twoPropSignal.dispatch( propOne, propTwo );
            assertTrue( propOne.wasExecuted && propTwo.wasExecuted );
		}

        [Test]
        public function one_shot_command_only_executed_once():void
        {
            var prop:TestCommandProperty = new TestCommandProperty( );
            signalCommandMap.mapSignal( onePropSignal, TestOnePropertyCommand, true );

            onePropSignal.dispatch( prop );
            assertTrue( prop.wasExecuted );
            prop.wasExecuted = false;
            onePropSignal.dispatch( prop );

            assertFalse( prop.wasExecuted );
        }
    }
}
