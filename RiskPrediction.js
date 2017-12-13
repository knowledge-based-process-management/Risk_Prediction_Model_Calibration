(function(){
	
	var fs = require('fs');
	var exec = require('child_process').exec;
	
	var RExec = '\"C:/Program Files/R/R-3.2.5/bin/Rscript\" ./Rscript/RiskPredication.R ';
	
	var RExec = 'Rscript /Rscript/RiskPredication.R';
	
	function runRiskPredictionModel(dataUrl, callbackfunc){
//		console.log('generate model Analytics');
		console.log(dataUrl);
		var child = exec(RExec+'"'+dataUrl+'"', function(error, stdout, stderr) {

			if (error) {
//				console.log('exec error: ' + error);
				console.log(error);
				if(callbackfunc){
					callbackfunc(false);
				}
			} else {
				fs.readFile("./Temp/risk-prediction-report.txt", 'utf-8', (err, str) => {
					   if (err) throw err;
//					    console.log(data);
					   if(callbackfunc){
						   callbackfunc(str);
					   }
				});
//				if(callbackfunc){
//					callbackfunc("alright");
//				}
			}
		});
	}
	
	module.exports = {
			runRiskPredictionModel: runRiskPredictionModel
	}
})();
