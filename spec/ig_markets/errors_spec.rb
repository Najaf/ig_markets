describe IGMarkets::IGMarketsError do
  it 'builds the correct error type based on the error code' do
    {
      'authentication.failure.not-a-client-account' => IGMarkets::Errors::InvalidClientAccountError,
      'endpoint.unavailable.for.api-key' => IGMarkets::Errors::APIKeyRejectedError,
      'error.confirms.deal-not-found' => IGMarkets::Errors::DealNotFoundError,
      'error.invalid.daterange' => IGMarkets::Errors::InvalidDateRangeError,
      'error.invalid.watchlist' => IGMarkets::Errors::InvalidWatchlistError,
      'error.malformed.date' => IGMarkets::Errors::MalformedDateError,
      'error.position.notfound' => IGMarkets::Errors::PositionNotFoundError,
      'error.positions.generic' => IGMarkets::Errors::PositionError,
      'error.public-api.epic-not-found' => IGMarkets::Errors::EPICNotFoundError,
      'error.public-api.exceeded-account-allowance' => IGMarkets::Errors::ExceededAccountAllowanceError,
      'error.public-api.exceeded-account-historical-data-allowance' =>
        IGMarkets::Errors::ExceededAccountHistoricalDataAllowanceError,
      'error.public-api.exceeded-account-trading-allowance' => IGMarkets::Errors::ExceededAccountTradingAllowanceError,
      'error.public-api.exceeded-api-key-allowance' => IGMarkets::Errors::ExceededAPIKeyAllowanceError,
      'error.public-api.failure.encryption.required' => IGMarkets::Errors::EncryptionRequiredError,
      'error.public-api.failure.kyc.required' => IGMarkets::Errors::KYCRequiredForAccountError,
      'error.public-api.failure.missing.credentials' => IGMarkets::Errors::MissingCredentialsError,
      'error.public-api.failure.pending.agreements.required' => IGMarkets::Errors::PendingAgreementsError,
      'error.public-api.failure.preferred.account.disabled' => IGMarkets::Errors::PreferredAccountDisabledError,
      'error.public-api.failure.preferred.account.not.set' => IGMarkets::Errors::PreferredAccountNotSetError,
      'error.public-api.failure.stockbroking-not-supported' => IGMarkets::Errors::StockbrokingNotSupportedError,
      'error.public-api.too-many-epics' => IGMarkets::Errors::TooManyEPICSError,
      'error.request.invalid.date-range' => IGMarkets::Errors::InvalidDateRangeError,
      'error.request.invalid.page-size' => IGMarkets::Errors::InvalidPageSizeError,
      'error.security.account-access-denied' => IGMarkets::Errors::AccountAccessDeniedError,
      'error.security.account-migrated' => IGMarkets::Errors::AccountMigratedError,
      'error.security.account-not-yet-activated' => IGMarkets::Errors::AccountNotYetActivatedError,
      'error.security.account-suspended' => IGMarkets::Errors::AccountSuspendedError,
      'error.security.account-token-invalid' => IGMarkets::Errors::AccountTokenInvalidError,
      'error.security.account-token-missing' => IGMarkets::Errors::AccountTokenMissingError,
      'error.security.all-accounts-pending' => IGMarkets::Errors::AllAccountsPendingError,
      'error.security.all-accounts-suspended' => IGMarkets::Errors::AllAccountsSuspendedError,
      'error.security.api-key-disabled' => IGMarkets::Errors::APIKeyDisabledError,
      'error.security.api-key-invalid' => IGMarkets::Errors::APIKeyInvalidError,
      'error.security.api-key-missing' => IGMarkets::Errors::APIKeyMissingError,
      'error.security.api-key-restricted' => IGMarkets::Errors::APIKeyRestrictedError,
      'error.security.api-key-revoked' => IGMarkets::Errors::APIKeyRevokedError,
      'error.security.authentication.timeout' => IGMarkets::Errors::AuthenticationTimeoutError,
      'error.security.client-suspended' => IGMarkets::Errors::ClientSuspendedError,
      'error.security.client-token-invalid' => IGMarkets::Errors::ClientTokenInvalidError,
      'error.security.client-token-missing' => IGMarkets::Errors::ClientTokenMissingError,
      'error.security.generic' => IGMarkets::Errors::SecurityError,
      'error.security.get.session.timeout' => IGMarkets::Errors::GetSessionTimeoutError,
      'error.security.invalid-application' => IGMarkets::Errors::InvalidApplicationError,
      'error.security.invalid-details' => IGMarkets::Errors::InvalidCredentialsError,
      'error.security.invalid-website' => IGMarkets::Errors::InvalidWebsiteError,
      'error.security.oauth-token-invalid' => IGMarkets::Errors::OAuthTokenInvalidError,
      'error.security.too-many-failed-attempts' => IGMarkets::Errors::TooManyFailedLoginAttemptsError,
      'error.service.create.stockbroking.share-order.instrumentdata-invalid' =>
        IGMarkets::Errors::InvalidShareOrderInstrumentDataError,
      'error.service.watchlists.add-instrument.invalid-epic' => IGMarkets::Errors::WatchlistInvalidEPICError,
      'error.sprintmarket.create-position.expiry.outside-valid-range' =>
        IGMarkets::Errors::SprintMarketPositionInvalidExpiryError,
      'error.sprintmarket.create-position.failure' => IGMarkets::Errors::SprintMarketPositionCreateError,
      'error.sprintmarket.create-position.market-closed' => IGMarkets::Errors::SprintMarketPositionInvalidExpiryError,
      'error.sprintmarket.create-position.order-size.invalid' => IGMarkets::Errors::SprintMarketInvalidOrderSizeError,
      'error.switch.accountId-must-be-different' => IGMarkets::Errors::AccountAlreadyCurrentError,
      'error.switch.cannot-set-default-account' => IGMarkets::Errors::CannotSetDefaultAccountError,
      'error.switch.invalid-accountId' => IGMarkets::Errors::InvalidAccountIDError,
      'error.trading.otc.instrument-not-found' => IGMarkets::Errors::InstrumentNotFoundError,
      'error.trading.otc.market-orders.not-supported' => IGMarkets::Errors::MarketOrdersNotSupported,
      'error.unsupported.epic' => IGMarkets::Errors::UnsupportedEPICError,
      'error.watchlists.management.cannot-delete-watchlist' => IGMarkets::Errors::CannotDeleteWatchlistError,
      'error.watchlists.management.duplicate-name' => IGMarkets::Errors::DuplicateWatchlistNameError,
      'error.watchlists.management.error' => IGMarkets::Errors::WatchlistError,
      'error.watchlists.management.watchlist-not-found' => IGMarkets::Errors::WatchlistNotFoundError,
      'invalid.input' => IGMarkets::Errors::InvalidInputError,
      'invalid.input.too.many.markets' => IGMarkets::Errors::TooManyMarketsError,
      'invalid.url' => IGMarkets::Errors::InvalidURLError,
      'service.clientsecurity.error.authentication.failure-generic' => IGMarkets::Errors::SecurityError,
      'system.error' => IGMarkets::Errors::SystemError,
      'unauthorised.access.to.equity.exception' => IGMarkets::Errors::UnauthorisedAccessToEquityError,
      'unauthorised.api-key.revoked' => IGMarkets::Errors::APIKeyRevokedError,
      'unauthorised.clientId.api-key.mismatch' => IGMarkets::Errors::InvalidAPIKeyForClientError
    }.each do |error_code, error_class|
      expect(described_class.build(error_code)).to be_a(error_class)
    end
  end

  it 'builds a base error and writes a one-time warning to stderr when the error code is unknown' do
    expect do
      expect(described_class.build('error.unknown')).to be_a(described_class)
      expect(described_class.build('error.unknown')).to be_a(described_class)
    end.to output("ig_markets: unrecognized error code error.unknown\n").to_stderr
  end
end
