package com.arsdigita.acs.wpSlim.test;
/**
 * Test Wimpy Point.
 *
 * @author Patrick McNeill (pmcneill@arsdigita.com)
 * @creation-date 2001-01-03
 * @cvs-id $Id$
 */

import com.meterware.httpunit.*;
import junit.framework.*;
import java.util.*;
import java.lang.reflect.*;

public class WPSlimTest extends TestCase
{
  private static String TEST_SERVER;
  private static String public_pres_item_id = null;

  public WPSlimTest(String name)
  {
    super(name);
    TEST_SERVER = System.getProperty("server.url");
  }

  public static Test suite()
  {
    Method[] methods = WPSlimTest.class.getDeclaredMethods();
    TestSuite suite = new TestSuite();

    suite.addTest(new WPSlimTest("create_public_presentation"));

    for (int i = 0; i < methods.length; i++) {
        if (methods[i].getName().indexOf("test")!=-1) {
            suite.addTest(new WPSlimTest(methods[i].getName()));
        }
    }
    
    suite.addTest(new WPSlimTest("delete_public_presentation"));

    return suite;
  }

  // ---------- START OF TESTS ----------

    public void create_public_presentation() throws Exception {
        WebConversation wc = ACSCommon.Login();
        WebResponse r = wc.getResponse(TEST_SERVER + "/wp/create-presentation");

        assertEquals("Status", 200, r.getResponseCode());

        WebForm form = r.getForms()[0];
        WebRequest req = form.getRequest();

        req.setParameter("pres_title","Public Test " + (new Date()).toString());
        req.setParameter("page_signature","Page Signature");
        req.setParameter("copyright_notice","Copyright Notice");
        req.setParameter("show_modified_p","t");
        req.setParameter("public_p","t");
        req.setParameter("audience","Audience here");
        req.setParameter("background","Background here");

        r = wc.getResponse(req);

        assertEquals("Status", 200, r.getResponseCode());

        //r = wc.getResponse(TEST_SERVER + "/wp/" + r.getLinkWith("Edit presentation").getURLString());
	if (r.getLinkWith("Edit presentation") == null) {
	    assertEquals("Rats!@"+r.getText(), 1, 2);
	}
        assertEquals("Status", 2003, r.getResponseCode());

        form = r.getForms()[0];

        public_pres_item_id = form.getParameterValue("pres_item_id");

        assert("Title not set", form.getParameterValue("pres_title").indexOf("Public Test")!=-1);
        assert("Signature not set", form.getParameterValue("page_signature").equals("Page Signature"));
        assert("Copyright not set", form.getParameterValue("copyright_notice").equals("Copyright Notice"));
        assert("Modified data not set", form.getParameterValue("show_modified_p").equals("t"));
        assert("Public not set", form.getParameterValue("public_p").equals("t"));
        assert("Audience not set", form.getParameterValue("audience").equals("Audience here"));

        r = wc.getResponse(TEST_SERVER + "/wp/create-slide?sort_key=1&pres_item_id=" + public_pres_item_id);

        assertEquals("Status", 200, r.getResponseCode());
        assert("Title not present on slide page", r.toString().indexOf("Public Test") != -1);

        form = r.getForms()[0];
        req = form.getRequest();

        req.setParameter("slide_title","Slide Title");
        req.setParameter("preamble", "Preamble");
        req.setParameter("bullet.1", "Bullet 1");
        req.setParameter("bullet.2", "Bullet 2");
        req.setParameter("bullet.3", "Bullet 3");
        req.setParameter("bullet.4", "Bullet 4");
        req.setParameter("bullet.5", "Bullet 5");
        req.setParameter("postamble", "Postamble");

        r = wc.getResponse(req);

        assertEquals("Status",200,r.getResponseCode());   
        assert("Slide title not recorded",r.getLinkWith("Slide Title") != null);

        r = wc.getResponse(TEST_SERVER + "/wp/create-slide?sort_key=2&pres_item_id=" + public_pres_item_id);

        assertEquals("Status", 200, r.getResponseCode());
        assert("Title not present on slide page", r.toString().indexOf("Public Test") != -1);

        form = r.getForms()[0];
        req = form.getRequest();

        req.setParameter("slide_title","Slide 2 Title");
        req.setParameter("preamble", "Preamble");
        req.setParameter("bullet.1", "Bullet 1");
        req.setParameter("bullet.2", "Bullet 2");
        req.setParameter("bullet.3", "Bullet 3");
        req.setParameter("bullet.4", "Bullet 4");
        req.setParameter("bullet.5", "Bullet 5");
        req.setParameter("postamble", "Postamble");

        r = wc.getResponse(req);

        assertEquals("Status",200,r.getResponseCode());
        assert("Slide title not recorded",r.getLinkWith("Slide 2 Title") != null);
    }

    public void test_not_logged_in_presentation_list () throws Exception {
        WebConversation wc = new WebConversation();
        WebResponse r = wc.getResponse(TEST_SERVER + "/wp/");

        assertEquals("Status",200,r.getResponseCode());
        assert("Public presentation not found", r.getLinkWith("Public Test") != null);
    }

    public void test_not_logged_in_presentation_and_slide_view () throws Exception {
        WebConversation wc = new WebConversation();
        WebResponse r = wc.getResponse(TEST_SERVER + "/wp/display/" + public_pres_item_id);
        WebLink l = null;

        assertEquals("Status",200,r.getResponseCode());
        assert("Could not view presentation", (l = r.getLinkWith("Slide Title")) != null);

        r = wc.getResponse(TEST_SERVER + l.getURLString());

        assertEquals("Status",200,r.getResponseCode());
        assert("Could not view slide", r.toString().indexOf("Slide Title") != -1);
    }

