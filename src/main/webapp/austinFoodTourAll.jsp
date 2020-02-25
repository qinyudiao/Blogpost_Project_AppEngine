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
		  div.left50{
		  	position: absolute;
		  	left : 50px;
		  }
		  div.left40top30{
		  	position: relative;
		  	left : 40px;
		  	top : 30px;
		  }
		</style>
	</head>
  <body>
  
  <img src="AustinFoodTour_title.jpeg" alt="Title" width="100%">
	<div class="align-right"> 
		<a href="austinFoodTourAllDark.jsp">Dark Mode</a>
	</div>
<%
    String bloggerName = request.getParameter("bloggerName");
	

    if (bloggerName == null) {
        bloggerName = "Austin Food Tour";
    }

    pageContext.setAttribute("bloggerName", bloggerName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
	String emailAddr = "";
    
    if (user != null) {
      pageContext.setAttribute("user", user);
      emailAddr = user.getEmail();
      pageContext.setAttribute("emailAddr", emailAddr);
      
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
	<p style="font-size:12px">If you want to subscribe, please make sure to log in with your google account first. <p>
	<p style="font-size:12px">If you are subscribed and there were new posts in the past 24 hours, 
							we'll send you an email to your gmail address at 5pm central time everday.<p>
		    <div>
				<form action="/send" method="post">
					<input type="hidden" name="emailAddress" value="${fn:escapeXml(emailAddr)}"/>
					<input type="hidden" name="purpose" value="toSub"/>
					<input type="submit" value="Subscribe"></input>
				</form>

				<form action="/send" method="post">
					<input type="hidden" name="emailAddress" value="${fn:escapeXml(emailAddr)}"/>
					<input type="hidden" name="purpose" value="toUnSub"/>
					<input type="submit" value="Unsubscribe"></input>
				</form>
			</div>
			

<!--  	<form action="/send" method="get">
			<input type="submit" value="Send"></input>
	</form> -->
	<p style="text-align:center;"><img src="taco1.png" alt="Taco" width="300" height="200" alt="centered image"></p> 

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key blogKey = KeyFactory.createKey("Blog", bloggerName);
    
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    Query query = new Query("Thread", blogKey).addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> posts = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(1000));

    
    if (posts.isEmpty()) {
        %>
        <div class="left50"><p>Blog '${fn:escapeXml(bloggerName)}' has no posts.</p></div>
        <%

    } else {
        %>
        <div class="left50"> <p>Posts in Blog '${fn:escapeXml(bloggerName)}'.</p> </div>
        <%
        for (Entity post : posts) {
            pageContext.setAttribute("post_content", post.getProperty("content"));
            pageContext.setAttribute("post_title", post.getProperty("title"));
            pageContext.setAttribute("post_date", post.getProperty("date"));

            if (post.getProperty("user") == null) {

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
	<div class="left50"> 
		<a href="austinFoodTour.jsp">Show less</a>
	</div>
	<%if (user != null) { %>
		<div class="left40top30">
			<form action="/post" method="post">
				<label for="fname"> Title</label><br>
				<div><textarea name="title" rows="1" cols="80"></textarea></div>
				<p style="font-size:10px"> Content</p>
				<div><textarea name="content" rows="4" cols="80"></textarea></div>
				<div><input type="submit" value="Post" /></div>
				<input type="hidden" name="bloggerName" value="${fn:escapeXml(bloggerName)}"/>
				<input type="hidden" name="pageName" value="austinFoodTourAll.jsp"/>
			</form>
		</div>
	<%} %>
		

  </body>

</html>
