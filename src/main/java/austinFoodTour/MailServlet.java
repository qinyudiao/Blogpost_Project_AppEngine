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
        Key emailKey = KeyFactory.createKey("Email", "Email1");
        Query query_email = new Query("Email", emailKey);
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
			JavaMailUtil.sendMail(recepients);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		resp.sendRedirect("/austinFoodTour.jsp?bloggerName=" + bloggerName);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
			
		String emailAddress = req.getParameter("emailAddress");
		Key emailKey = KeyFactory.createKey("Email", emailAddress);
	    
	    
	    if(emailAddress != ""  &&  emailAddress != null) {
		    System.out.println("email: " + emailAddress);
		    String purpose = req.getParameter("purpose");
		    System.out.println("purpose: " + purpose);
		    if(purpose == "toSub") { 
			    Entity email = new Entity("Email", emailKey);
			    email.setProperty("emailAddress", emailAddress);
			    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			    datastore.put(email);
		    }
		    else if(purpose == "toUnSub") {
			    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			    datastore.delete(emailKey);
		    }
	    }
	    
		String bloggerName = "Austin Food Tour";	    
		resp.sendRedirect("/austinFoodTour.jsp?bloggerName=" + bloggerName);
	}

}
