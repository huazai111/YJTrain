waxClass{"YJLogin",UIViewController}
function init( self)
	self.super:init()
	return self
end
function viewDidLoad( self )
	self.super:viewDidLoad()
	
    local  bounds=self:view():bounds()
    local bg = UIImageView:initWithFrame(bounds)
    bg:setImage(UIImage:imageNamed("login_bg.png"))
    bg:setBackgroundColor(UIColor:lightGrayColor())
    self:view():addSubview(bg)
end
function touchesEnded_withEvent(self,touches,events)
    self:dismissModalViewControllerAnimated(true)
end