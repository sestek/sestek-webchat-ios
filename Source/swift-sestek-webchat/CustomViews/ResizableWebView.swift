//
//  ResizableWebView.swift
//  sestek-webchat-ios
//
//  Created by Tolga Taner on 5.02.2023.
//

import UIKit
import WebKit

final class ResizableWebView: WKWebView, WKNavigationDelegate, WKUIDelegate {
    
    var viewSize = CGSize.zero
    var text: String = ""
    var textColor: UIColor = .black
    var currentLanguage: Language = .english
    
    override var intrinsicContentSize: CGSize {
      return self.scrollView.contentSize
    }
    
    init(frame: CGRect, text: String, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.text = text
        setupView()
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        isOpaque = false
        backgroundColor = UIColor.clear
        scrollView.backgroundColor = UIColor.clear
        scrollView.delegate = self
        navigationDelegate = self
        uiDelegate = self
    }
    
    func load() {
        viewSize = CGSize(width: frame.size.width, height: 0)
        invalidateIntrinsicContentSize()
        if let detectedLanguage = text.getDetectedLanguage() {
            currentLanguage = Language(languageCode: detectedLanguage)
            semanticContentAttribute = currentLanguage.semanticContentAttribute
        }
        
        let htmlHeader = "<head><meta name='viewport' content='width=device-width, shrink-to-fit=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><script type='text/javascript' src='https://unpkg.com/showdown/dist/showdown.min.js'></script></head>"
        let htmlScript = "<style>body,html{padding:0!important}html,body,p{font-family:'-apple-system-body',Arial!important;font-size:13px!important;color:\(textColor.hexString ?? "#000000")}body{display: block; margin-top:1em; margin-bottom:1em; margin-left:0; margin-right:0; line-height:24px!important} body{margin:0 20px!important}iframe{width:100%!important;min-height:200px!important} ul.recipeList{padding:0 30px!important;margin:0 0 20px!important}ul.recipeList>a{font-size:15px!important;color:#4f4ff3!important;text-decoration:none!important;font-weight:700}p.wp-caption-text a{font-size:12px!important;color:#979797!important;font-weight:400;letter-spacing:-.27px}div.imageNoMargin>img,img.img-responsive.contentLazy,img.size-full,img.size-large,img.size-medium{height:auto!important;width:calc(100% + 40px)!important;margin:10px -20px 0!important}div.alignnone,div.wp-caption{max-width:100%!important;width:100%!important}</style><script>var stopVideo = function ( element ) {var iframe = element.querySelector( ‘iframe’);var video = element.querySelector( ‘video’ );if ( iframe ) {var iframeSrc = iframe.src;iframe.src = iframeSrc;}if ( video ) {video.pause();}};</script><style> table { background: #fff; border: solid 1px #ddd; margin-bottom: 1.25rem; table-layout: auto; } table thead { background: #F5F5F5; } table thead tr th, table tfoot tr th, table tfoot tr td, table tbody tr th, table tbody tr td, table tr td { display: table-cell; line-height: 1.125rem; padding: 10px; } img { width: 100%; } table tr.even, table tr.alt, table tr:nth-of-type(even) { background: #F9F9F9; }</style> <style> h1 { display: block; font-size: 2em; margin-top: 0.67em; margin-bottom: 0.67em; margin-left: 0; margin-right: 0; font-weight: bold;} h2 { display: block; font-size: 1.5em; margin-top: 0.83em; margin-bottom: 0.83em; margin-left: 0; margin-right: 0; font-weight: bold;} h3 { display: block; font-size: 1.17em; margin-top: 1em; margin-bottom: 1em; margin-left: 0; margin-right: 0; font-weight: bold; } h4 { display: block; margin-top: 1.33em; margin-bottom: 1.33em; margin-left: 0; margin-right: 0; font-weight: bold; } h5 { display: block; font-size: .83em; margin-top: 1.67em; margin-bottom: 1.67em; margin-left: 0; margin-right: 0; font-weight: bold; } h6 { display: block; font-size: .67em; margin-top: 2.33em; margin-bottom: 2.33em; margin-left: 0; margin-right: 0; </style> <style> code {font-family:'-apple-system-body',Arial!important;color: #000000;font-weight: bold;background-color: #DDDDDD;padding: 2px;}pre {font-family:'-apple-system-body',Arial!important;background-color: #DDDDDD;display: block;} </style><style> ol {margin:0 0 1.5em;padding:0;counter-reset:item;}ol>li {margin:0;padding:0 0 0 2em;text-indent:-2em;list-style-type:none;counter-increment:item;}ol>li:before {display:inline-block;width:1.5em;padding-right:0.5em;font-weight:bold;text-align:right;content:counter(item) \".\";} ol + ul {margin-top: -20px;margin-bottom: 0px;}</style> <style> blockquote p { margin: 0; font-size:10px; display:inline; color: #ccc;} blockquote {color: #A0A09F; width:50% ;background: #FCFBF7; border-left: 2px solid #ccc; margin: 0em 0px; padding: 0.5em 10px; display: block;} blockquote:before { color: #ccc; font-size: 4em; line-height: 0.1em; margin-right: 0.25em; vertical-align: -0.4em;} ol {margin:0 0 1.5em; padding:0; counter-reset:item;} </style> <style>  s {text-decoration: line-through;} em { font-style:italic;} strong {font-weight: bold;} p{display: block; margin-top:1em; margin-bottom:1em; margin-left:0; margin-right:0;}  p > em{white-space: pre;} h1,h2,h3,h4,h5,h6,blockquote,code,em,bold,p,pre,a,ol,li,ul,hr {text-align: \(currentLanguage.textAlignmentValue);} hr {background-color:#FCFBF7}</style>"
                
        let htmlChanged = "<html dir=\"\(currentLanguage.semanticValue)\"\(htmlHeader)\(htmlScript)<body></body></html>"
        loadHTMLString(htmlChanged, baseURL: URL(string: "https://unpkg.com"))
    }
    
     func updateViewSize(height: CGFloat) {
        viewSize = CGSize(width: frame.size.width, height: height)
        self.invalidateIntrinsicContentSize()
    }
    
    deinit {
        scrollView.delegate = nil
        navigationDelegate = nil
    }
}

extension ResizableWebView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
func makeContentController(css: String?,
                           plugins: [String]?,
                           stylesheets: [URL]?,
                           markdown: String?,
                           enableImage: Bool?) -> WKUserContentController {
  let controller = WKUserContentController()
  
  if let _ = css {
    let styleInjection = WKUserScript(source: "styleScript(css)", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    controller.addUserScript(styleInjection)
  }
  
  plugins?.forEach({ plugin in
    let scriptInjection = WKUserScript(source: "usePluginScript(plugin)", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    controller.addUserScript(scriptInjection)
  })
  
  stylesheets?.forEach({ url in
    let linkInjection = WKUserScript(source: "linkScript(url)", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    controller.addUserScript(linkInjection)
  })
  
  if let markdown = markdown {
    let escapedMarkdown = markdown
    let imageOption = (enableImage ?? true) ? "true" : "false"
    let script = "window.showMarkdown('\(escapedMarkdown)', \(imageOption));"
    let userScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    controller.addUserScript(userScript)
  }    
  return controller
}
