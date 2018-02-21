var express = require('express');
var app = express();
var fs = require("fs");
var multer = require('multer');
//var jade = require('jade');
var bodyParser = require('body-parser');
var riskPrediction = require('./RiskPrediction.js');

var storage = multer.diskStorage({
    destination: function (req, file, cb) {
	var date = new Date();
    var uploadDate = date.getFullYear() + "-" + date.getMonth()+ "-" + date.getDate();
    var fileDestination = 'public/uploads/'+uploadDate+"@"+Date.now()+"/";
    var stat = null;
    try {
	        stat = fs.statSync(fileDestination);
	    } catch (err) {
	        fs.mkdirSync(fileDestination);
	    }
	    if (stat && !stat.isDirectory()) {
	        throw new Error('Directory cannot be created because an inode of a different type exists at "' + dest + '"');
	    }
        cb(null, fileDestination);
    }
})


var upload = multer({ storage: storage });

app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: true }));


app.set('views', './views');
app.set('view engine', 'jade');

var modelInfo = {};

app.post('/predictRiskLevel', upload.fields([{name:'project-data-file',maxCount:1}]), function (req, res){
	console.log(req.body);
	var projectDataFilePath = req.files['project-data-file'][0].path;
	riskPrediction.runRiskPredictionModel(projectDataFilePath , function(result){
		res.end(JSON.stringify(result));
//		res.end(result);
	});
});


//app.get('/predictRiskLevel', function (req, res){
//	console.log(req.body);
//	var projectDataFilePath = req.files['project-data-file'][0].path;
//	riskPrediction.runRiskPredictionModel(projectDataFilePath , function(result){
//		res.end(result);
//	});
//});


//to handle post redirect to home page
app.post('/', function(req, res){
	res.redirect('/')
});

app.get('/', function(req, res){
	res.render('index');
});

var server = app.listen(8081,'127.0.0.1', function () {
  var host = server.address().address
  var port = server.address().port
  console.log("Example app listening at http://%s:%s", host, port)

})

