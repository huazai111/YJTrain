waxClass{"YJWarnVC",UIViewController}
function init(self)
	self.super:init()
	return self
end
function viewDidLoad( self )
	self.super:viewDidLoad()
	createView(self)
end
function createView( self )

  local  bounds=self:view():bounds()
  local  bar=UIImageView:initWithImage(UIImage:imageNamed("img_nav_main.png"))
  local  bar_frame=CGRect(0,0,320,44)
  bar:setFrame(bar_frame)
  self:view():addSubview(bar)


  local titleLa=UILabel:initWithFrame(CGRect(0,0,320,44))
  titleLa:setText("说明")
  titleLa:setFont(UIFont:boldSystemFontOfSize(20))
  titleLa:setTextColor(UIColor:whiteColor())
  titleLa:setBackgroundColor(UIColor:clearColor())
  titleLa:setTextAlignment(UITextAlignmentCenter)
  bar:addSubview(titleLa)

  local doneBu=UIButton:buttonWithType(UIButtonTypeCustom)
  doneBu:setFrame(CGRect(5,6.5,54,31))
  doneBu:setBackgroundImage_forState(UIImage:imageNamed("bg_but.png"),UIControlStateNormal)
  doneBu:setTitle_forState("完成",UIControlStateNormal)
  doneBu:addTarget_action_forControlEvents(self,"doneButPressed:",UIControlEventTouchUpInside)
  self:view():addSubview(doneBu)
   
  local path = NSBundle:mainBundle():pathForResource_ofType("warn","txt")
  local str = NSString:stringWithContentsOfFile_encoding_error(path,NSUTF8StringEncoding,nil)
  local textView = UITextView:initWithFrame(CGRect(0,44,320,bounds["height"]-44))
  textView:setText(str)
  textView:setEditable(false)
  self:view():addSubview(textView)
end
function doneButPressed( self,but )
  self:dismissModalViewControllerAnimated(true)
end