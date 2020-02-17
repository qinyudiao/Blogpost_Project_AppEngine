<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>

<%@ page import="com.google.appengine.api.users.User" %>

<%@ page import="com.google.appengine.api.users.UserService" %>

<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

 

<html>
	
	<head>
		<meta http-equiv="content-type" content="application/xhtml+xml; charset=UTF-8" />
		<title> Austin Food Tours </title>
		<link rel="stylesheet" href="beebyebay.css">
		<style>
		  #p1{
		    color : #21ae08;
		  }
		  #row0{
		    color : #498ef8;
		  }
		  #row1{
		    color : #972e2a;
		  }
		  #row2{
		    color : #b19158;
		  }
		</style>
	</head>
 

  <body>

 

<%

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();

    if (user != null) {

      pageContext.setAttribute("user", user);

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%

    } else {

%>

<p>Hello!

<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

to include your name with greetings you post.</p>

<%

    }

%>

 		<h1> Austin Food Tour </h1>
		<p id="p1">This is a paragraph.</p>
		<p>This is another paragraph.</p>
		<p> Visit <a id="link1" href="https://www.nfl.com">NFL</a> </p>
		<table>
		      <tr>
		        <td colspan="2" style="font-weight:bold;">Available Servlets:</td>        
		      </tr>
		      <tr>
		        <td><a href='/austinFoodTour'>The servlet</a></td>
		      </tr>
		</table>

		<img src="taco1.png" alt="Taco" width="791" height="530">
		
	 <form action="/post" method="post">
	   <div><textarea name="content" rows="3" cols="60"></textarea></div>
	   <div><input type="submit" value="Post" ></div>
	 </form>

  </body>

</html>