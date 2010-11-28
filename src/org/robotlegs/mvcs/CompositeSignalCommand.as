package org.robotlegs.mvcs
{
	import org.robotlegs.core.IAsyncSignalCommand;
	import org.robotlegs.core.ICompositeSignalCommand;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.core.ISignalCommand;

	public class CompositeSignalCommand extends AsyncSignalCommand implements ICompositeSignalCommand
	{

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var reflector:IReflector;

		protected var commandList:Vector.<Class>;
		
		protected var _numCommands:int;

		public function CompositeSignalCommand()
		{
		}

		public function get numCommands():int
		{
			return _numCommands;
		}

		public function addCommand(commandClass:Class):Class
		{
			if (!reflector.classExtendsOrImplements(commandClass, ISignalCommand))
				throw new ArgumentError("Command class " + commandClass + " does not implement ISignalCommand");

			commandList ||= new Vector.<Class>();

			commandList[commandList.length] = commandClass;
			
			// Count the number of commands as we add them since commands are removed
			// as we execute them, resulting in an incorrect count.
			_numCommands = commandList.length;

			return commandClass;
		}

		override public function execute():void
		{
			if (!commandList || commandList.length == 0)
				throw new Error(this + " has no commands in queue.");
			
			executeNextCommand();
		}

		protected function instantiateCommand(commandClass:Class, payload:Object = null, payloadClass:Class = null, payloadNamed:String = ""):ISignalCommand
		{
			// You can override this method in case the child commands require a payload.

			// I considered moving this implementation to a more accessible class,
			// but will keep it here until a common use-case arises.

			var preservedMappedValue:Object;

			if (payload != null)
			{
				payloadClass ||= reflector.getClass(payload);

				// Though highly unlikely since payload classes aren't typically mapped,
				// preserve any previously mapped classes of the payload's type
				if (injector.hasMapping(payloadClass, payloadNamed))
				{
					// In case the mapped class hasn't been instantiated yet,
					// instantiate it so the preserved mapped value isn't remapped as null.
					preservedMappedValue = injector.getInstance(payloadClass, payloadNamed) || injector.instantiate(payloadClass);

					injector.unmap(payloadClass, payloadNamed);
				}
				
				injector.mapValue(payloadClass, payload, payloadNamed);
			}

			var command:ISignalCommand = injector.instantiate(commandClass);

			if (payload != null)
			{
				injector.unmap(payloadClass, payloadNamed);

				// Remap the preserved mapped value.
				if (preservedMappedValue != null)
				{
					injector.mapValue(payloadClass, preservedMappedValue, payloadNamed);
				}
			}

			return command;
		}

		protected function executeNextCommand():void
		{
			if (commandList.length > 0)
			{
				var command:ISignalCommand = instantiateCommand(commandList.shift());

				if (command is IAsyncSignalCommand)
				{
					var asyncCommand:IAsyncSignalCommand = command as IAsyncSignalCommand;

					asyncCommand.completed.add(commandCompletedHandler);
					asyncCommand.failed.add(commandFailedHandler);

					command.execute();
				}
				else if (command is ISignalCommand)
				{
					command.execute();
					executeNextCommand();
				}
			}
			else
			{
				dispatchComplete();
			}
		}

		protected function commandCompletedHandler():void
		{
			executeNextCommand();
		}

		protected function commandFailedHandler(error:*):void
		{
			// Fail completely if one command fails.
			
			// It might be useful to add a property indicating whether
			// to continue if a child command fails.
			// Also, non-async signal commands have no way of indicating
			// failure, so if one does, the composite command will continue.

			commandList.length = 0;

			dispatchFail(error);
		}
	}
}