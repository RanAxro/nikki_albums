
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
    "searchGame": function(){
      let wr = api.windowsRegistry;
      let path = wr.readString(wr.HKEY_CURRENT_USER, "Software\\InfinityNikki Launcher", "");
      return [
        {
          info: {
            channel: "paper",
            testf: modules.game.imtf(),
          },
          install_path: path,
        },
      ];
    }
  });
});



