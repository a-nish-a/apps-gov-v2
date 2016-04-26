require "rails_helper"

feature "A Government User creates a Product Request" do
  before { login_as(user, scope: :government_user) }

  context "that is unique" do
    scenario "and successfully creates the request" do
      visit product_path(product)

      click_button t("products.product_sidebar.get_product")

      expect(page).to have_text t("product_requests.create.success")
    end
  end

  context "that is not unique" do
    before { create(:product_request, product: product, user: user) }

    scenario "and sees an error" do
      visit product_path(product)

      click_button t("products.product_sidebar.get_product")

      expect(page).to have_text t("product_requests.create.failure")
    end
  end

  def product
    @product ||= create(:product)
  end

  def user
    @user ||= create(:user, :with_gov_email)
  end
end
