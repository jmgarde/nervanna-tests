require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "Crea - GCN B" do

  before(:all) do
    @driver = Selenium::WebDriver.for :remote
    @base_url = "http://courses.lecrea.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 1
    @verification_errors = []
  end
  
  after(:all) do
    @driver.quit
    @verification_errors.should == []
  end
 
  
  it "verify a text in the page" do
    @driver.get(@base_url + "/?v=b&oid=2514&lid2=D&lid4={creative}&lid5={ifmobile:mobile}&lid6={adposition}&lid7=&lid9={placement}")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /Request More Information/
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should_not =~ /404/
  end
  
  it "look for embeds on the page (GA / Optimizely / Google Conversion)" do
    @driver.get(@base_url + "/?v=b&oid=2514&lid2=D&lid4={creative}&lid5={ifmobile:mobile}&lid6={adposition}&lid7=&lid9={placement}")
	verify { @driver.find_element(:css, "script[src='//www.google-analytics.com/analytics.js']").should be_true }
	verify { @driver.find_element(:css, "script[src='//cdn.optimizely.com/js/133382400.js']").should be_true }
	verify { @driver.find_element(:css, "script[src='//www.googleadservices.com/pagead/conversion.js']").should be_true }
	verify { @driver.find_element(:css, "iframe[name='google_conversion_frame']").should be_true }
  end
  
  it "verify the registration popup" do
    @driver.get(@base_url + "/?v=b&oid=2514&lid2=D&lid4={creative}&lid5={ifmobile:mobile}&lid6={adposition}&lid7=&lid9={placement}")
    element_present?(:id, "register1").should be_true
    @driver.find_element(:id, "register1").click
    @driver.find_element(:css, "div#innerpop").should be_displayed
    # Warning: verifyTextPresent may require manual changes
    verify { @driver.find_element(:css, "BODY").text.should =~ /Please let us know a little more about you so that/ }
    @driver.find_element(:id, "exitpop").click
    element_present?(:id, "register2").should be_true
    @driver.find_element(:id, "register2").click
    @driver.find_element(:css, "div#innerpop").should be_displayed
    # Warning: verifyTextPresent may require manual changes
    verify { @driver.find_element(:css, "BODY").text.should =~ /Please let us know a little more about you so that/ }
    @driver.find_element(:id, "exitpop").click
  end
  
  it "verify that the page will catch the invalid email" do
    @driver.get(@base_url + "/?v=b&oid=2514&lid2=D&lid4={creative}&lid5={ifmobile:mobile}&lid6={adposition}&lid7=&lid9={placement}")
    @driver.find_element(:xpath, "//input[@name=\"NameFirst\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"NameFirst\"]").send_keys "ckmtest"
    @driver.find_element(:xpath, "//input[@name=\"NameLast\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"NameLast\"]").send_keys "ckmtest"
    @driver.find_element(:xpath, "//input[@name=\"HomePhone\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"HomePhone\"]").send_keys "8888888888"
    @driver.find_element(:xpath, "//input[@name=\"EMail\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"EMail\"]").send_keys "test"
    @driver.find_element(:css, "input[name='Company']").send_keys "Testing Co."
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "div.errorcontainer").size).should == 1
    (@driver.find_elements(:css, "div.errorcontainer").size).should_not == 0
    @driver.find_element(:xpath, "//input[@name=\"EMail\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"EMail\"]").send_keys "test@"
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "div.errorcontainer").size).should == 1
    (@driver.find_elements(:css, "div.errorcontainer").size).should_not == 0
    @driver.find_element(:xpath, "//input[@name=\"EMail\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"EMail\"]").send_keys "test@test"
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "div.errorcontainer").size).should == 1
    (@driver.find_elements(:css, "div.errorcontainer").size).should_not == 0
  end
    
  it "verify phone masking is working on the page" do
    @driver.get(@base_url + "/?v=b&oid=2514&lid2=D&lid4={creative}&lid5={ifmobile:mobile}&lid6={adposition}&lid7=&lid9={placement}")
    @driver.find_element(:xpath, "//input[@name=\"NameFirst\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"NameFirst\"]").send_keys "ckmtest"
    @driver.find_element(:xpath, "//input[@name=\"NameLast\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"NameLast\"]").send_keys "ckmtest"
    @driver.find_element(:xpath, "//input[@name=\"HomePhone\"]").send_keys "8888888abc"
    @driver.find_element(:xpath, "//input[@name=\"EMail\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"EMail\"]").send_keys "test@test.com"
    @driver.find_element(:css, "input[name='Company']").send_keys "Testing Co."
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "div.errorcontainer").size).should == 1
    (@driver.find_elements(:css, "div.errorcontainer").size).should_not == 0
  end
	
  it "submit with an empty company name" do
    @driver.get(@base_url + "/?v=b&oid=2514&lid2=D&lid4={creative}&lid5={ifmobile:mobile}&lid6={adposition}&lid7=&lid9={placement}")
    @driver.find_element(:xpath, "//input[@name=\"NameFirst\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"NameFirst\"]").send_keys "ckmtest"
    @driver.find_element(:xpath, "//input[@name=\"NameLast\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"NameLast\"]").send_keys "ckmtest"
	@driver.find_element(:xpath, "//input[@name=\"HomePhone\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"HomePhone\"]").send_keys "8888888888"
    @driver.find_element(:xpath, "//input[@name=\"EMail\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"EMail\"]").send_keys "test@test.com"
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "div.errorcontainer").size).should == 1
    (@driver.find_elements(:css, "div.errorcontainer").size).should_not == 0
  end
  
   it "submit with valid info and check for a thank you notification" do
    @driver.get(@base_url + "/?v=b&oid=2514&lid2=D&lid4={creative}&lid5={ifmobile:mobile}&lid6={adposition}&lid7=&lid9={placement}")
    @driver.find_element(:xpath, "//input[@name=\"NameFirst\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"NameFirst\"]").send_keys "ckmtest"
    @driver.find_element(:xpath, "//input[@name=\"NameLast\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"NameLast\"]").send_keys "ckmtest"
    @driver.find_element(:xpath, "//input[@name=\"HomePhone\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"HomePhone\"]").send_keys "8888888888"
    @driver.find_element(:xpath, "//input[@name=\"EMail\"]").clear
    @driver.find_element(:xpath, "//input[@name=\"EMail\"]").send_keys "test@test.com"
    @driver.find_element(:css, "input[name='Company']").send_keys "Testing Co."
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "div.errorcontainer").size).should == 0
    (@driver.find_elements(:css, "div.errorcontainer").size).should_not == 1
    # Warning: verifyTextPresent may require manual changes
    verify { @driver.find_element(:css, "BODY").text.should =~ /Thank You!/ }
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end