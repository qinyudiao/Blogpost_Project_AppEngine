<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>

<html>
	<head>
		<meta http-equiv="content-type" content="application/xhtml+xml; charset=UTF-8" />
		<link rel="stylesheet" href="beebyebay.css">
		<style>
		  #p1{
		    color : #21ae08;
		  }
		</style>
	</head>
  <body>
  
  <img src="AustinFoodTour_title.jpeg" alt="Title" width="100%">
	
<%
    String bloggerName = request.getParameter("bloggerName");

    if (bloggerName == null) {
        bloggerName = "austinfoodtour";
    }

    pageContext.setAttribute("bloggerName", bloggerName);
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
to post your blog.</p>
<%
    }
%>

	<div>
		<button onclick="popUpEmailSubPrompt()">Subscribe</button>
		<button onclick="popUpEmailUnsubPrompt()">Unsubscribe</button>
		<p id="sub"></p>
	</div>
	
	<script>
		function popUpEmailSubPrompt() {
		  var txt;
		  var emailAddress = prompt("You will receive an email at 5pm central time everyday" + 
				  "\nif there are any new posts in the past 24 hours" +
				  "\nPlease enter your email address to subcribe:", "address@example.com");
		  if (emailAddress == null || emailAddress == "") {
			  
		  } else {
		    txt = "Welcome, " + emailAddress + "! Your are subscribed";
		    document.getElementById("sub").innerHTML = txt;
		  }
		}
	</script>
	<script>
		function popUpEmailUnsubPrompt() {
		  var txt;
		  var emailAddress = prompt("Please enter your email address to unsubscribe:", "address@example.com");
		}
	</script>
			
		<p style="text-align:center;"><img src="taco1.png" alt="Taco" width="300" height="200" alt="centered image"></p> 

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key blogKey = KeyFactory.createKey("Blog", bloggerName);

    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.

    Query query = new Query("Thread", blogKey).addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> posts = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));

    if (posts.isEmpty()) {
        %>
        <p>Blog '${fn:escapeXml(bloggerName)}' has no posts.</p>
        <%

    } else {
        %>
        <p>Posts in Blog '${fn:escapeXml(bloggerName)}'.</p>
        <%
        for (Entity post : posts) {
            pageContext.setAttribute("post_content", post.getProperty("content"));
            pageContext.setAttribute("post_title", post.getProperty("title"));

            if (post.getProperty("user") == null) {
                %>
                <p>Sign in to post:</p>
                <%
            } else {
                pageContext.setAttribute("post_user", post.getProperty("user"));
                %>
                <h2 style='text-align: center; font-style: italic;
                font-weight: 600; font-family: sans-serif'>${fn:escapeXml(post_title)}</h2>
                <p style='text-align: center;'><b>Written by ${fn:escapeXml(post_user.nickname)} on 
                ${fn:escapeXml(post_date)}</b></p>
                <%
                %>
                <blockquote style="border:3px; border-style:solid; border-color:black; padding: 1em;"
                >${fn:escapeXml(post_content)}</blockquote>
                <%
            }
        }
    }
%>

		<form action="/post" method="post">
			<div><textarea name="title" rows="1" cols="40"></textarea></div>
			<div><textarea name="content" rows="3" cols="60"></textarea></div>
			<div><input type="submit" value="Post" /></div>
			<input type="hidden" name="bloggerName" value="${fn:escapeXml(bloggerName)}"/>
		</form>

		<a href="austinFoodTourAll.jsp">Display All Posts</a>



  </body>

</html>

