# ToolRecommender is a service object responsible for all tool
# recommendation logic. It keeps the controller thin by moving
# business logic into a dedicated, testable class.
#
# Usage:
#   recommender = ToolRecommender.new("General VA", 100)
#   recommender.call
#   # => [{ name: "Google Workspace", desc: "...", free: false }, ...]

class ToolRecommender
  # Path to the YAML file containing all tool data
  TOOLS_FILE = Rails.root.join("config", "va_tools.yml")

  # @param niche [String] The VA's chosen niche
  # @param budget [String, Integer] The VA's monthly budget in USD
  def initialize(niche, budget)
    @niche  = niche
    @budget = budget.to_i
  end

  # Entry point — call this method to get the recommended tools
  # @return [Array<Hash>] filtered list of tools
  def call
    apply_budget_filter(tools_for_niche)
  end

  private

  # Loads and caches the YAML tool data, converts keys to symbols
  # @return [Hash] all tools keyed by niche name
  def all_tools
    Rails.cache.fetch("va_tools") do
      YAML.load_file(TOOLS_FILE).transform_values do |tools|
        tools.map(&:symbolize_keys)
      end
    end
  end

  # Returns the tool array for the given niche.
  # Falls back to "default" if niche is not found.
  # @return [Array<Hash>]
  def tools_for_niche
    all_tools[@niche] || all_tools["default"]
  end

  # Applies the three-tier budget filter:
  #   $0        — free tools only
  #   $1–$49    — free tools + first paid tool as recommended upgrade
  #   $50+      — full stack including all paid tools
  # @param tools [Array<Hash>]
  # @return [Array<Hash>]
  def apply_budget_filter(tools)
    case @budget
    when 50..Float::INFINITY
      tools
    when 1..49
      free_tools = tools.select { |t| t[:free] == true }
      first_paid = tools.find { |t| t[:free] == false }
      if first_paid
        free_tools + [ first_paid.merge(desc: "#{first_paid[:desc]} ⭐ Recommended upgrade") ]
      else
        free_tools
      end
    else
      tools.select { |t| t[:free] == true }
    end
  end
end