package org.osflash.signals
{
    public interface ICommandSignal extends ISignal
    {
        function mapCommand(commandClass:Class, oneShot:Boolean = false):void;

        function hasCommand(commandClass:Class):Boolean;

        function removeCommand(commandClass:Class):void;
    }
}