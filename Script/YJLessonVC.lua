require "YJSearchVC"
require "YJWebVC"
waxClass{"YJLessonVC",UIViewController}

function init( self,path,ti )
	self.super:init()
    title=ti
	self.path=path
	return self
end
function viewDidLoad( self )
	self.super:viewDidLoad()
	self:view():setBackgroundColor(UIColor:lightGrayColor())
    self.dataToShow={}

    

    loadData(self)
    count=#self.dataToShow
    beginY=20
    item_heght=44
    conHeight=beginY+count*item_heght
	createView(self)
end

function createView(self)

    local  bounds=self:view():bounds()
    sc=UIScrollView:initWithFrame(CGRect(0,44,bounds["width"],bounds["height"]-44))
	self:view():addSubview(sc)


	local  bar=UIImageView:initWithImage(UIImage:imageNamed("img_nav_main.png"))
	local  bar_frame=CGRect(0,0,320,44)
	bar:setFrame(bar_frame)
	self:view():addSubview(bar)

	local titleLa=UILabel:initWithFrame(CGRect(0,0,320,44))
    titleLa:setText(title)
    titleLa:setFont(UIFont:boldSystemFontOfSize(20))
    titleLa:setTextColor(UIColor:whiteColor())
    titleLa:setBackgroundColor(UIColor:clearColor())
    titleLa:setTextAlignment(UITextAlignmentCenter)
    bar:addSubview(titleLa)

    local backBut=UIButton:buttonWithType(UIButtonTypeCustom)
    backBut:setFrame(CGRect(5, 7, 52, 31))
    backBut:setImage_forState(UIImage:imageNamed("back.png"),UIControlStateNormal)
    backBut:addTarget_action_forControlEvents(self,"backButtonPressed:",UIControlEventTouchUpInside)
    self:view():addSubview(backBut)

    local searchBu=UIButton:buttonWithType(UIButtonTypeCustom)
    searchBu:setFrame(CGRect(250,6.5,54,31))
    searchBu:setBackgroundImage_forState(UIImage:imageNamed("bg_but.png"),UIControlStateNormal)
    searchBu:setTitle_forState("搜索",UIControlStateNormal)
    searchBu:addTarget_action_forControlEvents(self,"searchBuPressed:",UIControlEventTouchUpInside)
    self:view():addSubview(searchBu)

  
    for i=1,count do
    	local bu = UIButton:buttonWithType(UIButtonTypeCustom)
		bu:setBackgroundColor(UIColor:whiteColor())
		bu:setTag(i)
		bu:setFrame(CGRect(0,(tonumber(i)-1)*item_heght+20,320,item_heght))
		bu:addTarget_action_forControlEvents(self,"cellPressed:",UIControlEventTouchUpInside)
		bu:layer():setShadowOffset(CGSize(0,1))
		bu:layer():setShadowColor(UIColor:blackColor():CGColor())
		bu:layer():setShadowRadius(math.pi/2)
		bu:layer():setShadowOpacity(.8)


		local flagIm = UIImageView:initWithFrame(CGRect(300,15,10,14))
		flagIm:setImage(UIImage:imageNamed("flag.png"))
		flagIm:setTag(1000)--表示想不懂  tag怎么会和but的冲突  相当鄙视 只有设置个很大的值喽，如果图片数目超过500  有bug哦  嘎嘎。。。。
		bu:addSubview(flagIm)

		sc:addSubview(bu)


		local im = UIImageView:initWithFrame(CGRect(5,2,40,40))
		local imPath = self.path.."/"..i..".png"
		im:setImage(UIImage:imageWithContentsOfFile(imPath))
		bu:addSubview(im)

		local nameLa = UILabel:initWithFrame(CGRect(50, 0, 240, 44))
		nameLa:setBackgroundColor(UIColor:clearColor())
		nameLa:setText((self.dataToShow[i])["name"])
		nameLa:setFont(UIFont:systemFontOfSize(15))
		bu:addSubview(nameLa)
    end
    setUpScConSize(self)

end
function searchBuPressed( self,bu )
  local search = YJSearchVC:init()
  self:navigationController():pushViewController_animated(search,true)
