class Charity < ActiveRecord::Base
	enum role: [:suggested, :claimed, :approved]
end
