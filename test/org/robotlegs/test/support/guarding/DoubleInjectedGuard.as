package org.robotlegs.test.support.guarding 
{
	import org.robotlegs.core.IGuard;

	public class DoubleInjectedGuard implements IGuard
	{
	    [Inject]
		public var answer:IInjectedAnswer;

	    [Inject]
		public var otherAnswer:IInjectedOtherAnswer;

	    //---------------------------------------
	    // IGuard Implementation
	    //---------------------------------------

	    //import org.robotlegs.core.IGuard;
	    public function approve():Boolean
	    {
	    	return (answer.allow() && otherAnswer.allow());
	    }
	
	} 

}