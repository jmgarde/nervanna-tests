require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "EmailCheck" do

  before(:each) do
    @driver = Selenium::WebDriver.for :remote
    @base_url = "http://info.ncu.edu/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_email_check" do
    @driver.get(@base_url + "/MFT_General_Testing/?LID1=KW&ckm_key=iKYsdeFiwxk&ckm_campaign_id=2071&PN=888-560-1681")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Marriage And Family Therapy At A Higher Degree/
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should_not =~ /404/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Step 1 of 2/
    #workaround for the missing dropdown selection during the export from the IDE
    @education_select = @driver.find_element(:id=> "EDUComplete")
    @education = @education_select.find_elements(:tag_name => "option")
    @education.each do |a|
    	if (a.text == "Bachelor's Degree")
    	a.click()
    		break
    	end
    end
    @interest_select = @driver.find_element(:id=> "areaOfInterest")
    @interest = @interest_select.find_elements(:tag_name=>"option")
    @interest.each do |b|
    	if (b.text=="Psychology")
    	b.click()
    		break
    	end
    end
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "select.pf_field_row_bad").size).should == 0
    (@driver.find_elements(:css, "select.pf_field_row_bad").size).should_not == 2
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Step 2 of 2/
    @driver.find_element(:id, "NameFirst").clear
    @driver.find_element(:id, "NameFirst").send_keys "ckmtest"
    @driver.find_element(:id, "NameLast").clear
    @driver.find_element(:id, "NameLast").send_keys "ckmtest"
    # ERROR: Caught exception [ReferenceError: selectLocator is not defined]
    @driver.find_element(:id, "AddressZip").send_keys "60601"
    @driver.find_element(:id, "EMail").clear
    @driver.find_element(:id, "EMail").send_keys "test"
    @driver.find_element(:id, "Phone").send_keys "8888888888"
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should == 1
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should_not == 0
    @driver.find_element(:id, "EMail").clear
    @driver.find_element(:id, "EMail").send_keys "test@"
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should == 1
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should_not == 0
    @driver.find_element(:id, "EMail").clear
    @driver.find_element(:id, "EMail").send_keys "test@test"
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should == 1
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should_not == 0
    p "TEST END - STEP 2 CHECK"
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