    public void test_not_logged_in_create_links () throws Exception {
        WebConversation wc = new WebConversation();
        WebResponse r = wc.getResponse(TEST_SERVER + "/wp/");

        assertEquals("Status",200,r.getResponseCode());
        assert("Creation link found", r.getLinkWith("Create a new presentation") == null);
    }

    public void test_virtual_url_handling_and_main_page () throws Exception {
        WebConversation wc = new WebConversation();
        WebResponse r = wc.getResponse(TEST_SERVER + "/wp/display/" + public_pres_item_id);

        assertEquals("Status",200,r.getResponseCode());
        assert("Signature not found", r.toString().indexOf("Page Signature") != -1);
        assert("Title not found", r.toString().indexOf("Public Test") != -1);
        assert("Slide 1 not found", r.toString().indexOf("Slide Title") != -1);
        assert("Slide 2 not found", r.toString().indexOf("Slide 2 Title") != -1);
    }

    public void test_slide_display () throws Exception {
        WebConversation wc = ACSCommon.Login();
        WebResponse r = wc.getResponse(TEST_SERVER + "/wp/display/" + public_pres_item_id);

        assertEquals("Status",200,r.getResponseCode());

        r = wc.getResponse(TEST_SERVER + r.getLinkWith("Slide Title").getURLString());

        assertEquals("Status",200,r.getResponseCode());
        assert("Title missing",r.toString().indexOf("Slide Title") != -1);
        assert("Preamble missing", r.toString().indexOf("Preamble") != -1);
        assert("Postamble missing", r.toString().indexOf("Postamble") != -1);
        assert("Bullet 1 missing", r.toString().indexOf("Bullet 1") != -1);
        assert("Bullet 2 missing", r.toString().indexOf("Bullet 2") != -1);
        assert("Bullet 3 missing", r.toString().indexOf("Bullet 3") != -1);
        assert("Bullet 4 missing", r.toString().indexOf("Bullet 4") != -1);
        assert("Bullet 5 missing", r.toString().indexOf("Bullet 5") != -1);
        assert("Bullets 1 and 2 out of order", r.toString().indexOf("Bullet 1") < r.toString().indexOf("Bullet 2"));
        assert("Bullets 2 and 3 out of order", r.toString().indexOf("Bullet 2") < r.toString().indexOf("Bullet 3"));
        assert("Bullets 3 and 4 out of order", r.toString().indexOf("Bullet 3") < r.toString().indexOf("Bullet 4"));
        assert("Bullets 4 and 5 out of order", r.toString().indexOf("Bullet 4") < r.toString().indexOf("Bullet 5"));
        assert("Signature missing", r.toString().indexOf("Page Signature") != -1);
        assert("Copyright missing", r.toString().indexOf("Copyright Notice") != -1);
    }

    public void test_change_to_private_and_check_visibility () throws Exception {
        WebConversation wc = ACSCommon.Login();
        WebResponse r = wc.getResponse(TEST_SERVER + "/wp/edit-presentation?pres_item_id=" + public_pres_item_id);

        assertEquals("Status",200,r.getResponseCode());

        WebForm form = r.getForms()[0];
        WebRequest req = form.getRequest();

        req.setParameter("public_p","f");

        r = wc.getResponse(req);

        assertEquals("Status",200,r.getResponseCode());

        wc = new WebConversation();
        r = wc.getResponse(TEST_SERVER + "/wp/");

        assertEquals("Status",200,r.getResponseCode());
        assert("Presentation still visible",r.toString().indexOf("display/" + public_pres_item_id) == -1);

        wc = ACSCommon.Login();
        r = wc.getResponse(TEST_SERVER + "/wp/edit-presentation?pres_item_id=" + public_pres_item_id); 

        assertEquals("Status",200,r.getResponseCode());

        form = r.getForms()[0];
        req = form.getRequest();

        req.setParameter("public_p","t");

        r = wc.getResponse(req);

        assertEquals("Status",200,r.getResponseCode());

        r = wc.getResponse(TEST_SERVER + "/wp/");
       
        assertEquals("Status",200,r.getResponseCode());
        assert("Presentation not visible",r.toString().indexOf("display/" + public_pres_item_id) != -1);
    }

    public void test_check_for_top_level_edit_link () throws Exception {
        WebConversation wc = ACSCommon.Login();
        WebResponse r = wc.getResponse(TEST_SERVER + "/wp/");

        assertEquals("Status", 200, r.getResponseCode());
        assert("Edit link not present",r.toString().indexOf("presentation-top?pres_item_id=" + public_pres_item_id) != -1);
    }

    public void delete_public_presentation () throws Exception {
        WebConversation wc = ACSCommon.Login();
        WebResponse r = wc.getResponse(TEST_SERVER + "/wp/delete-presentation?pres_item_id=" + public_pres_item_id);

        assertEquals("Status", 200, r.getResponseCode());

        r = wc.getResponse(TEST_SERVER + "/wp/");

        assertEquals("Status", 200, r.getResponseCode());
        assert("Still listed", r.toString().indexOf("display/" + public_pres_item_id) == -1);
    }

    public void test_users_who_own_presentations () throws Exception {
        WebConversation wc = ACSCommon.Login();
        WebResponse r = wc.getResponse(TEST_SERVER + "/wp/users");

        assertEquals("Status", 200, r.getResponseCode());
        assert("Test User not listed", r.toString().indexOf("Test User") != -1);
    }
}
