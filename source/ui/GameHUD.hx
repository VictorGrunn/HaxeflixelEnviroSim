package ui;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import maingame.GameGroup;

/**
 * ...
 * @author Victor Grunn
 */
class GameHUD extends FlxGroup
{
	private var statusText:FlxText;
	private var finalText:FlxText;

	public function new() 
	{
		super();
		
		statusText = new FlxText(0, 0, 350);
		statusText.setFormat(null, 12, FlxColor.WHITE, "left");
		add(statusText);				
		
		finalText = new FlxText(0, 0, FlxG.width, "THE LORAX HAS BEEN SLAIN!\nPRESS R TO SPAWN A NEW LORAX!", 30);		
		finalText.setFormat(null, 30, FlxColor.WHITE, "center");
		finalText.draw();
		finalText.y = FlxG.height - finalText.height;
	}
	
	public function updateText():Void
	{
		statusText.text = 
		"Total Wood Gathered Ever: " + GameGroup.TotalWoodEver +
		"\nTotal Wood Gather This Year: " + GameGroup.TotalWoodThisYear +
		"\nTotal Dead Lumberjacks Ever: " + GameGroup.totalDeadLumberjacks +
		"\nTotal Dead Lumberjacks This Year: " + GameGroup.totalDeadLumberjacksThisYear +
		"\nTotal Living Bears: " + GameGroup.totalLivingBears +
		"\nTotal Living Lumberjacks: " + GameGroup.totalLivingLumberjacks +
		"\nTotal Elder Trees Left: " + GameGroup.totalElderTreesLeft +
		"\nTotal Normal Trees Left: " + GameGroup.totalNormalTreesLeft +
		"\nTotal Saplings Left: " + GameGroup.totalSaplingsLeft +
		"\nYear: " + GameGroup.year +
		"\nMonth: " + GameGroup.month;
	}
	
	public function endAnnouncement():Void
	{
		add(finalText);
	}
	
}