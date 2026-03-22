class VaProfilesController < ApplicationController
  before_action :set_va_profile, only: %i[ show edit update destroy ]

  def index
    @va_profiles = VaProfile.all
  end

  def show
  end

  def new
    @va_profile = VaProfile.new
  end

  def edit
  end

  def create
    @va_profile = VaProfile.new(va_profile_params)

    respond_to do |format|
      if @va_profile.save
        format.html { redirect_to @va_profile, notice: "Profile saved successfully." }
        format.json { render :show, status: :created, location: @va_profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @va_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @va_profile.update(va_profile_params)
        format.html { redirect_to @va_profile, notice: "Profile updated successfully.", status: :see_other }
        format.json { render :show, status: :ok, location: @va_profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @va_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @va_profile.destroy!

    respond_to do |format|
      format.html { redirect_to va_profiles_path, notice: "Profile deleted.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_va_profile
    @va_profile = VaProfile.find(params.expect(:id))
  end

  def va_profile_params
    params.expect(va_profile: [ :niche, :budget ])
  end

 ##
  # Recommends a curated tool stack for a Virtual Assistant based on niche and budget.
  # ... (##
# Recommends a curated tool stack for a Virtual Assistant based on their niche and budget.
#
# This method uses a case/when pattern to match the VA's niche to a pre-defined
# list of tools. Each tool is represented as a hash with a name, description,
# and a boolean indicating whether it is free or paid. The budget filter then
# selects only free tools when the budget is below $50/month.
#
# @param niche [String] The VA's chosen niche. Accepted values:
#   - "General VA"
#   - "Travel & Itinerary VA"
#   - "Creative VA"
#   - "Social Media VA"
#   - "Lead Gen VA"
#   - "Real Estate VA"
#   - "Tech VA"
#   Any other value falls through to the else clause and returns a basic starter stack.
#
# @param budget [String, Integer] The VA's monthly tool budget in USD.
#   Accepts a string (from form input) or integer. Converted internally via .to_i.
#   - budget >= 50 → returns all tools (free and paid)
#   - budget < 50  → returns free tools only
#
# @return [Array<Hash>] An array of tool hashes. Each hash contains:
#   - :name [String]  — the tool's display name (e.g. "Notion")
#   - :desc [String]  — a short description of what the tool does
#   - :free [Boolean] — true if the tool has a usable free tier, false if paid only
#
# @raises [NoMethodError] If niche or budget is nil and .to_i or case comparison fails.
#   Always ensure the form validates presence of both fields before calling this method.
#
# @example Budget >= $50 — returns full stack including paid tools
#   recommend_tools("General VA", 100)
#   # => [
#   #   { name: "Google Workspace", desc: "Email, Docs, Drive & Calendar suite", free: false },
#   #   { name: "Trello",           desc: "Visual task & project management",     free: true  },
#   #   { name: "Calendly",         desc: "Automated meeting scheduling",          free: true  },
#   #   { name: "Notion",           desc: "All-in-one notes, docs & wikis",        free: true  },
#   #   { name: "LastPass",         desc: "Secure password management",            free: true  }
#   # ]
#
# @example Budget < $50 — returns free tools only
#   recommend_tools("General VA", 0)
#   # => [
#   #   { name: "Trello",    desc: "Visual task & project management", free: true },
#   #   { name: "Calendly",  desc: "Automated meeting scheduling",      free: true },
#   #   { name: "Notion",    desc: "All-in-one notes, docs & wikis",    free: true },
#   #   { name: "LastPass",  desc: "Secure password management",        free: true }
#   # ]
#
# @example Unrecognised niche — returns generic starter stack
#   recommend_tools("Unknown", 100)
#   # => [
#   #   { name: "Notion",       desc: "All-in-one workspace to get started", free: true },
#   #   { name: "Slack",        desc: "Team communication & collaboration",   free: true },
#   #   { name: "Zoom",         desc: "Video meetings & client calls",        free: true },
#   #   { name: "Google Drive", desc: "Cloud storage & file sharing",         free: true }
#   # ]
#
# @note This method is exposed to views via helper_method :recommend_tools
#   so it can be called directly inside ERB templates without @controller prefix.
#
# @note Edge case: if budget.to_i >= 50 but ALL tools for a niche are free: true,
#   the result is the same whether budget is 0 or 100 (e.g. Travel & Itinerary VA).
#
# @note To add a new niche, add a new `when` clause following the existing pattern
#   and ensure the form dropdown in app/views/va_profiles/_form.html.erb
#   includes the matching string value.)
  
  def recommend_tools(niche, budget)
    tools = case niche
    when "General VA"
      [
        { name: "Google Workspace", desc: "Email, Docs, Drive & Calendar suite", free: false },
        { name: "Trello", desc: "Visual task & project management", free: true },
        { name: "Calendly", desc: "Automated meeting scheduling", free: true },
        { name: "Notion", desc: "All-in-one notes, docs & wikis", free: true },
        { name: "LastPass", desc: "Secure password management", free: true }
      ]
    when "Travel & Itinerary VA"
      [
        { name: "TripIt", desc: "Organise travel plans & itineraries", free: true },
        { name: "Google Flights", desc: "Flight research & price tracking", free: true },
        { name: "Booking.com Extranet", desc: "Hotel & accommodation management", free: true },
        { name: "Notion", desc: "Build & share client itineraries", free: true },
        { name: "Calendly", desc: "Coordinate travel schedules", free: true }
      ]
    when "Creative VA"
      [
        { name: "Canva Pro", desc: "Professional graphic design platform", free: false },
        { name: "Adobe Express", desc: "Quick branded content creation", free: true },
        { name: "Loom", desc: "Async video messaging & screen recording", free: true },
        { name: "Grammarly", desc: "AI writing assistant & proofreader", free: true },
        { name: "Notion", desc: "Content planning & client docs", free: true }
      ]
    when "Social Media VA"
      [
        { name: "Buffer", desc: "Social media scheduling & analytics", free: true },
        { name: "Hootsuite", desc: "Multi-platform social media management", free: false },
        { name: "Later", desc: "Visual Instagram & TikTok planner", free: true },
        { name: "Canva Pro", desc: "Social graphics & branded templates", free: false },
        { name: "Meta Business Suite", desc: "Facebook & Instagram management", free: true }
      ]
    when "Lead Gen VA"
      [
        { name: "Hunter.io", desc: "Find & verify professional email addresses", free: true },
        { name: "Apollo.io", desc: "B2B prospecting & outreach platform", free: true },
        { name: "HubSpot CRM", desc: "Free CRM for pipeline management", free: true },
        { name: "Lemlist", desc: "Personalised cold email campaigns", free: false },
        { name: "LinkedIn Sales Navigator", desc: "Advanced lead search & tracking", free: false }
      ]
    when "Real Estate VA"
      [
        { name: "HubSpot CRM", desc: "Lead tracking & client follow-ups", free: true },
        { name: "DocuSign", desc: "Digital signatures for contracts", free: false },
        { name: "Zillow", desc: "Property research & market analysis", free: true },
        { name: "Calendly", desc: "Schedule property showings & client calls", free: true },
        { name: "Trello", desc: "Transaction coordination & task tracking", free: true }
      ]
    when "Tech VA"
      [
        { name: "n8n", desc: "Open-source AI-native workflow automation", free: true },
        { name: "Zapier", desc: "No-code automation between apps", free: true },
        { name: "Make.com", desc: "Visual workflow automation builder", free: true },
        { name: "Notion AI", desc: "AI-powered workspace & documentation", free: false },
        { name: "Postman", desc: "API testing & workflow integration", free: true }
      ]
    else
      [
        { name: "Notion", desc: "All-in-one workspace to get started", free: true },
        { name: "Slack", desc: "Team communication & collaboration", free: true },
        { name: "Zoom", desc: "Video meetings & client calls", free: true },
        { name: "Google Drive", desc: "Cloud storage & file sharing", free: true }
      ]
    end

    budget.to_i >= 50 ? tools : tools.select { |t| t[:free] == true }
  end
  helper_method :recommend_tools
end
