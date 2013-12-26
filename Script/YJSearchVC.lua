
waxClass{"YJSearchVC",UIViewController,protocols={"UITableViewDataSource","UITableViewDelegate","UISearchBarDelegate"}}
function createEnumType( enumTab)
  assert(type(enumTab)=="table")
  local enum = {}
  for i=1,#enumTab do
    enum[enumTab[i]]=i
  end
  return enum
end
function init( self )
	self.super:init()
    return self
end
function viewDidLoad( self )
  self.super:viewDidLoad()
  self:view():setBackgroundColor(UIColor:whiteColor())
  typeTab=createEnumType(
  { 
  "ROLE",
  "SORT",
  "COURSE",
  "LESSON"
  })

  dataToShow={}
  createView(self)

end
function createView(self)
  local  bar=UIImageView:initWithImage(UIImage:imageNamed("img_nav_main.png"))
  local  bar_frame=CGRect(0,0,320,44)
  bar:setFrame(bar_frame)
  self:view():addSubview(bar)

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

  searchBar=UISearchBar:initWithFrame(CGRect(0,-44,320,44))
  searchBar:setDelegate(self)
  searchBar:setPlaceholder("请输入要搜索的关键字")
  self:view():addSubview(searchBar)



  local  bounds=self:view():bounds()

  tab=UITableView:initWithFrame_style(CGRect(0,44,bounds["width"],bounds["height"]-44),UITableViewStylePlain)
  tab:setDelegate(self)
  tab:setDataSource(self)
  tab:setBackgroundColor(UIColor:clearColor())
  self:view():addSubview(tab)


  maskView=UIControl:initWithFrame(CGRect(0,44,320,bounds["height"]))
  maskView:setBackgroundColor(UIColor:colorWithRed_green_blue_alpha(.5,.5,.5,.8))
  maskView:setHidden(true)
  maskView:addTarget_action_forControlEvents(self,"hiddenSearchView",UIControlEventTouchUpInside)
  self:view():addSubview(maskView)

  showingSearchView=false

  showSearchView(self)

end
function hiddenSearchView( self )
  searchBar:resignFirstResponder()
  searchBar:setText("")
  searchBar:setShowsCancelButton_animated(false,true)
  maskView:setHidden(true)
  UIView:beginAnimations_context(nil,nil)
  UIView:setAnimationDelegate(self)
  UIView:setAnimationDuration(.25)
  local rect=searchBar:frame()
  rect["y"]=-44
  searchBar:setFrame(rect)
  UIView:commitAnimations()
end
function showSearchView( self )
  searchBar:becomeFirstResponder()
  searchBar:setShowsCancelButton_animated(true,true)
  maskView:setHidden(false)
  UIView:beginAnimations_context(nil,nil)
  UIView:setAnimationDuration(.25)
  local rect=searchBar:frame()
  rect["y"]=0
  searchBar:setFrame(rect)
  UIView:commitAnimations()
end
function searchForKeyword( self,keyword )
  for k,v in pairs(dataToShow) do
    dataToShow[k]=nil
  end
  local  fileManager=NSFileManager:defaultManager()
  local  savaPath=wax.filesystem.savaPath()
  searchForPathAndKeyword(savaPath,keyword,findObj,typeTab.SORT)
  tab:reloadData()
end
function findObj( obj )
  assert(type(obj)=="table")
  table.insert(dataToShow,obj)
end
function searchForPathAndKeyword( path,keyword,findFun,currentType)
  assert(type(findFun)=="function")
  local con =wax.filesystem.contents(path)
  for i=1,#con do
    local  str=tostring(con[i])
    local loc = string.find(str,"DS_Store")
    if loc==nil then 
      if string.find(str,keyword)~=nil or string.find(keyword,str)~=nil then
        local  im_loc = string.find(str,".png")
        if im_loc==nil then
          local obj = {}
          obj["path"]=path.."/"..str
          obj["name"]=str
          obj["type"]=currentType
           findFun(obj)
        end
      end

      if wax.filesystem.isDir(path.."/"..str) then searchForPathAndKeyword(path.."/"..str,keyword,findFun,currentType+1) end
    end
  end
end
function searchBuPressed( self,bu )
  showSearchView(self)
end
function backButtonPressed( self,but )
  self:navigationController():popViewControllerAnimated(true)
end

function searchBarSearchButtonClicked( self,aSearchBar )
  local keyword = deleteWhiteSpace(aSearchBar:text())
  if keyword~=nil and string.len(keyword)~=0 then
    hiddenSearchView()
    searchForKeyword(self,keyword)
  else
    local al = UIAlertView:initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("提示","请填写正确的关键字",nil,"确定",nil)
    al:show()
  end
end
function searchBarCancelButtonClicked( self,aSearchBar )
  hiddenSearchView()
end
function deleteWhiteSpace(s)
        assert(type(s)=="string")
        return string.gsub(s," ","")
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
    cell:setAccessoryType(UITableViewCellAccessoryDisclosureIndicator)
   end
   local obj=dataToShow[indexPath:row()+1]
   cell:textLabel():setText(obj["name"])
   cell:imageView():setImage(UIImage:imageWithContentsOfFile(obj["path"]..".png"))
   return cell
end
function tableView_didSelectRowAtIndexPath( self, tableView, indexPath )
  local  cell = tableView:cellForRowAtIndexPath(indexPath)
  cell:setSelected_animated(false,true)
  local obj=dataToShow[indexPath:row()+1]
  if obj==nil then return end 
  local  vc = nil
  if obj["type"]==typeTab.ROLE then
     vc=YJMainVC:init(obj["path"],obj["name"])
    elseif obj["type"]==typeTab.SORT then 
      vc=YJSortListVC:init(obj["path"],obj["name"])
      elseif obj["type"]==typeTab.COURSE then 
        vc=YJCourseVC:init(obj["path"],obj["name"])
        elseif obj["type"]==typeTab.LESSON then
          vc=YJLessonVC:init(obj["path"],obj["name"])
        end 
  if vc~=nil then self:navigationController():pushViewController_animated(vc,true) end
end