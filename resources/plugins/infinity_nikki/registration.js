async function importDependentModules(){
  return {
    game: await import("game"),
  };
}

importDependentModules().then(modules => {
  api.registerLoc({
    "zh-CN": "locs/zh-CN.json",
  });

  api.registerIcon([
    "icons/*.webp",
  ]);

  api.registerGame({
    "uuid": "114514",
    "searchGame": modules.game.searchGameInWindows,
  });
});



