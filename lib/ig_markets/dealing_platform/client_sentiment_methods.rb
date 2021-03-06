module IGMarkets
  class DealingPlatform
    # Provides methods for working with client sentiment. Returned by {DealingPlatform#client_sentiment}.
    class ClientSentimentMethods
      # Initializes this helper class with the specified dealing platform.
      #
      # @param [DealingPlatform] dealing_platform The dealing platform.
      def initialize(dealing_platform)
        @dealing_platform = WeakRef.new dealing_platform
      end

      # Returns the client sentiment for a market.
      #
      # @param [String] market_id The ID of the market to return client sentiment for.
      #
      # @return [ClientSentiment]
      def [](market_id)
        result = @dealing_platform.session.get "clientsentiment/#{market_id}"

        @dealing_platform.instantiate_models(ClientSentiment, result).tap do |client_sentiment|
          if client_sentiment.long_position_percentage == 0.0 && client_sentiment.short_position_percentage == 0.0
            raise ArgumentError, "unknown market '#{market_id}'"
          end
        end
      end
    end
  end
end
