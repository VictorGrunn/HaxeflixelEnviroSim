package entitytypes;
import maingame.GameGroup;
import flixel.util.FlxColor;
import utils.ArrayChecker;

/**
 * ...
 * @author Victor Grunn
 */
class Agent_Roamer extends MASTER_AGENT
{

	public function new() 
	{
		super();		
	}
	
	override public function launch(_type:MASTER_AGENT.OCCTYPE_CREATURE):Void 
	{
		super.launch(_type);
		
		exists = true;
		
		switch (ID_TYPE)
		{
			case MASTER_AGENT.OCCTYPE_CREATURE.BEAR:				
				makeGraphic(GameGroup.pieceSize, GameGroup.pieceSize, FlxColor.RED);				
				
			case MASTER_AGENT.OCCTYPE_CREATURE.LUMBERJACK:
				makeGraphic(GameGroup.pieceSize, GameGroup.pieceSize, FlxColor.BLUE);
		}		
	}
	
	override public function ageOneMonth():Void 
	{
		super.ageOneMonth();
		
		roam();
	}
	
	override public function interrupt():Void 
	{
		movesLeft = 0;
		
		super.interrupt();
	}
	
	private function roam():Void
	{
		if (ID_TYPE == MASTER_AGENT.OCCTYPE_CREATURE.BEAR)
		{
			movesLeft = 5;
		}
		
		if (ID_TYPE == MASTER_AGENT.OCCTYPE_CREATURE.LUMBERJACK)
		{
			movesLeft = 3;
		}
		
		while (movesLeft > 0 && exists == true)
		{
			makeMove();
		}
	}
	
	private function makeMove():Void
	{
		var myX:Int = 0;
		var myY:Int = 0;													
		
		myX = xSlot;
		myY = ySlot;						
		
		var testArray = new Array<ArrayChecker>();			
		var checkArray = new Array<ArrayChecker>();
		
		testArray[0] = new ArrayChecker(myX - 1, myY - 1);			
		testArray[1] = new ArrayChecker(myX, myY - 1);
		testArray[2] = new ArrayChecker(myX + 1, myY - 1);
		testArray[3] = new ArrayChecker(myX - 1, myY);
		testArray[4] = new ArrayChecker(myX + 1, myY);
		testArray[5] = new ArrayChecker(myX - 1, myY + 1);
		testArray[6] = new ArrayChecker(myX, myY + 1);
		testArray[7] = new ArrayChecker(myX + 1, myY + 1);					
				
		var spawnChecker:ArrayChecker = new ArrayChecker(0, 0);
		
		for (i in 0...testArray.length)
		{
			if (testArray[i].x < 0 || testArray[i].x > GameGroup.mapSize - 1 || testArray[i].y < 0 || testArray[i].y > GameGroup.mapSize - 1)
			{
				checkArray.push(testArray[i]);		
			}
		}
		
		for (i in 0...checkArray.length)
		{
			testArray.remove(checkArray[i]);
		}
		
		while (checkArray.length > 0)
		{
			checkArray.pop();
		}
		
		var usingCheck:ArrayChecker = testArray[Math.floor(Math.random() * testArray.length)];
		
		for (i in 0...testArray.length)
		{
			testArray[i] = null;
		}
		
		movesLeft -= 1;
		GameGroup.mapAccessArray[usingCheck.x][usingCheck.y].setOccupant(this);						
	}
	
}