package austinFoodTour;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.mail.*;

@SuppressWarnings("serial")
public class MailServlet extends HttpServlet {

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String bloggerName = "Austin Food Tour";

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Query query_email = new Query("EmailAddress");
        List<Entity> emails = datastore.prepare(query_email).asList(FetchOptions.Builder.withLimit(1000));
        
        Set<String> set_recepients = new HashSet<String>(); 
        set_recepients.add("qinyudiao@gmail.com");
        set_recepients.add("qdiao@utexas.edu");
        for(Entity email : emails) {
        	 if(email.getProperty("emailAddress").toString() != "" && email.getProperty("emailAddress").toString() != null)
        		 set_recepients.add(email.getProperty("emailAddress").toString());   	 
        }
        String[] recepients = new String[set_recepients.size()]; 
  
        // ArrayList to Array Conversion 
        int i = 0;
        for (String recep : set_recepients) {
        	recepients[i] = recep; 
        	i++;
        }
  
        for (String x : recepients) 
            System.out.println("one of recepients:" + x);
          
		try {		
			//if there's update, send the emails
			Date a_day_ago = new Date(System.currentTimeMillis() - 24 * 3600 * 1000);;
	        Query query_thread = new Query("Thread");
	        List<Entity> threads = datastore.prepare(query_thread).asList(FetchOptions.Builder.withLimit(1000));
	        List<String> titles = new ArrayList<>();
	        //titles.add("lol");
	        for (Entity thread: threads) {
	        	if(thread.getProperty("date") != null) {
	        		//System.out.println("some");
		        	if(a_day_ago.compareTo((Date) thread.getProperty("date")) <= 0) {
		        		titles.add((String) thread.getProperty("title"));
		        	}
	        	}
	        	//System.out.println("some out");
	        }
	        System.out.print(titles.size());
	        if(titles.size()>0) {
	        	JavaMailUtil.sendMail(recepients, titles);
	        }
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		resp.sendRedirect("/austinFoodTour.jsp?bloggerName=" + bloggerName);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
			
		String emailAddress = req.getParameter("emailAddress");
		System.out.println("email: " + emailAddress);
	    if(emailAddress != ""  &&  emailAddress != null  &&  emailAddress.length() > 5) {
	    	Key emailKey = KeyFactory.createKey("recepient", emailAddress);
		    
		    String purpose = req.getParameter("purpose");
		    System.out.println("purpose: " + purpose);
		    if(purpose.equals("toSub")) { 
		    	System.out.println("add to datastore a");
			    Entity email = new Entity("EmailAddress", emailKey);
			    email.setProperty("emailAddress", emailAddress);
			    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			    datastore.put(email);
			    System.out.println("add to datastore ");
		    }
		    else if(purpose.equals("toUnSub")) {
		    	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		        Query query_email = new Query("EmailAddress");
		        List<Entity> emails = datastore.prepare(query_email).asList(FetchOptions.Builder.withLimit(1000));
		        for (Entity email: emails) {
		        	if(email.getProperty("emailAddress").equals(emailAddress))
		        		datastore.delete(email.getKey());
		        }
			    
		    }
	    }
	    
		String bloggerName = "Austin Food Tour";	    
		resp.sendRedirect("/austinFoodTour.jsp?bloggerName=" + bloggerName);
	}

}
