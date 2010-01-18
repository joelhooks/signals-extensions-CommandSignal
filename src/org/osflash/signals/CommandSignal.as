package org.osflash.signals
{
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;

    import org.robotlegs.core.IInjector;

    public class CommandSignal extends Signal implements ICommandSignal, IDispatcher
    {
        [Inject]
        public var injector:IInjector;

        protected var mappedCommands:Array;
        protected var oneShotCommands:Dictionary;
        protected var verifiedCommandClasses:Dictionary;

        public function CommandSignal(...valueClasses)
        {
            super( );
            verifiedCommandClasses = new Dictionary( false );
            oneShotCommands = new Dictionary( false );
            mappedCommands = [];

            if ( !valueClasses ) return;

            _valueClasses = valueClasses.concat( );
            // loop backwards
            for ( var i:int = _valueClasses.length; i--; )
            {
                if ( !(_valueClasses[i] is Class) )
                {
                    throw new ArgumentError( 'Invalid valueClasses argument: item at index ' + i
                            + ' should be a Class but was:<' + _valueClasses[i] + '>.' );
                }
            }
        }

        public function mapCommand(commandClass:Class, oneShot:Boolean = false):void
        {
            verifyCommandClass( commandClass );
            if ( hasCommand( commandClass ) )
                return;
            mappedCommands[mappedCommands.length] = commandClass;
            if ( oneShot )
                oneShotCommands[commandClass] = commandClass;
        }

        public function hasCommand(commandClass:Class):Boolean
        {
            return mappedCommands.lastIndexOf( commandClass ) > -1;
        }

        public function removeCommand(commandClass:Class):void
        {
            if ( hasCommand( commandClass ) )
            {
                var commandIndex:int = mappedCommands.lastIndexOf( commandClass );
                mappedCommands.splice( commandIndex, 1 );
                delete verifiedCommandClasses[commandClass];
            }
        }

        override public function dispatch(...valueObjects):void
        {
            super.dispatch.apply( null, valueObjects );
            executeMappedCommands( valueObjects );
        }

        protected function executeMappedCommands(valueObjects:Array):void
        {
            var executedCommands:Array = [];
            for each( var command:Class in mappedCommands )
            {
                var instance:Object = new command( );
                injectCommandValues( instance, valueObjects );
                instance.execute( );
                executedCommands[executedCommands.length] = command;
            }
            removeOneShotCommands( executedCommands );
        }

        protected function removeOneShotCommands(executedCommands:Array):void
        {
            for each( var command:Class in executedCommands )
            {
                if ( oneShotCommands[command] )
                {
                    removeCommand( command );
                    delete oneShotCommands[command];
                }
            }
        }

        protected function injectCommandValues(commandInstance:Object, valueObjects:Array):void
        {
            var variableTypeNameMap:Object = getCommandVariableTypeNameMap( commandInstance );
            if ( injector )
                injector.injectInto( commandInstance );
            for each( var value:Object in valueObjects )
            {
                injectCommandProperty( variableTypeNameMap, value, commandInstance );
            }
        }

        protected function injectCommandProperty(variableTypeNameMap:Object, value:Object, commandInstance:Object):void
        {
            var valueFQCN:String = getQualifiedClassName( value );
            for ( var propName:String in variableTypeNameMap )
            {
                if ( variableTypeNameMap[propName] == valueFQCN )
                {
                    trace( propName );
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
                trace( variableTypeNameMap[variable.@name] )
            }
            return variableTypeNameMap;
        }

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