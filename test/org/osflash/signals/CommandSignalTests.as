package org.osflash.signals
{
    import asunit.asserts.*;

    import org.osflash.signals.CommandSignal;
    import org.osflash.signals.CommandSignal;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.test.support.*;
    import org.robotlegs.adapters.SwiftSuspendersInjector;
    import org.robotlegs.core.IInjector;

    public class CommandSignalTests
    {
        private var commandSignal:ICommandSignal;
        private var injector:IInjector;

        [Before]
        public function setup():void
        {
            injector = new SwiftSuspendersInjector( );
            commandSignal = new CommandSignal( );
            CommandSignal(commandSignal).injector = injector;
        }

        [After]
        public function teardown():void
        {
            injector = null;
            commandSignal = null;
        }

        [Test]
        public function CommandSignal_instance_is_ICommandSignal():void
        {
            assertTrue( commandSignal is ICommandSignal )
        }

        [Test]
        public function mapping_command_created_mapped_command():void
        {
            commandSignal.mapCommand( TestNoPropertiesCommand );
            assertTrue( commandSignal.hasMappedCommand( TestNoPropertiesCommand ) )
        }

        [Test(expects="Error")]
        public function mapping_object_with_no_execute_throws_error():void
        {
            commandSignal.mapCommand( TestNoExecuteCommand );
        }

        [Test]
        public function removing_command_removes_command():void
        {
            commandSignal.mapCommand( TestNoPropertiesCommand );
            commandSignal.removeMappedCommand( TestNoPropertiesCommand );
            assertFalse( commandSignal.hasMappedCommand( TestNoPropertiesCommand ) );
        }

        [Test]
        public function dispatch_signal_executes_command():void
        {
            var prop:TestCommandProperty = new TestCommandProperty( );
            commandSignal = new CommandSignal( TestCommandProperty );
            commandSignal.mapCommand( TestOnePropertyCommand );
            CommandSignal( commandSignal ).dispatch( prop );
            assertTrue( prop.wasExecuted )
        }

        [Test]
        public function multiple_command_properties_values_are_injected():void
        {
            var propOne:TestCommandProperty = new TestCommandProperty( );
            var propTwo:TestCommandProperty = new TestCommandProperty( );
            commandSignal = new CommandSignal( TestCommandProperty, TestCommandProperty );
            commandSignal.mapCommand( TestTwoPropertyCommand );
            CommandSignal( commandSignal ).dispatch( propOne, propTwo );
            assertTrue( propOne.wasExecuted && propTwo.wasExecuted )
        }

        [Test]
        public function one_shot_command_only_executed_once():void
        {
            var prop:TestCommandProperty = new TestCommandProperty( );
            commandSignal = new CommandSignal( TestCommandProperty );
            commandSignal.mapCommand( TestOnePropertyCommand );

            CommandSignal( commandSignal ).dispatch( prop );
            assertTrue( prop.wasExecuted )
            prop.wasExecuted = false;
            CommandSignal( commandSignal ).dispatch( prop );

            assertFalse( prop.wasExecuted )
        }

        [Test]
        public function test_multiple_commands_are_executed_on_dispatch():void
        {
            var propOne:TestCommandProperty = new TestCommandProperty( );
            var propTwo:TestCommandProperty = new TestCommandProperty( );
            commandSignal = new CommandSignal( TestCommandProperty );
            commandSignal.mapCommand( TestOnePropertyCommand );
            commandSignal.mapCommand( TestTwoPropertyCommand );
            CommandSignal( commandSignal ).dispatch( propOne, propTwo );

            assertTrue(propOne.wasExecuted && propTwo.wasExecuted)
        }

        [Test]
        public function mapped_injections_are_supplied_to_executed_command():void
        {
            var propOne:TestCommandProperty = new TestCommandProperty( );
            var propTwo:TestCommandProperty = new TestCommandProperty( );
            var injectedProp:TestInjectedProperty = new TestInjectedProperty( );
            commandSignal = new CommandSignal( TestCommandProperty, TestCommandProperty );
            CommandSignal(commandSignal).injector = injector;
            injector.mapValue(TestInjectedProperty, injectedProp);
            commandSignal.mapCommand( TestThreePropertyCommand );
            CommandSignal( commandSignal ).dispatch( propOne, propTwo );

            assertTrue( propOne.wasExecuted && propTwo.wasExecuted && injectedProp.wasExecuted )
        }
    }
}