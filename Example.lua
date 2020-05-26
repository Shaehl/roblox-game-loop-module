local Game = require(game.ServerStorage.GameTemplate).new()

function Game:GameStart()
	Game:Message("Let's go!")
	Game.Plays = (Game.Plays or 0)+1
end

function Game:GameEnd()
	Game:Message("Round ended.")
	print("Plays made "..Game.Plays)
  wait(1)
end

coroutine.resume(Game.Loop)
