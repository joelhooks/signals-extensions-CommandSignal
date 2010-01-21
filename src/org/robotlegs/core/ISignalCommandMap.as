package org.robotlegs.core
{
	import org.osflash.signals.ISignal;
	
    public interface ISignalCommandMap
    {
        function mapSignal(signal:ISignal, commandClass:Class, oneShot:Boolean = false):void;

        function mapSignalClass(signalClass:Class, commandClass:Class, oneShot:Boolean = false):ISignal;

        function hasSignalCommand(signal:ISignal, commandClass:Class):Boolean;

        function unmapSignal(signal:ISignal, commandClass:Class):void;
		
        function unmapSignalClass(signalClass:Class, commandClass:Class):void;
    }
}
