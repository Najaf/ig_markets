module IGMarkets
  class DealingPlatform
    # Provides methods for working with the logged in account. Returned by {DealingPlatform#account}.
    class AccountMethods
      # Initializes this helper class with the specified dealing platform.
      #
      # @param [DealingPlatform] dealing_platform The dealing platform.
      def initialize(dealing_platform)
        @dealing_platform = WeakRef.new dealing_platform
      end

      # Returns all accounts associated with the current IG Markets login.
      #
      # @return [Array<Account>]
      def all
        result = @dealing_platform.session.get('accounts').fetch :accounts

        @dealing_platform.instantiate_models Account, result
      end

      # Returns activities for this account in the specified time range.
      #
      # @param [Hash] options The options hash.
      # @option options [Time] :from The start of the period to return activities for. Required.
      # @option options [Time] :to The end of the period to return activities for. Defaults to `Time.now`.
      #
      # @return [Array<Activity>]
      def activities(options)
        url_parameters = history_url_parameters options
        url_parameters[:detailed] = true

        history_request_complete url: 'history/activity', url_parameters: url_parameters, api_version: API_V3,
                                 collection_name: :activities, model_class: Activity, date_attribute: :date
      end

      # Returns transactions for this account in the specified time range.
      #
      # @param [Hash] options The options hash.
      # @option options [:all, :all_deal, :deposit, :withdrawal] :type The type of transactions to return. Defaults to
      #                 `:all`.
      # @option options [Time] :from The start of the period to return transactions for. Required.
      # @option options [Time] :to The end of the period to return transactions for. Defaults to `Time.now`.
      #
      # @return [Array<Transaction>]
      def transactions(options)
        options[:type] ||= :all

        unless %i[all all_deal deposit withdrawal].include? options[:type]
          raise ArgumentError, "invalid transaction type: #{options[:type]}"
        end

        history_request_complete url: 'history/transactions', url_parameters: history_url_parameters(options),
                                 api_version: API_V2, collection_name: :transactions, model_class: Transaction,
                                 date_attribute: :date_utc
      end

      private

      # The maximum number of results the IG Markets API will return in one request.
      MAXIMUM_PAGE_SIZE = 500

      # Retrieves historical data for this account (either activities or transactions) in the specified time range. This
      # methods sends a single GET request with the passed URL parameters and returns the response. The maximum number
      # of items this method can return is capped at 500 ({MAXIMUM_PAGE_SIZE}).
      def history_request(options)
        url = "#{options[:url]}?#{URI.encode_www_form options[:url_parameters]}"

        get_result = @dealing_platform.session.get url, options.fetch(:api_version)

        @dealing_platform.instantiate_models options[:model_class], get_result.fetch(options[:collection_name])
      end

      # This method is the same as {#history_request} except it will send as many GET requests as are needed in order
      # to circumvent the maximum number of results that can be returned per request.
      def history_request_complete(options)
        models = []

        loop do
          request_result = history_request options
          models += request_result

          break if request_result.size < MAXIMUM_PAGE_SIZE

          # Update the :to parameter so the next GET request returns older results
          options[:url_parameters][:to] = request_result.last.send(options[:date_attribute]).utc.strftime('%FT%T')
        end

        models.uniq(&:to_h)
      end

      # Parses and formats options shared by {#activities} and {#transactions} into a set of URL parameters.
      def history_url_parameters(options)
        options[:to] ||= Time.now

        options[:from] = options.fetch(:from).utc.strftime('%FT%T')
        options[:to] = options.fetch(:to).utc.strftime('%FT%T')

        options[:pageSize] = MAXIMUM_PAGE_SIZE
        options[:type] = options[:type].to_s.upcase if options.key? :type

        options
      end
    end
  end
end
