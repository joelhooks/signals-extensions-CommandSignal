package org.robotlegs.base
{
	import flash.utils.Dictionary;
	
	import org.flexunit.asserts.*;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.test.support.TestNoPropertiesCommand;
	
	public class SignalCommandMapProtectedTests extends SignalCommandMap
	{
		public function SignalCommandMapProtectedTests()
		{
			super(null);
		}
		
		[Before]
		public function setup():void
		{
			this.injector = new SwiftSuspendersInjector();
			this.signalMap = new Dictionary( false );
			this.signalClassMap = new Dictionary( false );
			this.verifiedCommandClasses = new Dictionary( false );
			this.detainedCommands = new Dictionary( false );
		}
		
		[After]
		public function teardown():void
		{
			this.injector = null;
			this.signalMap = null;
			this.signalClassMap = null;
			this.verifiedCommandClasses = null;
			this.detainedCommands = null;
		}
		
		[Test]
		public function test_detain_and_release():void
		{
			var command:Object = new TestNoPropertiesCommand();
			detain(command);
			assertTrue('detainedCommands Dictionary should contain command following detain call', detainedCommands[command]);
			release(command);
			assertTrue('detainedCommands Dictionary should not contain command following release call', detainedCommands[command] == undefined);
		}
		
		[Test]
		public function test_detain_twice_and_release():void
		{
			var command:Object = new TestNoPropertiesCommand();
			detain(command);
			detain(command);
			release(command);
			assertTrue('A single release call should be sufficient to remove a detained command, regardless of the number of detain calls', detainedCommands[command] == undefined);
		}
		
		[Test]
		public function test_release_without_detain():void
		{
			var command:Object = new TestNoPropertiesCommand();
			release(command);
			assertTrue('releasing a command that was not detained should not cause an error', true);
		}
		
		[Test]
		public function test_detain_release_null_object():void
		{
			var command:Object = null;
			detain(command);
			assertTrue('detainedCommands Dictionary should contain null command object following detain call', detainedCommands[command]);
			release(command);
			assertTrue('detainedCommands Dictionary should not contain null command following release call', detainedCommands[command] == undefined);
		}
	}
}