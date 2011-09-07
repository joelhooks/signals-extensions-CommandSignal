package org.robotlegs.base {
import flash.utils.Dictionary;
import flash.utils.describeType;

import org.osflash.signals.ISignal;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;

public class GuardedSignalCommandMap extends SignalCommandMap implements IGuardedSignalCommandMap {

    protected var verifiedGuardClasses:Dictionary;

    public const E_GUARD_NOIMPL:String = 'Guard Class does not implement an approve() method';

    public function GuardedSignalCommandMap(injector:IInjector) {
        super(injector);
        this.verifiedGuardClasses = new Dictionary(false);
    }

    //---------------------------------------
    // IGuardedCommandMap Implementation
    //---------------------------------------

    //import org.robotlegs.core.IGuardedCommandMap;
    public function mapGuardedSignal(signal:ISignal, commandClass:Class, guards:*, oneShot:Boolean = false):void {
        mapGuardedSignalWithFallback(signal, commandClass, null, guards, oneShot);
    }

    public function mapGuardedSignalClass(signalClass:Class, commandClass:Class, guards:*, oneShot:Boolean = false):ISignal {
		return mapGuardedSignalClassWithFallback(signalClass, commandClass, null, guards, oneShot);
    }
    
    public function mapGuardedSignalWithFallback(signal:ISignal, commandClass:Class, fallbackCommandClass:Class, guards:*, oneShot:Boolean = false):void {
        verifyCommandClass(commandClass);

        if (!(guards is Array)) {
            guards = [guards];
        }

        verifyGuardClasses(guards);

        if (hasSignalCommand(signal, commandClass))
            return;

        const signalCommandMap:Dictionary = signalMap[signal] = signalMap[signal] || new Dictionary(false);

        const callback:Function = function():void 
		{
            routeSignalToGuardedCommand(signal, arguments, commandClass, fallbackCommandClass, oneShot, guards);
        };

        signalCommandMap[commandClass] = callback;
        signal.add(callback);
    }

    public function mapGuardedSignalClassWithFallback(signalClass:Class, commandClass:Class, fallbackCommandClass:Class, guards:*, oneShot:Boolean = false):ISignal {
        var signal:ISignal = getSignalClassInstance(signalClass);
        mapGuardedSignalWithFallback(signal, commandClass, fallbackCommandClass, guards, oneShot);
        return signal;
    }


    protected function routeSignalToGuardedCommand(signal:ISignal, valueObjects:Array, commandClass:Class, fallbackCommandClass:Class, oneshot:Boolean, guardClasses:Array):void
    {

		mapSignalValues(signal.valueClasses, valueObjects);

        var approved:Boolean = true;
		var guardClass:Class;
        var iLength:uint = guardClasses.length;
        for (var i:int = 0; i < iLength; i++) {
            guardClass = guardClasses[i];
            var nextGuard:Object = injector.instantiate(guardClass);
            approved = (approved && nextGuard.approve());
			if ((!approved) && (fallbackCommandClass == null)) {
		        unmapSignalValues(signal.valueClasses, valueObjects);
                return;
            }
        }
        
		var commandToInstantiate:Class = approved ? commandClass : fallbackCommandClass;

        var command:Object = injector.instantiate(commandToInstantiate);
        unmapSignalValues(signal.valueClasses, valueObjects);
        command.execute();

        if (oneshot)
            unmapSignal(signal, commandClass);

    }

    protected function verifyGuardClasses(guardClasses:Array):void {
        var iLength:uint = guardClasses.length;
        var guardClass:Class;
        for (var i:int = 0; i < iLength; i++) {
            guardClass = guardClasses[i];
            if (!verifiedGuardClasses[guardClass]) {
                verifiedGuardClasses[guardClass] = describeType(guardClass).factory.method.(@name == "approve").length();

                if (!verifiedGuardClasses[guardClass])
                    throw new ContextError(E_GUARD_NOIMPL + ' - ' + guardClass);
            }
        }

    }

}
}