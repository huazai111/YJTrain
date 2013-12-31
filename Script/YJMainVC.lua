
require "YJSortListVC"
require "YJSearchVC"
require "YJWarnVC"
require "YJLogin"
waxClass{"YJMainVC",UIViewController,protocols={"UIAlertViewDelegate"}}
function viewDidLoad(self)
	self.super:viewDidLoad()
	self:view():setBackgroundColor(UIColor:whiteColor());
	showLoginEnd=false;
	createView(self)
end
function init(self)
	self.super:init()
	self:setTitle("主界面")
	return self
end
function viewWillAppear( self,animation )
	self.super:viewWillAppear(animation)
	if not showLoginEnd then showLoginVC(self) showLoginEnd=true end
end
function showLoginVC( self )
	local vc=YJLogin:init(path)
	self:presentModalViewController_animated(vc,true)
end
function createView( self )
	
	titleArr={}
	local  bounds=self:view():bounds()
	

	sc=UIScrollView:initWithFrame(CGRect(0,44,bounds["width"],bounds["height"]-44))
	--sc:setBackgroundColor(UIColor:colorWithRed_green_blue_alpha(1,0,0,.5))
	self:view():addSubview(sc)

	local  bar=UIImageView:initWithImage(UIImage:imageNamed("img_nav_main.png"))
	local  bar_frame=CGRect(0,0,320,44)
	--bar:setBackgroundColor(UIColor:colorWithRed_green_blue_alpha(.5,.5,1,.5))
	bar:setFrame(bar_frame)
	self:view():addSubview(bar)

	local infoBu=UIButton:buttonWithType(UIButtonTypeInfoLight)
	infoBu:setFrame(CGRect(0,0,44,44))
	infoBu:addTarget_action_forControlEvents(self,"infoBuPressed",UIControlEventTouchUpInside)
	--self:view():addSubview(infoBu)

	local searchBu=UIButton:buttonWithType(UIButtonTypeCustom)
	searchBu:setFrame(CGRect(250,6.5,54,31))
	searchBu:setBackgroundImage_forState(UIImage:imageNamed("bg_but.png"),UIControlStateNormal)
	searchBu:setTitle_forState("搜索",UIControlStateNormal)
	searchBu:addTarget_action_forControlEvents(self,"searchBuPressed:",UIControlEventTouchUpInside)
	self:view():addSubview(searchBu)
	
	local  fileManager=NSFileManager:defaultManager()
	savaPath=wax.filesystem.savaPath()
	local con =wax.filesystem.contents(savaPath)


    local index = 0
    self.conHeight=0
	for i=1,#con do
		local  str=tostring(con[i])
		local loc = string.find(str,"DS_Store")
		if loc==nil then 
			local  path = savaPath.."/"..str
			if wax.filesystem.isDir(path) then
			   createItem(self,str,index)
			   index=index+1
		    end
		end
	end

	if self.conHeight>bounds["height"]-44 then
		sc:setContentSize(CGSize(bounds["width"],self.conHeight))
		end
		
end
function infoBuPressed( self )
	local vc = YJWarnVC:init()
	self:presentModalViewController_animated(vc,true)
end
function searchBuPressed( self,bu )
	local search = YJSearchVC:init()
	self:navigationController():pushViewController_animated(search,true)
end
function createItem( self,title,index )
	local b_rect = self:view():bounds()
	local w_t = b_rect["width"]
	local h_t = b_rect["height"]
      

	local c = 2
	local w = 100
	local h = 100

	local x_s = (w_t-c*w)/(c+1)
	local y_s = 30

	local curr_y = 44+20+(y_s+h)*(math.modf(index/2))--取整

	local x = (index%c+1)*x_s+(index%c)*w
	local y = curr_y

	local bu=UIButton:buttonWithType(UIButtonTypeCustom)
	bu:setFrame(CGRect(x,y,w,h))
	bu:setTag(index)
	local bg_but = UIImage:imageWithContentsOfFile(savaPath.."/"..title..".png")
	if bg_but~=nil then
		bu:setBackgroundImage_forState(bg_but,UIControlStateNormal)
	else
		bu:setBackgroundColor(UIColor:colorWithRed_green_blue_alpha(.5,.5,1,.5))
	    bu:setTitle_forState(title,UIControlStateNormal)
	end
	bu:setTag(index)
	bu:addTarget_action_forControlEvents(self,"buttonPressed:",UIControlEventTouchUpInside)
	sc:addSubview(bu)

	titleArr[index]=title
	self.conHeight=curr_y+h+20
end
function buttonPressed( self,but )
	local currentPath = wax.filesystem.savaPath()
	local title = titleArr[but:tag()]
	local list = YJSortListVC:init(currentPath.."/"..title,title)
	self:navigationController():pushViewController_animated(list,true)
end