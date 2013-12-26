require "YJSearchVC"
require "YJCourseVC"
waxClass{"YJSortListVC",UIViewController,protocols={"UITableViewDataSource","UITableViewDelegate"}}
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
function loadData( self )
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
    local  tab=UITableView:initWithFrame_style(CGRect(0,44,bounds["width"],bounds["height"]-44),UITableViewStylePlain)
    tab:setDelegate(self)
    tab:setDataSource(self)
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
-- DataSource
-------------
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
  local cell = tableView:dequeueReusableCellWithIdentifier(identifier) or
               UITableViewCell:initWithStyle_reuseIdentifier(UITableViewCellStyleSubtitle, identifier)  

  local title = self.dataToShow[indexPath:row() + 1] -- Must +1 because lua arrays are 1 based
  cell:textLabel():setText(title)
  cell:setAccessoryType(UITableViewCellAccessoryDisclosureIndicator)
  cell:imageView():setImage(UIImage:imageWithContentsOfFile(self.path.."/"..title..".png"))
  cell:detailTextLabel():setText(self.path.."/"..title)
  return cell
end
function tableView_didSelectRowAtIndexPath( self, tableView, indexPath )
  local  cell = tableView:cellForRowAtIndexPath(indexPath)
  cell:setSelected_animated(false,true)
  local title = self.dataToShow[indexPath:row() + 1]
  local courseVC = YJCourseVC:init(self.path.."/"..title,title)
  self:navigationController():pushViewController_animated(courseVC,true)
end
function tableView_heightForRowAtIndexPath( self,tableView,indexPath )
  return 60
end