waxClass{"YJWebVC",UIViewController,protocols={"UIWebViewDelegate"}}
function init(self,path)
	self.super:init()
  self.path=path
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
  titleLa:setText("预览")
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
   
   print(self.path)
  local webView = UIWebView:initWithFrame(CGRect(0,44,320,bounds["height"]-44))
  webView:setBackgroundColor(UIColor:blackColor())
  webView:setDelegate(self)
  webView:setScalesPageToFit(true)
  self:view():addSubview(webView)

  local req=NSURLRequest:initWithURL(NSURL:fileURLWithPath(self.path))
  webView:loadRequest(req)

  ac=UIActivityIndicatorView:initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
  ac:startAnimating()
  ac:setCenter(webView:center())
  webView:addSubview(ac)
end
function doneButPressed( self,but )
  self:dismissModalViewControllerAnimated(true)
end

function webViewDidStartLoad(self,webView)
  ac:startAnimating()
end
function webViewDidFinishLoad(self,webView)
  ac:stopAnimating()
end
function webView_didFailLoadWithError(self,webView)
  ac:stopAnimating()
  self:doneButPressed()
end