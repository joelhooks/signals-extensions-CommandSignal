package org.robotlegs.test.support.guarding 
{

	public class InjectedNo implements IInjectedAnswer, IInjectedOtherAnswer
	{
	
		public function allow():Boolean
		{
			return false;
		}
	
	}

}

