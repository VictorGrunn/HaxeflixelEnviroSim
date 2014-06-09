package entitytypes;
import flixel.FlxSprite;

/**
 * ...
 * @author Victor Grunn
 */
class MASTER_BASE extends FlxSprite
{
	private var ageMonth:Int = 0;
	private var ageYear:Int = 0;
	
	public var xSlot:Int = 0;
	public var ySlot:Int = 0;
	
	public var readyToUpdate:Bool = false;

	public function new() 
	{
		super();
		moves = false;		
	}	
	
	public function ageOneMonth():Void
	{
		
	}
	
	override public function update():Void 
	{
		return;
		
		super.update();
	}
	
	override public function draw():Void 
	{
		super.draw();
	}
	
}