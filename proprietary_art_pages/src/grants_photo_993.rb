require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "Art Schools Online - Grants Photography - OID = 993" do

  before(:all) do
    @driver = Selenium::WebDriver.for :remote
    @base_url = "http://art-schools-online.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 1
    @verification_errors = []
  end
  
  after(:all) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "check the page if exists and not returning a 404" do
     @driver.get(@base_url + "grants/photography/?oid=993&lid1=AIO_photo")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /The Art Institute of Pittsburgh/
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should_not =~ /404/
  end
  
  it "verifies a GA script embed on the page" do
	@driver.get(@base_url + "grants/photography/?oid=993&lid1=AIO_photo")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /The Art Institute of Pittsburgh/
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should_not =~ /404/
	verify { @driver.find_element(:css, "script[src='http://www.google-analytics.com/ga.js']").should be_true }
  end
  
  it "wait for the chat popup and verify" do
    @driver.get(@base_url + "grants/photography/?oid=993&lid1=AIO_photo")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /The Art Institute of Pittsburgh - Online Division/
    element_present?(:id, "chatnow").should be_true
    @driver.find_element(:id, "chatnow").click
    verify { element_present?(:id, "SnapABug_OCB").should be_true }
    @driver.find_element(:css, "img[alt=\"Close\"]").click
  end
  
  it "submit with invalid values for email" do
    @driver.get(@base_url + "grants/photography/?oid=993&lid1=AIO_photo")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /The Art Institute of Pittsburgh - Online Division/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 1 OF 2:/
    @driver.find_element(:name, "NameFirst").send_keys "ckmtest"
    @driver.find_element(:name, "NameLast").send_keys "ckmtest"
    @driver.find_element(:name, "EmailAddress").clear
    @driver.find_element(:name, "EmailAddress").send_keys "test"
	@driver.find_element(:name, "HomePhone").clear
    @driver.find_element(:name, "HomePhone").send_keys "8888888888"
    @driver.find_element(:css, "img.next").click
    (@driver.find_elements(:css, "input.uberror").size).should == 1
    (@driver.find_elements(:css, "input.uberror").size).should_not == 0
    @driver.find_element(:name, "EmailAddress").clear
    @driver.find_element(:name, "EmailAddress").send_keys "test@"
    @driver.find_element(:css, "img.next").click
    (@driver.find_elements(:css, "input.uberror").size).should == 1
    (@driver.find_elements(:css, "input.uberror").size).should_not == 0
    @driver.find_element(:name, "EmailAddress").clear
    @driver.find_element(:name, "EmailAddress").send_keys "test@test"
    @driver.find_element(:css, "img.next").click
    (@driver.find_elements(:css, "input.uberror").size).should == 1
    (@driver.find_elements(:css, "input.uberror").size).should_not == 0
  end
  
  it "submit step 1 with valid information and verify step 2" do
    @driver.get(@base_url + "grants/photography/?oid=993&lid1=AIO_photo")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /The Art Institute of Pittsburgh - Online Division/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 1 OF 2:/
    @driver.find_element(:name, "NameFirst").send_keys "ckmtest"
    @driver.find_element(:name, "NameLast").send_keys "ckmtest"
    @driver.find_element(:name, "EmailAddress").clear
    @driver.find_element(:name, "EmailAddress").send_keys "test@test.com"
	@driver.find_element(:name, "HomePhone").clear
    @driver.find_element(:name, "HomePhone").send_keys "8888888888"
    @driver.find_element(:css, "img.next").click
    (@driver.find_elements(:css, "input.uberror").size).should == 0
    (@driver.find_elements(:css, "input.uberror").size).should_not == 4
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 2 OF 2:/
  end
  
  it "input invalid zip code and notify user" do
    @driver.get(@base_url + "grants/photography/?oid=993&lid1=AIO_photo")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /The Art Institute of Pittsburgh - Online Division/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 1 OF 2:/
    @driver.find_element(:name, "NameFirst").send_keys "ckmtest"
    @driver.find_element(:name, "NameLast").send_keys "ckmtest"
    @driver.find_element(:name, "EmailAddress").clear
    @driver.find_element(:name, "EmailAddress").send_keys "test@test.com"
	@driver.find_element(:name, "HomePhone").clear
    @driver.find_element(:name, "HomePhone").send_keys "8888888888"
    @driver.find_element(:css, "img.next").click
    (@driver.find_elements(:css, "input.uberror").size).should == 0
    (@driver.find_elements(:css, "input.uberror").size).should_not == 4
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 2 OF 2:/
    @driver.find_element(:name, "AddressLine1").clear
    @driver.find_element(:name, "AddressLine1").send_keys "512 Anyplace"
    @driver.find_element(:name, "AddressLine2").clear
    @driver.find_element(:name, "AddressLine2").send_keys "#58"
    @driver.find_element(:name, "AddressCity").clear
    @driver.find_element(:name, "AddressCity").send_keys "Compton"
    #workaround for the missing dropdown selection during the export from the IDE
    @state_select = @driver.find_element(:name=> "AddressState")
    @state = @state_select.find_elements(:tag_name => "option")
    @state.each do |a|
    	if (a.text == "Illinois")
    	a.click()
    		break
    	end
    end
	@driver.find_element(:css, "input[name='AddressZip']").clear
    @driver.find_element(:css, "input[name='AddressZip']").send_keys "60aaa"
    #workaround for the missing dropdown selection during the export from the IDE
    @education_select = @driver.find_element(:name=> "EDUComplete")
    @education = @education_select.find_elements(:tag_name => "option")
    @education.each do |a|
    	if (a.text == "Bachelors Degree")
    	a.click()
    		break
    	end
    end
    #workaround for the missing dropdown selection during the export from the IDE
    @hs_select = @driver.find_element(:name=> "HSGradYear")
    @hs = @hs_select.find_elements(:tag_name => "option")
    @hs.each do |a|
    	if (a.text == "2001")
    	a.click()
    		break
    	end
    end
    #workaround for the missing dropdown selection during the export from the IDE
    @mil_select = @driver.find_element(:name=> "MilitaryStatus")
    @mil = @mil_select.find_elements(:tag_name => "option")
    @mil.each do |a|
    	if (a.text == "None")
    	a.click()
    		break
    	end
    end
    @driver.find_element(:name, "agree1").click
    @driver.find_element(:name, "agree2").click
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "input.uberror").size).should == 1
    (@driver.find_elements(:css, "input.uberror").size).should_not == 9
  end
    
  it "submit with invalid street address" do
    @driver.get(@base_url + "grants/photography/?oid=993&lid1=AIO_photo")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /The Art Institute of Pittsburgh - Online Division/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 1 OF 2:/
    @driver.find_element(:name, "NameFirst").send_keys "ckmtest"
    @driver.find_element(:name, "NameLast").send_keys "ckmtest"
    @driver.find_element(:name, "EmailAddress").clear
    @driver.find_element(:name, "EmailAddress").send_keys "test@test.com"
	@driver.find_element(:name, "HomePhone").clear
    @driver.find_element(:name, "HomePhone").send_keys "8888888888"
    @driver.find_element(:css, "img.next").click
    (@driver.find_elements(:css, "input.uberror").size).should == 0
    (@driver.find_elements(:css, "input.uberror").size).should_not == 4
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 2 OF 2:/
    @driver.find_element(:name, "AddressLine1").clear
    @driver.find_element(:name, "AddressLine1").send_keys "Anyplace"
    @driver.find_element(:name, "AddressLine2").clear
    @driver.find_element(:name, "AddressLine2").send_keys "#58"
    @driver.find_element(:name, "AddressCity").clear
    @driver.find_element(:name, "AddressCity").send_keys "Compton"
    #workaround for the missing dropdown selection during the export from the IDE
    @state_select = @driver.find_element(:name=> "AddressState")
    @state = @state_select.find_elements(:tag_name => "option")
    @state.each do |a|
    	if (a.text == "Illinois")
    	a.click()
    		break
    	end
    end
	@driver.find_element(:css, "input[name='AddressZip']").clear
    @driver.find_element(:css, "input[name='AddressZip']").send_keys "60601"
    #workaround for the missing dropdown selection during the export from the IDE
    @education_select = @driver.find_element(:name=> "EDUComplete")
    @education = @education_select.find_elements(:tag_name => "option")
    @education.each do |a|
    	if (a.text == "Bachelors Degree")
    	a.click()
    		break
    	end
    end
    #workaround for the missing dropdown selection during the export from the IDE
    @hs_select = @driver.find_element(:name=> "HSGradYear")
    @hs = @hs_select.find_elements(:tag_name => "option")
    @hs.each do |a|
    	if (a.text == "2001")
    	a.click()
    		break
    	end
    end
    #workaround for the missing dropdown selection during the export from the IDE
    @mil_select = @driver.find_element(:name=> "MilitaryStatus")
    @mil = @mil_select.find_elements(:tag_name => "option")
    @mil.each do |a|
    	if (a.text == "None")
    	a.click()
    		break
    	end
    end
    @driver.find_element(:name, "agree1").click
    @driver.find_element(:name, "agree2").click
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "input.uberror").size).should == 1
    (@driver.find_elements(:css, "input.uberror").size).should_not == 9
    @driver.find_element(:name, "AddressLine1").clear
    @driver.find_element(:name, "AddressLine1").send_keys "512"
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "input.uberror").size).should == 1
    (@driver.find_elements(:css, "input.uberror").size).should_not == 9
    @driver.find_element(:name, "AddressLine1").clear
    @driver.find_element(:name, "AddressLine1").send_keys "Anyplace 512"
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "input.uberror").size).should == 1
    (@driver.find_elements(:css, "input.uberror").size).should_not == 9
  end  
  
  it "submit without having the checkbox ticked" do
    @driver.get(@base_url + "grants/photography/?oid=993&lid1=AIO_photo")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /The Art Institute of Pittsburgh - Online Division/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 1 OF 2:/
    @driver.find_element(:name, "NameFirst").send_keys "ckmtest"
    @driver.find_element(:name, "NameLast").send_keys "ckmtest"
    @driver.find_element(:name, "EmailAddress").clear
    @driver.find_element(:name, "EmailAddress").send_keys "test@test.com"
	@driver.find_element(:name, "HomePhone").clear
    @driver.find_element(:name, "HomePhone").send_keys "8888888888"
    @driver.find_element(:css, "img.next").click
    (@driver.find_elements(:css, "input.uberror").size).should == 0
    (@driver.find_elements(:css, "input.uberror").size).should_not == 4
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 2 OF 2:/
    @driver.find_element(:name, "AddressLine1").clear
    @driver.find_element(:name, "AddressLine1").send_keys "512 Anyplace"
    @driver.find_element(:name, "AddressLine2").clear
    @driver.find_element(:name, "AddressLine2").send_keys "#58"
    @driver.find_element(:name, "AddressCity").clear
    @driver.find_element(:name, "AddressCity").send_keys "Compton"
    #workaround for the missing dropdown selection during the export from the IDE
    @state_select = @driver.find_element(:name=> "AddressState")
    @state = @state_select.find_elements(:tag_name => "option")
    @state.each do |a|
    	if (a.text == "Illinois")
    	a.click()
    		break
    	end
    end
	@driver.find_element(:css, "input[name='AddressZip']").clear
    @driver.find_element(:css, "input[name='AddressZip']").send_keys "60601"
    #workaround for the missing dropdown selection during the export from the IDE
    @education_select = @driver.find_element(:name=> "EDUComplete")
    @education = @education_select.find_elements(:tag_name => "option")
    @education.each do |a|
    	if (a.text == "Bachelors Degree")
    	a.click()
    		break
    	end
    end
    #workaround for the missing dropdown selection during the export from the IDE
    @hs_select = @driver.find_element(:name=> "HSGradYear")
    @hs = @hs_select.find_elements(:tag_name => "option")
    @hs.each do |a|
    	if (a.text == "2001")
    	a.click()
    		break
    	end
    end
    #workaround for the missing dropdown selection during the export from the IDE
    @mil_select = @driver.find_element(:name=> "MilitaryStatus")
    @mil = @mil_select.find_elements(:tag_name => "option")
    @mil.each do |a|
    	if (a.text == "None")
    	a.click()
    		break
    	end
    end
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "input.uberror").size).should == 2
    (@driver.find_elements(:css, "input.uberror").size).should_not == 9
   end
  
  it "submit valid information and verify a thank you page - Undergrad" do
    @driver.get(@base_url + "grants/photography/?oid=993&lid1=AIO_photo")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /The Art Institute of Pittsburgh - Online Division/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 1 OF 2:/
    @driver.find_element(:name, "NameFirst").send_keys "ckmtest"
    @driver.find_element(:name, "NameLast").send_keys "ckmtest"
    @driver.find_element(:name, "EmailAddress").clear
    @driver.find_element(:name, "EmailAddress").send_keys "test@test.com"
	@driver.find_element(:name, "HomePhone").clear
    @driver.find_element(:name, "HomePhone").send_keys "8888888888"
    @driver.find_element(:css, "img.next").click
    (@driver.find_elements(:css, "input.uberror").size).should == 0
    (@driver.find_elements(:css, "input.uberror").size).should_not == 4
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 2 OF 2:/
    @driver.find_element(:name, "AddressLine1").clear
    @driver.find_element(:name, "AddressLine1").send_keys "512 Anyplace"
    @driver.find_element(:name, "AddressLine2").clear
    @driver.find_element(:name, "AddressLine2").send_keys "#58"
    @driver.find_element(:name, "AddressCity").clear
    @driver.find_element(:name, "AddressCity").send_keys "Compton"
    #workaround for the missing dropdown selection during the export from the IDE
    @state_select = @driver.find_element(:name=> "AddressState")
    @state = @state_select.find_elements(:tag_name => "option")
    @state.each do |a|
    	if (a.text == "Illinois")
    	a.click()
    		break
    	end
    end
	@driver.find_element(:css, "input[name='AddressZip']").clear
    @driver.find_element(:css, "input[name='AddressZip']").send_keys "60601"
    #workaround for the missing dropdown selection during the export from the IDE
    @education_select = @driver.find_element(:name=> "EDUComplete")
    @education = @education_select.find_elements(:tag_name => "option")
    @education.each do |a|
    	if (a.text == "Some High School")
    	a.click()
    		break
    	end
    end
    #workaround for the missing dropdown selection during the export from the IDE
    @hs_select = @driver.find_element(:name=> "HSGradYear")
    @hs = @hs_select.find_elements(:tag_name => "option")
    @hs.each do |a|
    	if (a.text == "2001")
    	a.click()
    		break
    	end
    end
    #workaround for the missing dropdown selection during the export from the IDE
    @mil_select = @driver.find_element(:name=> "MilitaryStatus")
    @mil = @mil_select.find_elements(:tag_name => "option")
    @mil.each do |a|
    	if (a.text == "None")
    	a.click()
    		break
    	end
    end
    @driver.find_element(:name, "agree1").click
    @driver.find_element(:name, "agree2").click
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "input.uberror").size).should == 0
    (@driver.find_elements(:css, "input.uberror").size).should_not == 11
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /Thank You for Entering!/
  end
  
  it "submit valid information and verify thank you page - Graduate" do
    @driver.get(@base_url + "grants/photography/?oid=993&lid1=AIO_photo")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /The Art Institute of Pittsburgh - Online Division/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 1 OF 2:/
    @driver.find_element(:name, "NameFirst").send_keys "ckmtest"
    @driver.find_element(:name, "NameLast").send_keys "ckmtest"
    @driver.find_element(:name, "EmailAddress").clear
    @driver.find_element(:name, "EmailAddress").send_keys "test@test.com"
	@driver.find_element(:name, "HomePhone").clear
    @driver.find_element(:name, "HomePhone").send_keys "8888888888"
    @driver.find_element(:css, "img.next").click
    (@driver.find_elements(:css, "input.uberror").size).should == 0
    (@driver.find_elements(:css, "input.uberror").size).should_not == 4
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /STEP 2 OF 2:/
    @driver.find_element(:name, "AddressLine1").clear
    @driver.find_element(:name, "AddressLine1").send_keys "512 Anyplace"
    @driver.find_element(:name, "AddressLine2").clear
    @driver.find_element(:name, "AddressLine2").send_keys "#58"
    @driver.find_element(:name, "AddressCity").clear
    @driver.find_element(:name, "AddressCity").send_keys "Compton"
    #workaround for the missing dropdown selection during the export from the IDE
    @state_select = @driver.find_element(:name=> "AddressState")
    @state = @state_select.find_elements(:tag_name => "option")
    @state.each do |a|
    	if (a.text == "Illinois")
    	a.click()
    		break
    	end
    end
	@driver.find_element(:css, "input[name='AddressZip']").clear
    @driver.find_element(:css, "input[name='AddressZip']").send_keys "60601"
    #workaround for the missing dropdown selection during the export from the IDE
    @education_select = @driver.find_element(:name=> "EDUComplete")
    @education = @education_select.find_elements(:tag_name => "option")
    @education.each do |a|
    	if (a.text == "Bachelors Degree")
    	a.click()
    		break
    	end
    end
    #workaround for the missing dropdown selection during the export from the IDE
    @hs_select = @driver.find_element(:name=> "HSGradYear")
    @hs = @hs_select.find_elements(:tag_name => "option")
    @hs.each do |a|
    	if (a.text == "2001")
    	a.click()
    		break
    	end
    end
    #workaround for the missing dropdown selection during the export from the IDE
    @mil_select = @driver.find_element(:name=> "MilitaryStatus")
    @mil = @mil_select.find_elements(:tag_name => "option")
    @mil.each do |a|
    	if (a.text == "None")
    	a.click()
    		break
    	end
    end
    @driver.find_element(:name, "agree1").click
    @driver.find_element(:name, "agree2").click
    @driver.find_element(:css, "img.submit").click
    (@driver.find_elements(:css, "input.uberror").size).should == 0
    (@driver.find_elements(:css, "input.uberror").size).should_not == 11
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /Thank You for Entering!/
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