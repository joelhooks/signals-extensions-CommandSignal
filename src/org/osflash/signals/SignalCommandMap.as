package org.osflash.signals
{
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;

    import org.robotlegs.core.IInjector;

    public class SignalCommandMap implements ISignalCommandMap
    {
        protected var injector:IInjector;
        protected var mappedCommands:Dictionary;
        protected var oneShotCommands:Dictionary;
        protected var verifiedCommandClasses:Dictionary;
		protected var callbacksByCommandClass:Dictionary;

        public function SignalCommandMap(injector:IInjector)
        {
			this.injector = injector;
            verifiedCommandClasses = new Dictionary( false );
            oneShotCommands = new Dictionary( false );
            mappedCommands = new Dictionary( false );
            callbacksByCommandClass = new Dictionary( false );
        }

        public function mapSignal(signal:ISignal, commandClass:Class, oneShot:Boolean = false):void
        {
            verifyCommandClass( commandClass );
            if ( hasSignalCommand( signal, commandClass ) )
                return;
            mappedCommands[signal] = commandClass;
            if ( oneShot )
                oneShotCommands[signal] = commandClass;
				
			var callback:Function = function(a:*=null, b:*=null, c:*=null, d:*=null, e:*=null, f:*=null, g:*=null):void
			{
				routeSignalToCommand(signal, arguments, commandClass, oneShot);
			};
			
			callbacksByCommandClass[commandClass] = callback;
			signal.add(callback);
        }

        public function hasSignalCommand(signal:ISignal, commandClass:Class):Boolean
        {
            return mappedCommands[signal] != null;
        }

        public function unmapSignal(signal:ISignal, commandClass:Class):void
        {
            if ( hasSignalCommand( signal, commandClass ) )
            {
                delete mappedCommands[signal];
                delete verifiedCommandClasses[commandClass];
            }
			signal.remove( callbacksByCommandClass[commandClass] );
        }

        protected function routeSignalToCommand(signal:ISignal, valueObjects:Array, commandClass:Class, oneshot:Boolean):void
        {
			var value:Object;
			for each( value in valueObjects )
			{
				injector.mapValue( value.constructor, value );
			}

			var command:Object = injector.instantiate(commandClass);

			for each( value in valueObjects )
			{
				injector.unmap( value.constructor );
			}
			
			command.execute( );
			
            if (oneshot)
			{
				unmapSignal( signal, commandClass );
			}
        }
		
/*
        protected function injectCommandValues(commandInstance:Object, valueObjects:Array):void
        {
			var value:Object;
			for each( value in valueObjects )
			{
				injector.mapValue( value.constructor, value );
			}

			injector.injectInto( commandInstance );

			for each( value in valueObjects )
			{
				injector.unmap( value.constructor );
			}
       }

        protected function injectCommandProperty(variableTypeNameMap:Object, value:Object, commandInstance:Object):void
        {
            var valueFQCN:String = getQualifiedClassName( value );
            for ( var propName:String in variableTypeNameMap )
            {
                if ( variableTypeNameMap[propName] == valueFQCN )
                {
                    commandInstance[propName] = value;
                    delete variableTypeNameMap[propName];
                    return;
                }
            }
        }

        protected function getCommandVariableTypeNameMap(commandInstance:Object):Object
        {
            var variableTypeNameMap:Object = {};
            var variableXML:XMLList = describeType( commandInstance ).variable;
            for each( var variable:XML in variableXML )
            {
                variableTypeNameMap[variable.@name] = variable.@type;
            }
            return variableTypeNameMap;
        }
*/
		
        protected function verifyCommandClass(commandClass:Class):void
        {
            if ( !verifiedCommandClasses[commandClass] )
            {
                verifiedCommandClasses[commandClass] = describeType( commandClass ).factory.method.(@name == "execute").length() == 1;
                if ( !verifiedCommandClasses[commandClass] )
                {
                    throw new Error( "Command Class does not implement an execute() method - " + commandClass );
                }
            }
        }
    }
}
