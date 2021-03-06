module IGMarkets
  # Contains details on a single activity that occurred on an IG Markets account. Returned by
  # {DealingPlatform::AccountMethods#activities}.
  class Activity < Model
    # Contains additional details on an activity. Returned by {#details}.
    class Details < Model
      # Contains details on the actions that were performed by an activity. Returned by {#actions}.
      class Action < Model
        attribute :action_type, Symbol, allowed_values: %i[limit_order_amended limit_order_deleted
                                                           limit_order_filled limit_order_opened limit_order_rolled
                                                           position_closed position_deleted position_opened
                                                           position_partially_closed position_rolled
                                                           stop_limit_amended stop_order_amended stop_order_deleted
                                                           stop_order_filled stop_order_opened stop_order_rolled
                                                           unknown working_order_deleted]
        attribute :affected_deal_id
      end

      attribute :actions, Action
      attribute :currency
      attribute :deal_reference
      attribute :direction, Symbol, allowed_values: %i[buy sell]
      attribute :good_till_date
      attribute :guaranteed_stop, Boolean
      attribute :level, Float
      attribute :limit_distance, Integer
      attribute :limit_level, Float
      attribute :market_name
      attribute :size
      attribute :stop_distance, Integer
      attribute :stop_level, Float
      attribute :trailing_step, Float
      attribute :trailing_stop_distance, Integer
    end

    attribute :channel, Symbol, allowed_values: %i[dealer mobile public_fix_api public_web_api system web]
    attribute :date, Time, format: '%FT%T'
    attribute :deal_id
    attribute :description
    attribute :details, Details
    attribute :epic, String, regex: Regex::EPIC
    attribute :period, Time, nil_if: %w[- DFB], format: ['%FT%T', '%d-%b-%y', '%b-%y']
    attribute :status, Symbol, allowed_values: %i[accepted rejected unknown]
    attribute :type, Symbol, allowed_values: %i[edit_stop_and_limit position system working_order]
  end
end
