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

		protected function instantiateCommand(commandClass:Class, payloadClassList:Array = null, payloadValueList:Array = null):ISignalCommand
		{
			// You can override this method in case the child commands require a payload.

			return signalCommandMap.createCommandInstance(commandClass, payloadClassList, payloadValueList);
		}

		protected function executeNextCommand():void
		{
			if (commandList.length > 0)
			{
				var command:ISignalCommand = instantiateCommand(commandList.shift());

				if (command is IAsyncSignalCommand)
				{
					executeAsyncCommand(command as IAsyncSignalCommand);
				}
				else if (command is ISignalCommand)
				{
					executeSyncCommand(command);
				}
			}
			else
			{
				dispatchComplete();
			}
		}
		
		protected function executeSyncCommand(command:ISignalCommand):void
		{
			command.execute();
			executeNextCommand();
		}
		
		protected function executeAsyncCommand(command:IAsyncSignalCommand):void
		{
			command.completed.add(commandCompletedHandler);
			command.failed.add(commandFailedHandler);
			
			command.execute();
		}
		
		override protected function release():void
		{
			super.release();
			
			commandList.length = 0;
		}
		
		protected function commandCompletedHandler():void
		{
			executeNextCommand();
		}

		protected function commandFailedHandler(error:*):void
		{
			dispatchFail(error);
		}
	}
}