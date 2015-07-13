function extractDomain(url){
    var domain;
    // Remove protocol
    if (url.indexOf("://") > -1){
        domain = url.split('/')[2];
    }
    else {
        domain = url.split('/')[0];
    }

    // Remove port number
    domain = domain.split(':')[0];

    return domain;
}

var i, pair,
    args    = {},
    system  = require('system'),
    page    = require('webpage').create();

for(i = 1; i < system.args.length; i++){
    pair = system.args[i].split(/=(.*)/);
    args[pair[0]] = pair[1];
}

if (args.cookies !== undefined){
    var cookiesPair = args.cookies.split(',');

    for(i = 0; i < cookiesPair.length; i++){
        pair = cookiesPair[i].split(/=(.*)/);

        page.addCookie({
            'name': pair[0],
            'value': pair[1],
            'path': '/',
            'domain': extractDomain(args.url)
        });
    }
}

page.open(args.url, function(){
    window.setTimeout(function(){
        page.viewportSize = { width: args.width, height: args.height };

        if (args.selector !== undefined){
            var clipRect = page.evaluate(function(s){
                return document.querySelector(s).getBoundingClientRect();
            }, args.selector);

            page.clipRect = {
                top:    clipRect.top,
                left:   clipRect.left,
                width:  clipRect.width,
                height: clipRect.height
            };
        }

        page.render(args.output);
        phantom.exit();
    }, args.timeout);
});