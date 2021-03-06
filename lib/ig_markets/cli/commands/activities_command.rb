module IGMarkets
  module CLI
    # Implements the `ig_markets activities` command.
    class Main
      desc 'activities', 'Prints account activities'

      option :days, type: :numeric, desc: 'The number of days to print account activities for'
      option :from, desc: 'The date and time to print account activities from, format: yyyy-mm-ddThh:mm:ss(+|-)zz:zz'
      option :to, desc: 'The end date and time to print account transactions for, format: yyyy-mm-ddThh:mm:ss(+|-)zz:zz'
      option :epic, desc: 'Regex for filtering activities based on their EPIC'
      option :sort_by, enum: %w[channel date epic type], default: 'date', desc: 'The attribute to sort activities by'

      def activities
        self.class.begin_session(options) do |dealing_platform|
          @epic_regex = Regexp.new options.fetch('epic', ''), Regexp::IGNORECASE

          activities = gather_activities dealing_platform

          table = Tables::ActivitiesTable.new activities

          puts table
        end
      end

      private

      def gather_activities(dealing_platform)
        result = dealing_platform.account.activities(history_options).select do |activity|
          activity_filter activity
        end

        result.sort_by do |activity|
          [activity.send(activity_sort_attribute), activity.date]
        end
      end

      def activity_filter(activity)
        @epic_regex.match activity.epic
      end

      def activity_sort_attribute
        {
          'channel' => :channel,
          'date' => :date,
          'epic' => :epic,
          'type' => :transaction_type
        }.fetch options[:sort_by]
      end
    end
  end
end
