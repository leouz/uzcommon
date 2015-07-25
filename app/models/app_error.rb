class AppError < ActiveRecord::Base
  attr_accessible :where, :backtrace, :message

  def self.create_from_exception where, exception
    AppError.create where: where, message: exception.message, backtrace: exception.backtrace
  end
end
