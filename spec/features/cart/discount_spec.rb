require 'rails_helper'

RSpec.describe "as a regular user" do
  before :each do
    @megan = Merchant.create!(name: 'Megans Magical Menegerie', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
    @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
    @fairy = @megan.items.create!(name: 'Fairy', description: "I'm a Fairy!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
    @djinn = @megan.items.create!(name: 'Djinn', description: "I'm a Djinn!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
    @ifrit = @megan.items.create!(name: 'Ifrit', description: "I'm an Ifrit!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
    @discount_1 = @megan.discounts.create!(percent: 5, quantity_required: 2)
    @discount_2 = @megan.discounts.create!(percent: 10, quantity_required: 3)

    @brian = Merchant.create!(name: 'Brians Bargain Blompostomii', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
    @platy = @brian.items.create!(name: 'Platy', description: "I'm a Platypus!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
    @lemur = @brian.items.create!(name: 'Lemur', description: "I'm a Lemur!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
    @discount_3 = @brian.discounts.create!(percent: 10, quantity_required: 4)

    @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 0)

    visit "/login"
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button "Log In"
  end

  it "when I add enough of one item to my cart to qualify for a discount from that item's merchant, the discount is automatically applied only to that item" do
    visit item_path(@ogre)
    click_button 'Add to Cart'
    visit item_path(@ogre)
    click_button 'Add to Cart'
    visit item_path(@ifrit)
    click_button 'Add to Cart'
    visit item_path(@platy)
    click_button 'Add to Cart'
    visit item_path(@platy)
    click_button 'Add to Cart'

    visit "/cart"

    within "#item-#{@ogre.id}" do
      expect(page).to have_content("5% Discount Applied")
      expect(page).to have_content("Savings: $5.00")
      expect(page).to have_content("Subtotal: $95.00")
    end

    within "#item-#{@ifrit.id}" do
      expect(page).to have_content("No Discount Applied")
      expect(page).to have_content("Subtotal: $50.00")
    end

    within "#item-#{@platy.id}" do
      expect(page).to have_content("No Discount Applied")
      expect(page).to have_content("Subtotal: $100.00")
    end
  end

  xit "when I add the qualifying quantity of one item that applies to multiple discounts, I see the highest of the discounts applied" do

  end
end
