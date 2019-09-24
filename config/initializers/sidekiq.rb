if Rails.env.production?
  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDISTOGO_URL'] || ENV['REDIS_URL'], size: 1 }
  end

  Sidekiq.configure_server do |config|
    pool_size = ENV['SIDEKIQ_DB_POOL'] || (Sidekiq.options[:concurrency] + 2)
    config.redis = { url: ENV['REDISTOGO_URL'] || ENV['REDIS_URL'], size: pool_size }

    Rails.application.config.after_initialize do
      size = ActiveRecord::Base.connection.pool.instance_variable_get('@size')
      Rails
        .logger
        .info(
          "DB Connection Pool size for SideKiq Server before disconnect is: #{size}"
        )
      ActiveRecord::Base.connection_pool.disconnect!
      ActiveSupport.on_load(:active_record) do
        db_config = Rails.application.config.database_configuration[Rails.env]
        db_config['reaping_frequency'] = ENV['DATABASE_REAP_FREQ'] || 10
        db_config['pool'] = pool_size
        ActiveRecord::Base.establish_connection(db_config)
        size = ActiveRecord::Base.connection.pool.instance_variable_get('@size')
        Rails
          .logger
          .info(
            "DB Connection Pool size for SideKiq Server is now: #{size}"
          )
      end
    end
  end
end
