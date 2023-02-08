//
//  ChatbotView.swift
//  sestek-webchat-ios
//
//  Created by Tolga Taner on 5.02.2023.
//

import UIKit
import Down
import WebKit

protocol ChatbotViewDelegate: AnyObject {
    func contentDidLoad()
    func webViewDidLoad()
    func urlDidTapped(_ url: URL)
}

final class ChatbotView: UIView {
    
    lazy var webView: ResizableWebView = ResizableWebView()
    private weak var delegate: ChatbotViewDelegate?
    let text: String
    let id: String
    var html = String()
    var down: Down!
    var height: CGFloat = .zero
    
    init(id: String, text: String, delegate: ChatbotViewDelegate) {
        self.delegate = delegate
        self.text = text
        self.id = id
        super.init(frame: .zero)
        defer {
            setup()
        }
    }
    
    func load() {
        webView.load()
    }
    
    private func configureWebView() {
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.isOpaque = false
        backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
  
    private func setup() {
        down = Down(markdownString: text)
        do {
            html = try down.toHTML().convertStrikethrough().setURLTag()
        } catch {
            html = text.convertStrikethrough().setURLTag()
        }
        let vc = makeContentController(css: nil, plugins: nil, stylesheets: nil, markdown: text, enableImage: true)
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = vc

        webView = ResizableWebView(frame: CGRect.zero, text: html, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)
        NSLayoutConstraint.activate([
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        configureWebView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func verifyUrl(urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }

}
//MARK: - WKNavigationDelegate, WKUIDelegate
extension ChatbotView: WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url != nil,
           let url = navigationAction.request.url,
           url.absoluteString != "https://unpkg.com/",
           UIApplication.shared.canOpenURL(url) {
            delegate?.urlDidTapped(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("var converter = new showdown.Converter(), text = '\(html.replacingOccurrences(of: "\n", with: "\\n").replacingOccurrences(of: "<p>|", with: " |").replacingOccurrences(of: "|<p>", with: "| "))'; converter.setOption('tables', true); document.body.innerHTML = converter.makeHtml(text);", completionHandler: { (_, error) in
            webView.evaluateJavaScript("document.readyState", completionHandler: { [weak self] (complete, error) in
                guard let self = self else { return }
                if complete != nil {
                    self.height = 1
                    self.delegate?.webViewDidLoad()
                    webView.evaluateJavaScript("Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)", completionHandler: { (height, error) in
                        if let height = height as? CGFloat {
                            self.height = height
                            webView.invalidateIntrinsicContentSize()
                        }
                        self.delegate?.contentDidLoad()
                    })
                }
            })
        })
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
