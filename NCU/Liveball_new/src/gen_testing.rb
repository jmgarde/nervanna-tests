require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "NCU General Testing" do

  before(:all) do
    @driver = Selenium::WebDriver.for :remote
    @base_url = "http://info.ncu.edu/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 1
    @verification_errors = []
  end
  
  after(:all) do
    @driver.quit
    @verification_errors.should == []
  end
  
	it "verify that a text in the page exists and is not returning an error 404" do
    @driver.get(@base_url + "/General_Testing/?LID1=KW&ckm_key=iKYsdeFiwxk&ckm_campaign_id=2071&PN=888-560-1681")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Northcentral University/
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should_not =~ /404/
  end
	
	it "check the page for embeded scripts (GA / GTM / Liveball / Conversion Frame)" do
    @driver.get(@base_url + "/General_Testing/?LID1=KW&ckm_key=iKYsdeFiwxk&ckm_campaign_id=2071&PN=888-560-1681")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Northcentral University/
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should_not =~ /404/
    verify { @driver.find_element(:css, "script[src='http://www.google-analytics.com/ga.js']").should be_true }
	verify { @driver.find_element(:css, "script[src='//www.googletagmanager.com/gtm.js?id=GTM-NMWHVX']").should be_true }
	verify { @driver.find_element(:css, "script[src='//www.googleadservices.com/pagead/conversion.js']").should be_true }
  end
	
	it "verify that no selection for the Edu level and Interest was caught by the step 1 form" do
    @driver.get(@base_url + "/General_Testing/?LID1=KW&ckm_key=iKYsdeFiwxk&ckm_campaign_id=2071&PN=888-560-1681")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Northcentral University/
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should_not =~ /404/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Step 1 of 2/
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "select.pf_field_row_bad").size).should == 2
    (@driver.find_elements(:css, "select.pf_field_row_bad").size).should_not == 0
  end
  
	it "submit step 1 with valid information and verify that step 2 of the form exists" do
    @driver.get(@base_url + "/General_Testing/?LID1=KW&ckm_key=iKYsdeFiwxk&ckm_campaign_id=2071&PN=888-560-1681")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Northcentral University/
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should_not =~ /404/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Step 1 of 2/
    #workaround for the missing dropdown selection during the export from the IDE
    @education_select = @driver.find_element(:name=> "EDUComplete")
    @education = @education_select.find_elements(:tag_name => "option")
    @education.each do |a|
    	if (a.text == "Bachelor's Degree")
    	a.click()
    		break
    	end
    end
    @interest_select = @driver.find_element(:name=> "areaOfInterest")
    @interest = @interest_select.find_elements(:tag_name=>"option")
    @interest.each do |b|
    	if (b.text=="Business")
    	b.click()
    		break
    	end
    end
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "select.pf_field_row_bad").size).should == 0
    (@driver.find_elements(:css, "select.pf_field_row_bad").size).should_not == 2
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Step 2 of 2/
  end
	
	it "verify that the form will catch the invalid Zip and Phone format" do
    @driver.get(@base_url + "/General_Testing/?LID1=KW&ckm_key=iKYsdeFiwxk&ckm_campaign_id=2071&PN=888-560-1681")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Northcentral University/
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should_not =~ /404/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Step 1 of 2/
    #workaround for the missing dropdown selection during the export from the IDE
    @education_select = @driver.find_element(:name=> "EDUComplete")
    @education = @education_select.find_elements(:tag_name => "option")
    @education.each do |a|
    	if (a.text == "Bachelor's Degree")
    	a.click()
    		break
    	end
    end
    @interest_select = @driver.find_element(:name=> "areaOfInterest")
    @interest = @interest_select.find_elements(:tag_name=>"option")
    @interest.each do |b|
    	if (b.text=="Business")
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
	@driver.find_element(:id, "AddressZip").clear
	@driver.find_element(:id, "AddressZip").send_keys "60aaa"
    #workaround for the missing dropdown selection during the export from the IDE
    @state_select = @driver.find_element(:name => "AddressState")
    @state = @state_select.find_elements(:tag_name=>"option")
    @state.each do |c|
    	if (c.text=="Illinois")
    	c.click()
    		break
    	end
    end
	@driver.find_element(:id, "Email").clear
    @driver.find_element(:id, "Email").send_keys "test@test.com"
	@driver.find_element(:id, "Phone").clear
    @driver.find_element(:id, "Phone").send_keys "8888888ABC"
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should == 2
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should_not == 0
  end
	
	it "test validation for the Email field" do
    @driver.get(@base_url + "/General_Testing/?LID1=KW&ckm_key=iKYsdeFiwxk&ckm_campaign_id=2071&PN=888-560-1681")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Northcentral University/
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should_not =~ /404/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Step 1 of 2/
    #workaround for the missing dropdown selection during the export from the IDE
    @education_select = @driver.find_element(:name=> "EDUComplete")
    @education = @education_select.find_elements(:tag_name => "option")
    @education.each do |a|
    	if (a.text == "Bachelor's Degree")
    	a.click()
    		break
    	end
    end
    @interest_select = @driver.find_element(:name=> "areaOfInterest")
    @interest = @interest_select.find_elements(:tag_name=>"option")
    @interest.each do |b|
    	if (b.text=="Business")
    	b.click()
    		break
    	end
    end
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "select.pf_field_row_bad").size).should == 0
    (@driver.find_elements(:css, "select.pf_field_row_bad").size).should_not == 2
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Step 2 of 2/
	@program_select = @driver.find_element(:name=> "_Program")
    @program = @program_select.find_elements(:tag_name => "option")
    @program.each do |d|
    	if (d.text == "MBA - Accelerated General MBA")
    	d.click()
    		break
    	end
    end
    @driver.find_element(:id, "NameFirst").clear
    @driver.find_element(:id, "NameFirst").send_keys "ckmtest"
    @driver.find_element(:id, "NameLast").clear
    @driver.find_element(:id, "NameLast").send_keys "ckmtest"
	@driver.find_element(:id, "AddressZip").clear
    @driver.find_element(:id, "AddressZip").send_keys "60601"
    #workaround for the missing dropdown selection during the export from the IDE
    @state_select = @driver.find_element(:name => "AddressState")
    @state = @state_select.find_elements(:tag_name=>"option")
    @state.each do |c|
    	if (c.text=="Illinois")
    	c.click()
    		break
    	end
    end
    @driver.find_element(:id, "Email").clear
    @driver.find_element(:id, "Email").send_keys "test"
	@driver.find_element(:id, "Phone").clear
    @driver.find_element(:id, "Phone").send_keys "8888888888"
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should == 1
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should_not == 0
    @driver.find_element(:id, "Email").clear
    @driver.find_element(:id, "Email").send_keys "test@"
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should == 1
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should_not == 0
    @driver.find_element(:id, "Email").clear
    @driver.find_element(:id, "Email").send_keys "test@test"
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should == 1
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should_not == 0
  end
    
	it "submit with valid information and verify a thank you pag exists - Graduate" do
    @driver.get(@base_url + "/General_Testing/?LID1=KW&ckm_key=iKYsdeFiwxk&ckm_campaign_id=2071&PN=888-560-1681")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Northcentral University/
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
    	if (b.text=="Business")
    	b.click()
    		break
    	end
    end
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "select.pf_field_row_bad").size).should == 0
    (@driver.find_elements(:css, "select.pf_field_row_bad").size).should_not == 2
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Step 2 of 2/
	@program_select = @driver.find_element(:id=> "_Program")
    @program = @program_select.find_elements(:tag_name => "option")
    @program.each do |d|
    	if (d.text == "MBA - Accelerated General MBA")
    	d.click()
    		break
    	end
    end
    @driver.find_element(:id, "NameFirst").clear
    @driver.find_element(:id, "NameFirst").send_keys "ckmtest"
    @driver.find_element(:id, "NameLast").clear
    @driver.find_element(:id, "NameLast").send_keys "ckmtest"
	@driver.find_element(:id, "AddressZip").clear
	@driver.find_element(:id, "AddressZip").send_keys "60601"
    #workaround for the missing dropdown selection during the export from the IDE
    @state_select = @driver.find_element(:id => "AddressState")
    @state = @state_select.find_elements(:tag_name=>"option")
    @state.each do |c|
    	if (c.text=="Illinois")
    	c.click()
    		break
    	end
    end
    @driver.find_element(:id, "Email").clear
    @driver.find_element(:id, "Email").send_keys "test@test.com"
	@driver.find_element(:id, "Phone").clear
    @driver.find_element(:id, "Phone").send_keys "8888888888"
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should == 0
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should_not == 1
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /To learn more about Northcentral/
  end
	
	it "submit with valid information and verify that a thank you page exists - Undergrad" do
    @driver.get(@base_url + "/General_Testing/?LID1=KW&ckm_key=iKYsdeFiwxk&ckm_campaign_id=2071&PN=888-560-1681")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Northcentral University/
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should_not =~ /404/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Step 1 of 2/
    #workaround for the missing dropdown selection during the export from the IDE
    @education_select = @driver.find_element(:name=> "EDUComplete")
    @education = @education_select.find_elements(:tag_name => "option")
    @education.each do |a|
    	if (a.text == "Some College")
    	a.click()
    		break
    	end
    end
    @interest_select = @driver.find_element(:name=> "areaOfInterest")
    @interest = @interest_select.find_elements(:tag_name=>"option")
    @interest.each do |b|
    	if (b.text=="Business")
    	b.click()
    		break
    	end
    end
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "select.pf_field_row_bad").size).should == 0
    (@driver.find_elements(:css, "select.pf_field_row_bad").size).should_not == 2
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Step 2 of 2/
	@program_select = @driver.find_element(:name=> "_Program")
    @program = @program_select.find_elements(:tag_name => "option")
    @program.each do |d|
    	if (d.text == "MBA - Accelerated General MBA")
    	d.click()
    		break
    	end
    end
    @driv
    @driver.find_element(:id, "NameFirst").clear
    @driver.find_element(:id, "NameFirst").send_keys "ckmtest"
    @driver.find_element(:id, "NameLast").clear
    @driver.find_element(:id, "NameLast").send_keys "ckmtest"
	@driver.find_element(:id, "AddressZip").clear
	@driver.find_element(:id, "AddressZip").send_keys "60601"
    #workaround for the missing dropdown selection during the export from the IDE
    @state_select = @driver.find_element(:name => "AddressState")
    @state = @state_select.find_elements(:tag_name=>"option")
    @state.each do |c|
    	if (c.text=="Illinois")
    	c.click()
    		break
    	end
    end
    @driver.find_element(:id, "Email").clear
    @driver.find_element(:id, "Email").send_keys "test@test.com"
	@driver.find_element(:id, "Phone").clear
    @driver.find_element(:id, "Phone").send_keys "8888888888"
    @driver.find_element(:name, "ball$ctl87").click
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should == 0
    (@driver.find_elements(:css, "input.pf_field_row_bad").size).should_not == 1
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /To learn more about Northcentral/
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