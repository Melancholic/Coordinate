require 'rails_helper'

describe "StaticPages" do
  subject{ page }
  describe "Home page" do
    before do
      visit root_path
    end
    it { should have_title(full_title(''))}
  end
  describe "FAQ page" do
  before { visit faq_path }
    it {should have_content("FAQ") }
    it {should have_title(full_title("FAQ")) }
  end 
  describe "About page" do
  before { visit about_path }
    it {should have_title(full_title("About")) }
  end 
  describe "Contacts page" do
  before { visit contacts_path }
    it {should have_selector('h1', text: 'to contact me') }
    it {should have_title(full_title("Contacts"))}
  end 

  it "should have the right links on the Layout" do
    visit root_path;
    should_not have_link('Home',root_path);
    click_link("About");
    expect(page).to have_title(full_title('About'));
    should have_link('Home',root_path);
    click_link("Home");   
    expect(page).to have_title(full_title(''));
    click_link("Contacts");
    expect(page).to have_title(full_title('Contacts'));

  end
end

