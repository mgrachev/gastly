function extractDomain(url){
  var domain;
  // Remove protocol
  if (url.indexOf("://") > -1) {
      domain = url.split('/')[2];
  } else {
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

system.args.forEach(function(arg) {
  pair = arg.split(/=(.*)/);
  args[pair[0]] = pair[1];
});

if (args.cookies !== undefined) {
  var cookiesPair = args.cookies.split(',');

  cookiesPair.forEach(function(cookie) {
    pair = cookie.split(/=(.*)/);

    page.addCookie({
      'name': pair[0],
      'value': pair[1],
      'path': '/',
      'domain': extractDomain(args.url)
    });
  });
}

phantom.onError = function(message, trace){
  var messageStack = ['RuntimeError:' + message];

  if (trace && trace.length) {
    messageStack.push('Trace:');

    trace.forEach(function(t) {
        messageStack.push(' -> ' + t.file + ': ' + t.line + (t.function ? ' (in function "' + t.function +'")' : ''));
    });
  }

  console.log(messageStack.join('\n'));
  phantom.exit(1);
}

// Suppress client errors
page.onError = function(message, trace){
};

page.open(args.url, function(status){
  if(status !== 'success') {
    console.log('FetchError:' + args.url);
    phantom.exit();
  } else {
    window.setTimeout(function(){
      page.viewportSize = { width: args.width, height: args.height };

      if (args.selector !== undefined){
        // Returns ClientRect object or null if selector not found
        var clipRect = page.evaluate(function(s){
          var result, selector = document.querySelector(s);

          if (selector !== null) {
            result = selector.getBoundingClientRect();
          }

          return result;
        }, args.selector);

        if (clipRect !== null) {
          page.clipRect = {
            top:    clipRect.top,
            left:   clipRect.left,
            width:  clipRect.width,
            height: clipRect.height
          };
        }
      }

      page.render(args.output);
      phantom.exit();
    }, args.timeout);
  }
});
