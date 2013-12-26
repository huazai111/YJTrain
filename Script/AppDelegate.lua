require "YJMainVC"

waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

function applicationDidFinishLaunching(self, application)
  local frame = UIScreen:mainScreen():bounds()
  self.window = UIWindow:initWithFrame(frame)
  self.window:setBackgroundColor(UIColor:orangeColor())  
  local mainVc = YJMainVC:init()
  self.navigationController = UINavigationController:initWithRootViewController(mainVc)
  self.navigationController:setNavigationBarHidden(1)
  self.window:makeKeyAndVisible()
  self.window:setRootViewController(self.navigationController)
end