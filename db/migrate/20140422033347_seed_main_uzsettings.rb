# -*- encoding : utf-8 -*-
class SeedMainUzsettings < ActiveRecord::Migration
  def up    
    UzSettings.create "Main" do |m|
      m.group :general, "General" do |g|
        g.string "Website Title", :website_title, ""
      end

      m.group :seo, "SEO Meta Tags" do |g|
        g.text "Meta Tag Description", :meta_tag_description, ""
        g.text "Meta Tag Keywords", :meta_tag_keywords, ""
      end

      m.group :google_analytics, "Google Analytics" do |g|
        g.string "Tracker", :tracker, ""
        g.string "Domain", :domain, ""
      end

      m.group :social, "Facebook / Sharing" do |g|
        g.text "OG Default Description", :og_description, ""
        g.image "OG Default Image", :og_image, ""
        g.string "App Id", :facebook_app_id, ""
        g.string "Admins User Ids", :facebook_admins_user_ids, "", hint: ""
        g.string "Base Website Url", :base_url, ""
      end
    end
  end

  def down
    UzSettings.destroy("Main")
  end
end
