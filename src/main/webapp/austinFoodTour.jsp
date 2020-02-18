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

<h1> Austin Food Tour </h1>
		<p id="p1">This is a paragraph.</p>
		<p>This is another paragraph.</p>
		<p> Visit <a id="link1" href="https://www.nfl.com">NFL</a> </p>
		
		<table>
		      <tr>
		        <td colspan="2" style="font-weight:bold;">Available Servlets:</td>        
		      </tr>
		      <tr>
		        <td><a href='/austinfoodtour'>The servlet</a></td>
		      </tr>
		</table>
		
		<img src="taco1.png" alt="Taco" width="791" height="530">  
 

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
            }
            %>
            <blockquote>${fn:escapeXml(post_content)}</blockquote>
            <%
        }
    }
%>
		<form action="/post" method="post">
			<div><textarea name="title" rows="1" cols="40"></textarea></div>
			<div><textarea name="content" rows="3" cols="60"></textarea></div>
			<div><input type="submit" value="Post" /></div>
			<input type="hidden" name="bloggerName" value="${fn:escapeXml(bloggerName)}"/>
		</form>

  </body>

</html>

