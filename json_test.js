var http = require('http') ;
var url = require('url') ;
var fs = require('fs') ;

var user = {
    username : 'paciffic',
    email : 'paciffic@gmail.com',
    firstName : 'Hyunwoo',
    lastName : 'Han'
};

var userString = JSON.stringify(user) ;

var headers = {
    'Content-Type' : 'application/json',
    'Content-Length' : userString.length
} ;

var options = {
    host : 'localhost',
    port : 8888,
    path : '/test',
    method : 'POST',
    headers : headers
};

var server = http.createServer(function (req, res) {
    var pathname = url.parse(req.url).pathname ;
    var writeStream = fs.createWriteStream('./json_request.log');
    
    //console.log("Request for " + pathname + " received.") ;
    if (pathname == "/get")
    {
        var responseString = '' ;
        console.log(pathname + " is requested!!")
        //console.log("/get is requested!!") ;

	req.on('data', function(data) {
	  //responseString = JSON.parse(data);
      
      writeStream.write(data)
      //console.log(writeStream)
        });

        //console.log(responseString)

        req.on('end', function() {
          //console.log("username " + responseString.username)
        });

	//console.log(req.body) ;
	//console.log(req) ;

    }
    else if (pathname == "/send")
    {
        console.log(pathname + " is requested!!")
    	res.setHeader( 'Content-Type' , 'application/json') ;
    	res.write(userString) ;
    	//console.log(res) ;
    	res.end() ;
    }
}).listen(8888) ;

console.log('Server running at http://localhost:8888/') ;
