//
//  WebViewScript.swift
//  HB Private Browser
//
//  Created by Benjamin Prentiss on 6/16/23.
//

import WebKit

extension WKUserScript {
    static func hyperBoldScript() -> WKUserScript {
        let script = """
        var elements = document.querySelectorAll('p, em, i, strong, b');
        for (var i = 0; i < elements.length; i++) {
            var words = elements[i].innerText.split(' ');
            for (var j = 0; j < words.length; j++) {
                var length = words[j].length;
                if (length <= 2) {
                    words[j] = '<b>' + words[j] + '</b>';
                } else if (length <= 5) {
                    words[j] = '<b>' + words[j].substring(0, 2) + '</b>' + words[j].substring(2);
                } else if (length <= 7) {
                    words[j] = '<b>' + words[j].substring(0, 3) + '</b>' + words[j].substring(3);
                } else {
                    words[j] = '<b>' + words[j].substring(0, 4) + '</b>' + words[j].substring(4);
                }
            }
            elements[i].innerHTML = words.join(' ');
        }
        """

        return WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
}

