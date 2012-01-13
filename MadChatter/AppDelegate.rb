
framework "WebKit"
framework "Growl"

class AppDelegate
    attr_accessor :window, :config
    
    def applicationDidFinishLaunching(notification)
        config_path = NSBundle.mainBundle.pathForResource('AppConfig', ofType: 'plist')
        @config = load_plist File.read(config_path)
        load_growl
        load_web_view
    end
    
    def load_growl
        GrowlApplicationBridge.setGrowlDelegate(self)
    end
    
    def load_web_view
        web_view = WebView.new
        request = NSURLRequest.requestWithURL(NSURL.URLWithString(@config['homepage']))
        web_view.mainFrame.loadRequest(request)
        
        web_view.setContinuousSpellCheckingEnabled(true)
        
        web_view.frameLoadDelegate = self
        web_view.policyDelegate = self
        window.contentView = web_view
    end
    
    def webView(view, didFinishLoadForFrame:frame)
        growl_wrapper = MadChatterGrowl.new
        growl_wrapper.respondsToSelector("send:")        
        windowScriptObject = view.windowScriptObject
        windowScriptObject.setValue(growl_wrapper, forKey: "MadChatterGrowl")
    end
    
    # this makes it so links open in the default browser
    def webView(view, decidePolicyForNewWindowAction:actionInformation, request:request, newFrameName:frameName, decisionListener:listener)
        NSWorkspace.sharedWorkspace.openURL(request.URL)
        listener.ignore
    end
end

class MadChatterGrowl
    def send(title, message)
        application = NSApplication.sharedApplication
        unless application.isActive
            GrowlApplicationBridge.notifyWithTitle(
                                                   title,
                                                   description: message,
                                                   notificationName: "MadChatterGrowlNotification",
                                                   iconData: nil,
                                                   priority: 0,
                                                   isSticky: false,
                                                   clickContext: nil
                                                   )
        end
    end
    
    def self.isSelectorExcludedFromWebScript(sel); false end
end