end
function setUpScConSize( self )
	local rect = sc:frame();
	local sc_height = rect["height"]
	local sc_width = rect["width"]
	if conHeight>sc_height then
		sc:setContentSize(CGSize(sc_width,conHeight))
		else
			sc:setContentSize(CGSize(sc_width,sc_height))
	end
end

function cellPressed( self,but )

	local obj = self.dataToShow[but:tag()]
	local rect = but:frame()
	obj["select"]=not obj["select"]
	if obj["select"] then

		local flagIm = but:viewWithTag(1000)
		flagIm:setTransform(wax.CGTransform.transformMakeRotation(math.pi/2))

		local path = self.path.."/"..but:tag().."_"..obj["name"]..".png"
		local  img = UIImage:imageWithContentsOfFile(path)
		local size = img:size()
		local im_w = size["width"]
		local im_h = size["height"]

		local  height = 0
		local im_rect= CGRect(0,0,0,0)
		local y=rect["y"]+rect["height"]
		if im_w>320 then
			local scale = 320/im_w;
			height = im_h*scale;
			im_rect=CGRect(0,y,320,height)
		else
			height=im_h
			local x = (320-im_w)/2
			im_rect=CGRect(x,y,im_w,height)
			end

			local im = UIImageView:initWithFrame(im_rect)
			im:setImage(img)
			im:setUserInteractionEnabled(true)
			im:setTag(count+but:tag())
			sc:addSubview(im)

			local tap = UITapGestureRecognizer:initWithTarget_action(self,"tapImageActive:")
			im:addGestureRecognizer(tap)



			conHeight=conHeight+height
			for i=but:tag()+1,count do
				local bu = sc:viewWithTag(i)
				local frame = bu:frame()
				frame["y"]=frame["y"]+height
				bu:setFrame(frame)

				local bu_im = sc:viewWithTag(i+count)
				if bu_im~=nil then 
					local im_rect = bu_im:frame()
					im_rect["y"]=im_rect["y"]+height
					bu_im:setFrame(im_rect)
				end
			end

		else
			local flagIm = but:viewWithTag(1000)
		    flagIm:setTransform(wax.CGTransform.identity())

			local but_im = sc:viewWithTag(but:tag()+count)
			if but_im~=nil then
				local im_h = but_im:frame()["height"]
				but_im:removeFromSuperview()
				conHeight=conHeight-im_h
				for i=but:tag()+1,count do
					local bu = sc:viewWithTag(i)
				    local frame = bu:frame()
				    frame["y"]=frame["y"]-im_h
				    bu:setFrame(frame)

				    local bu_im = sc:viewWithTag(i+count)
				    if bu_im~=nil then 
					local im_rect = bu_im:frame()
					im_rect["y"]=im_rect["y"]-im_h
					bu_im:setFrame(im_rect)
				end
				end
			end

		end
		setUpScConSize(self)
end
function tapImageActive( self,tapGes )
	local index = tapGes:view():tag()-count
	local obj = self.dataToShow[index]
	local path = self.path.."/"..index.."_"..obj["name"]..".png"
	local vc=YJWebVC:init(path)
	self:presentModalViewController_animated(vc,true)
end
function backButtonPressed( self,but )
  self:navigationController():popViewControllerAnimated(true)
end
function loadData(self)
  local  fileManager=NSFileManager:defaultManager()
  local con =wax.filesystem.contents(self.path)
  if con==nil then return end
  for k,v in pairs(con) do
    local  str=tostring(v)
    local loc = string.find(str,"DS_Store")
    if loc==nil then 
      isDir=wax.filesystem.isDir(self.path.."/"..str)
      if isDir then
        else
        	handleWithFileName(self,str)
      end
    end
  end
end
function handleWithFileName( self,fileName )
	local loc = string.find(fileName,"_")
	if loc~=nil then
		local key = string.sub(fileName,1,loc-1)
		local value = string.sub(fileName,loc+1,string.len(fileName)-4)
		local obj = {}
		obj["name"]=value
		obj["select"]=false
		table.insert(self.dataToShow,tonumber(key),obj)
		end
end