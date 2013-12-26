require "YJLessonVC"
require "YJSearchVC"
waxClass{"YJCourseVC",UIViewController,protocols={"UITableViewDataSource","UITableViewDelegate"}}
function init( self,path,ti )
  self.super:init()
  title=ti
  self.path=path
  return self
end
function viewDidLoad( self )
  self.super:viewDidLoad()
  self:view():setBackgroundColor(UIColor:whiteColor())
    self.dataToShow={}
    loadData(self)
  createView(self)
end
function loadData(self)
  self.bgImgTable={"cardBg0.png","cardBg1.png"};

  local  fileManager=NSFileManager:defaultManager()
  local con =wax.filesystem.contents(self.path)
  local index = 1
  for k,v in pairs(con) do
    local  str=tostring(v)
    local loc = string.find(str,"DS_Store")
    if loc==nil then 
      isDir=wax.filesystem.isDir(self.path.."/"..str)
      if isDir then
        self.dataToShow[index]=str
        index=index+1
      end
    end
  end
end
function createView( self )

  local  bounds=self:view():bounds()
  local  tab=UITableView:initWithFrame_style(CGRect(0,50,bounds["width"],bounds["height"]-50),UITableViewStylePlain)
    tab:setDelegate(self)
    tab:setDataSource(self)
    tab:setBackgroundColor(UIColor:clearColor())
    tab:setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self:view():addSubview(tab)

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
end
function searchBuPressed( self,bu )
  local search = YJSearchVC:init()
  self:navigationController():pushViewController_animated(search,true)
end
function backButtonPressed( self,but )
  self:navigationController():popViewControllerAnimated(true)
end

function numberOfSectionsInTableView(self, tableView)
  return 1
end

function tableView_numberOfRowsInSection(self, tableView, section)
  if self.dataToShow then
    return #self.dataToShow
  else
    return 0
  end
end

function tableView_cellForRowAtIndexPath(self, tableView, indexPath)  
  local identifier = "TwitterTableViewControllerCell"
  local cell = tableView:dequeueReusableCellWithIdentifier(identifier)
                
   if(cell==nil)then
    cell=UITableViewCell:initWithStyle_reuseIdentifier(UITableViewCellStyleDefault, identifier) 
    local bgIm = UIImageView:initWithFrame(CGRect(10,0,300,70))
    bgIm:setTag(1)
    cell:addSubview(bgIm)

    local nameLa = UILabel:initWithFrame(CGRect(108, 35, 192, 21))
    nameLa:setTag(2)
    nameLa:setFont(UIFont:systemFontOfSize(15))
    nameLa:setBackgroundColor(UIColor:clearColor())
    cell:addSubview(nameLa)

    local courseIm = UIImageView:initWithFrame(CGRect(25, 19, 45, 45))
    courseIm:setTag(3)
    cell:addSubview(courseIm)
    
    cell:setBackgroundColor(UIColor:clearColor())
    cell:setSelectionStyle(UITableViewCellSelectionStyleNone)
   end    

  local bgIm = cell:viewWithTag(1)
  local nameLa = cell:viewWithTag(2)
  local courseIm = cell:viewWithTag(3)      
  local title = self.dataToShow[indexPath:row() + 1] -- Must +1 because lua arrays are 1 based
  local bgTitle = self.bgImgTable[indexPath:row()%(#self.bgImgTable)+1]
  bgIm:setImage(UIImage:imageNamed(bgTitle))
  nameLa:setText(title)
  courseIm:setImage(UIImage:imageWithContentsOfFile(self.path.."/"..title..".png"))
  return cell
end
function tableView_didSelectRowAtIndexPath( self, tableView, indexPath )
  local  cell = tableView:cellForRowAtIndexPath(indexPath)
  cell:setSelected_animated(false,true)
  local title = self.dataToShow[indexPath:row() + 1]
  local lessonVC = YJLessonVC:init(self.path.."/"..title,title)
  self:navigationController():pushViewController_animated(lessonVC,true)
end
function tableView_heightForRowAtIndexPath( self,tableView,indexPath )
  return 70
end