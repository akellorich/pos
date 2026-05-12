$(document).ready(function(){	
	const clearDB=$("#emptydata")
	const closeerror=$("#closeerror")
	const closesuccess=$("#closesuccess")
	const logoutuser=$("#signout")
	const username=$("#username")
	const useravatar=$("#portrait")
	getloggedinuser()

	function getloggedinuser(){
		$.getJSON(
			"../../controllers/useroperations.php",
			{
				getloggedinuserdetails:true
			},
			(data)=>{
				console.log(data)
				if(data['status']=='success'){
					username.html(data['username'])
					useravatar.attr("src",data['userimage'])
				}
			}
		)
	}
	

	clearDB.on("click",function(){		
		DbConnection.dropDb(function (){
			displaySuccess("<p>Local database updated successfully.</p>")
		},
		function (error) {
			displayError("<p>"+results+"</p>")
		});
	})
	
	// close error dialog box
	closeerror.on("click",function(){
		window.history.back()
	})

	closesuccess.on("click",function(){
		window.location.href="main.php"
	})
	
	function displayError(errorString){
		//alert ("an error exists")
		var errorsanchor=$("#errorsdisplay")
		var errorposition=$("#errormessage")			
		errorposition.find("p").remove()
		$(errorString).appendTo(errorposition)
		//console.log(errorsanchor.attr("href"))
		errorsanchor.click()
	}

	function displaySuccess(successString){
		//alert ("an error exists")
		var successanchor=$("#successdisplay")
		var successposition=$("#successmessage")			
		successposition.find("p").remove()
		$(successString).appendTo(successposition)
		//console.log(errorsanchor.attr("href"))
		successanchor.click()
	}
})
