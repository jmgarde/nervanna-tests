require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "PageCheck" do

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
  
  it "test_page_check" do
    @driver.get(@base_url + "/Education_Original/?LID1=KW&ckm_key=iKYsdeFiwxk&ckm_campaign_id=2071&PN=888-560-1681")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should =~ /Education At A Higher Degree/
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:tag_name => "body").text.should_not =~ /404/
    p "TEST END - PAGE CHECK"
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
